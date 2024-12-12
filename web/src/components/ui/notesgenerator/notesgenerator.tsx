"use client";
import ReactMarkdown from "react-markdown";

import React, { useState, useRef, useEffect } from "react";
import axios from "axios";
import { motion, AnimatePresence } from "framer-motion";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import {
  Upload,
  Youtube,
  BookOpen,
  PenTool,
  Download,
  List,
  X,
  Trash2,
  Eye,
} from "lucide-react";
import { SparklesCore } from "@/components/ui/sparkles";
import { BackgroundBeams } from "@/components/ui/background-beams";
import { jsPDF } from "jspdf";

type Note = {
  id: string;
  title: string;
  content: string;
  type: "upload" | "youtube" | "lecture" | "custom";
  createdAt: Date;
  pdfUrl?: string;
};

export default function NotesGenerator() {
  const [activeTab, setActiveTab] = useState("upload");
  const [notes, setNotes] = useState<{ [key: string]: Note | null }>({
    upload: null,
    youtube: null,
    lecture: null,
    custom: null,
  });
  const [allNotes, setAllNotes] = useState<Note[]>([]);
  const [pdfFile, setPdfFile] = useState<File | null>(null);
  const [pdfPreviewUrl, setPdfPreviewUrl] = useState<string | null>(null);
  const [youtubeLink, setYoutubeLink] = useState("");
  const [subject, setSubject] = useState("");
  const [topic, setTopic] = useState("");
  const [lectureNo, setLectureNo] = useState("");
  const [customNotes, setCustomNotes] = useState("");
  const [noteTitle, setNoteTitle] = useState("");
  const [selectedNote, setSelectedNote] = useState<Note | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    // Load all notes from local storage
    // ig baadme backend se fetch karke display kar sakte hai.
    const savedNotes = localStorage.getItem("allNotes");
    if (savedNotes) {
      setAllNotes(JSON.parse(savedNotes));
    }
  }, []);
  const saveNote = (
    type: "upload" | "youtube" | "lecture" | "custom",
    content: string,
    pdfUrl?: string
  ) => {
    if (!noteTitle) {
      alert("Please enter a title for your notes.");
      return;
    }

    const newNote: Note = {
      id: Date.now().toString(),
      title: noteTitle,
      content,
      type,
      createdAt: new Date(),
      pdfUrl,
    };

    setNotes((prev) => ({ ...prev, [type]: newNote }));
    setAllNotes((prev) => [...prev, newNote]);

    // Save to local storage
    localStorage.setItem("allNotes", JSON.stringify([...allNotes, newNote]));

    setNoteTitle("");
  };

  const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (file && file.type === "application/pdf") {
      setPdfFile(file);
      setPdfPreviewUrl(URL.createObjectURL(file));
    } else {
      alert("Please upload a valid PDF file.");
    }
  };

  const generatePDF = (content: string, title: string) => {
    const pdf = new jsPDF({
      orientation: "p",
      unit: "mm",
      format: "a4",
    });

    // Set font
    pdf.setFontSize(12);

    // Add title
    pdf.setFontSize(16);
    pdf.text(title || "Notes", 10, 10);

    // Add a line under the title
    pdf.setLineWidth(0.5);
    pdf.line(10, 15, 200, 15);

    // Reset font size for content
    pdf.setFontSize(10);

    // Convert content to plain text with better formatting
    const plainTextContent = content
      .replace(/^#+\s*/gm, "") // Remove headers
      .replace(/\*\*(.*?)\*\*/g, "$1") // Remove bold formatting
      .replace(/\*(.*?)\*/g, "$1") // Remove italic formatting
      .replace(/`(.*?)`/g, "$1") // Remove code formatting
      .replace(/\[(.*?)\]\(.*?\)/g, "$1") // Convert links to link text
      .replace(/^\s*[-*]\s*/gm, "• ") // Convert list markers
      .replace(/\n{3,}/g, "\n\n"); // Normalize multiple newlines

    // Split text with proper word wrapping
    const splitText = pdf.splitTextToSize(plainTextContent, 180);

    // Add text with automatic page breaking
    pdf.text(splitText, 15, 25);

    // Save PDF with a more robust method
    const pdfDataUri = pdf.output("datauristring");
    return pdfDataUri;
  };

  // Update handleFileUpload method
  const handleFileUpload = async () => {
    if (!pdfFile) {
      alert("No PDF file selected.");
      return;
    }

    const formData = new FormData();
    formData.append("pdf_file", pdfFile);

    try {
      const response = await axios.post(
        "http://localhost:5001/generate_notes_final",
        formData,
        {
          responseType: "blob",
        }
      );

      const pdfBlob = new Blob([response.data], { type: "application/pdf" });
      const pdfUrl = URL.createObjectURL(pdfBlob);

      // Read the content of the PDF
      const reader = new FileReader();
      reader.onload = async (e) => {
        const content = e.target?.result as string;
        const generatedPdfUrl = generatePDF(content, noteTitle);

        saveNote("upload", JSON.parse(content).notes, generatedPdfUrl);
      };
      reader.readAsText(response.data);

      alert("PDF uploaded and processed successfully!");
    } catch (error) {
      console.error("Error uploading and processing PDF:", error);
      alert("Failed to process the PDF.");
    }
  };

  // Similar modifications for handleYoutubeSubmit and handleLectureNotesSubmit
  const handleYoutubeSubmit = async () => {
    try {
      const response = await axios.post(
        "http://localhost:5001/yt_notes",
        { youtube_url: youtubeLink },
        { responseType: "json" }
      );

      const content = response.data.notes;
      const generatedPdfUrl = generatePDF(content, noteTitle);

      saveNote("youtube", content, generatedPdfUrl);
      alert("YouTube video processed successfully!");
    } catch (error) {
      console.log("Error processing YouTube video:", error);
      alert("Failed to process the YouTube video.");
    }
  };

  const handleLectureNotesSubmit = async () => {
    try {
      const fileresponse = await fetch("/transcript.txt");
      if (!fileresponse.ok) {
        throw new Error("Failed to fetch the transcript");
      }
      const transcriptContent = await fileresponse.text();

      const response = await axios.post(
        "http://localhost:5001/lecture_notes",
        { transcripts: transcriptContent },
        { responseType: "json" }
      );

      const content = response.data.notes;
      const generatedPdfUrl = generatePDF(content, noteTitle);

      saveNote("lecture", content, generatedPdfUrl);
      alert("Lecture notes processed successfully!");
    } catch (error) {
      console.log("Error processing Lecture notes:", error);
      alert("Failed to process the Lecture notes.");
    }
  };

  // Update handleCustomNotesGenerate
  const handleCustomNotesGenerate = () => {
    const generatedPdfUrl = generatePDF(customNotes, noteTitle);
    saveNote("custom", customNotes, generatedPdfUrl);
    alert("Custom notes generated successfully!");
  };

  const handleGenerateNew = (
    type: "upload" | "youtube" | "lecture" | "custom"
  ) => {
    setNotes((prev) => ({ ...prev, [type]: null }));
    if (type === "upload") {
      setPdfFile(null);
      setPdfPreviewUrl(null);
      if (fileInputRef.current) fileInputRef.current.value = "";
    } else if (type === "youtube") {
      setYoutubeLink("");
    } else if (type === "lecture") {
      setSubject("");
      setTopic("");
      setLectureNo("");
    } else if (type === "custom") {
      setCustomNotes("");
    }
  };

  const handleDownload = (pdfUrl: string | undefined, title: string) => {
    if (pdfUrl) {
      const link = document.createElement("a");
      link.href = pdfUrl;
      link.download = `${title}.pdf`;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    } else {
      alert("No PDF available for download.");
    }
  };

  const handleDelete = (id: string) => {
    setAllNotes((prev) => prev.filter((note) => note.id !== id));
    localStorage.setItem(
      "allNotes",
      JSON.stringify(allNotes.filter((note) => note.id !== id))
    );
  };

  return (
    <div className="min-h-screen bg-purple-50 p-8 relative overflow-hidden">
      <BackgroundBeams />
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className="w-full max-w-4xl mx-auto relative z-10"
      >
        <h1 className="text-5xl font-bold text-purple-800 mb-8 text-center relative">
          Notes Generator
          <SparklesCore
            id="tsparticles"
            background="transparent"
            minSize={0.6}
            maxSize={1.4}
            particleDensity={100}
            className="absolute inset-0 z-0"
            particleColor="#8B5CF6"
          />
        </h1>
        <Card className="overflow-hidden shadow-2xl rounded-3xl bg-white/90 backdrop-blur-sm">
          <CardContent className="p-0">
            <Tabs
              defaultValue="upload"
              className="w-full"
              onValueChange={setActiveTab}
            >
              <TabsList className="grid w-full grid-cols-5 bg-gradient-to-r from-purple-200 via-pink-200 to-blue-200 rounded-t-3xl p-1">
                <TabsTrigger
                  value="upload"
                  className="rounded-2xl data-[state=active]:bg-white data-[state=active]:text-purple-600 transition-all duration-300"
                >
                  <Upload className="w-5 h-5 mr-2" />
                  Upload
                </TabsTrigger>
                <TabsTrigger
                  value="youtube"
                  className="rounded-2xl data-[state=active]:bg-white data-[state=active]:text-pink-600 transition-all duration-300"
                >
                  <Youtube className="w-5 h-5 mr-2" />
                  YouTube
                </TabsTrigger>
                <TabsTrigger
                  value="lecture"
                  className="rounded-2xl data-[state=active]:bg-white data-[state=active]:text-blue-600 transition-all duration-300"
                >
                  <BookOpen className="w-5 h-5 mr-2" />
                  Lecture
                </TabsTrigger>
                <TabsTrigger
                  value="custom"
                  className="rounded-2xl data-[state=active]:bg-white data-[state=active]:text-green-600 transition-all duration-300"
                >
                  <PenTool className="w-5 h-5 mr-2" />
                  Custom
                </TabsTrigger>
                <TabsTrigger
                  value="all"
                  className="rounded-2xl data-[state=active]:bg-white data-[state=active]:text-yellow-600 transition-all duration-300"
                >
                  <List className="w-5 h-5 mr-2" />
                  All Notes
                </TabsTrigger>
              </TabsList>
              <div className="p-6">
                <TabsContent value="upload">
                  <div className="space-y-4">
                    <Label
                      htmlFor="note-title-upload"
                      className="block text-lg font-medium text-purple-600"
                    >
                      Note Title
                    </Label>
                    <Input
                      id="note-title-upload"
                      placeholder="Enter a title for your notes"
                      value={noteTitle}
                      onChange={(e) => setNoteTitle(e.target.value)}
                      className="border-purple-300 focus:border-purple-500 focus:ring-purple-500 rounded-xl"
                    />
                    <Label
                      htmlFor="file-upload"
                      className="block text-lg font-medium text-purple-600"
                    >
                      Upload PDF Document
                    </Label>
                    <div className="flex items-center justify-center w-full">
                      <label
                        htmlFor="file-upload"
                        className="flex flex-col items-center justify-center w-full h-64 border-2 border-purple-300 border-dashed rounded-2xl cursor-pointer bg-purple-50 hover:bg-purple-100 transition-all duration-300 relative overflow-hidden"
                      >
                        {pdfPreviewUrl ? (
                          <>
                            <iframe
                              src={pdfPreviewUrl}
                              className="absolute inset-0 w-full h-full"
                            />
                            <div className="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center">
                              <p className="text-white text-lg font-semibold">
                                Click to change PDF
                              </p>
                            </div>
                          </>
                        ) : (
                          <div className="flex flex-col items-center justify-center pt-5 pb-6">
                            <Upload className="w-12 h-12 mb-3 text-purple-500" />
                            <p className="mb-2 text-sm text-purple-500">
                              <span className="font-semibold">
                                Click to upload
                              </span>{" "}
                              or drag and drop
                            </p>
                            <p className="text-xs text-purple-500">
                              PDF (MAX. 10MB)
                            </p>
                          </div>
                        )}
                        <input
                          id="file-upload"
                          type="file"
                          className="hidden"
                          accept=".pdf"
                          onChange={handleFileChange}
                          ref={fileInputRef}
                        />
                      </label>
                    </div>
                    {pdfFile && (
                      <p className="text-sm text-purple-600">
                        Selected file: {pdfFile.name}
                      </p>
                    )}
                    <div className="flex space-x-4">
                      <Button
                        className="flex-1 bg-purple-600 hover:bg-purple-700 text-white rounded-xl py-3 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:-translate-y-1"
                        onClick={handleFileUpload}
                      >
                        Upload and Process PDF
                      </Button>
                      <Button
                        className="flex-1 bg-red-500 hover:bg-red-600 text-white rounded-xl py-3 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:-translate-y-1"
                        onClick={() => handleGenerateNew("upload")}
                      >
                        Generate New
                      </Button>
                    </div>
                  </div>
                </TabsContent>
                <TabsContent value="youtube">
                  <div className="space-y-4">
                    <Label
                      htmlFor="note-title-youtube"
                      className="block text-lg font-medium text-pink-600"
                    >
                      Note Title
                    </Label>
                    <Input
                      id="note-title-youtube"
                      placeholder="Enter a title for your notes"
                      value={noteTitle}
                      onChange={(e) => setNoteTitle(e.target.value)}
                      className="border-pink-300 focus:border-pink-500 focus:ring-pink-500 rounded-xl"
                    />
                    <Label
                      htmlFor="youtube-link"
                      className="block text-lg font-medium text-pink-600"
                    >
                      YouTube Link
                    </Label>
                    <Input
                      id="youtube-link"
                      type="url"
                      placeholder="Enter YouTube URL"
                      value={youtubeLink}
                      onChange={(e) => setYoutubeLink(e.target.value)}
                      className="border-pink-300 focus:border-pink-500 focus:ring-pink-500 rounded-xl"
                    />
                    <div className="flex space-x-4">
                      <Button
                        className="flex-1 bg-pink-600 hover:bg-pink-700 text-white rounded-xl py-3 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:-translate-y-1"
                        onClick={handleYoutubeSubmit}
                      >
                        Generate Notes from YouTube
                      </Button>
                      <Button
                        className="flex-1 bg-red-500 hover:bg-red-600 text-white rounded-xl py-3 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:-translate-y-1"
                        onClick={() => handleGenerateNew("youtube")}
                      >
                        Generate New
                      </Button>
                    </div>
                  </div>
                </TabsContent>
                <TabsContent value="lecture">
                  <div className="space-y-4">
                    <Label
                      htmlFor="note-title-lecture"
                      className="block text-lg font-medium text-blue-600"
                    >
                      Note Title
                    </Label>
                    <Input
                      id="note-title-lecture"
                      placeholder="Enter a title for your notes"
                      value={noteTitle}
                      onChange={(e) => setNoteTitle(e.target.value)}
                      className="border-blue-300 focus:border-blue-500 focus:ring-blue-500 rounded-xl"
                    />
                    <Label className="block text-lg font-medium text-blue-600">
                      Lecture Notes
                    </Label>
                    <Select onValueChange={setSubject}>
                      <SelectTrigger className="w-full">
                        <SelectValue placeholder="Select Subject" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="math">Mathematics</SelectItem>
                        <SelectItem value="physics">Physics</SelectItem>
                        <SelectItem value="chemistry">Chemistry</SelectItem>
                      </SelectContent>
                    </Select>
                    <Select onValueChange={setTopic}>
                      <SelectTrigger className="w-full">
                        <SelectValue placeholder="Select Topic" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="topic1">Topic 1</SelectItem>
                        <SelectItem value="topic2">Topic 2</SelectItem>
                        <SelectItem value="topic3">Topic 3</SelectItem>
                      </SelectContent>
                    </Select>
                    <Select onValueChange={setLectureNo}>
                      <SelectTrigger className="w-full">
                        <SelectValue placeholder="Select Lecture Number" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="1">Lecture 1</SelectItem>
                        <SelectItem value="2">Lecture 2</SelectItem>
                        <SelectItem value="3">Lecture 3</SelectItem>
                      </SelectContent>
                    </Select>
                    <div className="flex space-x-4">
                      <Button
                        className="flex-1 bg-blue-600 hover:bg-blue-700 text-white rounded-xl py-3 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:-translate-y-1"
                        onClick={handleLectureNotesSubmit}
                      >
                        Generate Lecture Notes
                      </Button>
                      <Button
                        className="flex-1 bg-red-500 hover:bg-red-600 text-white rounded-xl py-3 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:-translate-y-1"
                        onClick={() => handleGenerateNew("lecture")}
                      >
                        Generate New
                      </Button>
                    </div>
                  </div>
                </TabsContent>
                <TabsContent value="custom">
                  <div className="space-y-4">
                    <Label
                      htmlFor="note-title-custom"
                      className="block text-lg font-medium text-green-600"
                    >
                      Note Title
                    </Label>
                    <Input
                      id="note-title-custom"
                      placeholder="Enter a title for your notes"
                      value={noteTitle}
                      onChange={(e) => setNoteTitle(e.target.value)}
                      className="border-green-300 focus:border-green-500 focus:ring-green-500 rounded-xl"
                    />
                    <Label
                      htmlFor="custom-notes"
                      className="block text-lg font-medium text-green-600"
                    >
                      Create Your Own Notes
                    </Label>
                    <textarea
                      id="custom-notes"
                      placeholder="Start typing your notes here..."
                      className="w-full h-64 p-2 border-2 border-green-300 rounded-xl focus:border-green-500 focus:ring-green-500"
                      value={customNotes}
                      onChange={(e) => setCustomNotes(e.target.value)}
                    />
                    <div className="flex space-x-4">
                      <Button
                        className="flex-1 bg-green-600 hover:bg-green-700 text-white rounded-xl py-3 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:-translate-y-1"
                        onClick={handleCustomNotesGenerate}
                      >
                        Generate Custom Notes
                      </Button>
                      <Button
                        className="flex-1 bg-red-500 hover:bg-red-600 text-white rounded-xl py-3 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:-translate-y-1"
                        onClick={() => handleGenerateNew("custom")}
                      >
                        Generate New
                      </Button>
                    </div>
                  </div>
                </TabsContent>
                <TabsContent value="all">
                  <div className="space-y-4">
                    <h2 className="text-2xl font-bold text-yellow-600">
                      All Notes
                    </h2>
                    {allNotes.length === 0 ? (
                      <p className="text-gray-500">No notes created yet.</p>
                    ) : (
                      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                        {allNotes.map((note) => (
                          <Card
                            key={note.id}
                            className="p-4 hover:shadow-lg transition-shadow duration-300"
                          >
                            <h3 className="text-lg font-semibold mb-2">
                              {note.title}
                            </h3>
                            <p className="text-sm text-gray-500 mb-2">
                              Type: {note.type}
                            </p>
                            <p className="text-sm text-gray-500 mb-4">
                              Created:{" "}
                              {new Date(note.createdAt).toLocaleString()}
                            </p>
                            <div className="flex space-x-2">
                              <Dialog>
                                <DialogTrigger asChild>
                                  <Button
                                    className="flex-1 bg-yellow-500 hover:bg-yellow-600 text-white rounded-xl py-2 transition-all duration-300"
                                    onClick={() => setSelectedNote(note)}
                                  >
                                    <Eye className="w-4 h-4 mr-2" />
                                    View
                                  </Button>
                                </DialogTrigger>
                                <DialogContent className="max-w-4xl max-h-[80vh] overflow-hidden">
                                  <DialogHeader>
                                    <DialogTitle>
                                      {selectedNote?.title}
                                    </DialogTitle>
                                  </DialogHeader>
                                  <div className="mt-4 h-full">
                                    {selectedNote?.pdfUrl && (
                                      <iframe
                                        src={selectedNote.pdfUrl}
                                        className="w-full h-[60vh]"
                                        title="PDF Preview"
                                      />
                                    )}
                                  </div>
                                </DialogContent>
                              </Dialog>
                              <Button
                                className="flex-1 bg-purple-500 hover:bg-purple-600 text-white rounded-xl py-2 transition-all duration-300"
                                onClick={() =>
                                  handleDownload(note.pdfUrl, note.title)
                                }
                              >
                                <Download className="w-4 h-4 mr-2" />
                                Download
                              </Button>
                              <Button
                                className="flex-1 bg-red-500 hover:bg-red-600 text-white rounded-xl py-2 transition-all duration-300"
                                onClick={() => handleDelete(note.id)}
                              >
                                <Trash2 className="w-4 h-4 mr-2" />
                                Delete
                              </Button>
                            </div>
                          </Card>
                        ))}
                      </div>
                    )}
                  </div>
                </TabsContent>
              </div>
            </Tabs>
          </CardContent>
        </Card>

        <AnimatePresence>
          {notes[activeTab] && (
            <motion.div
              key={activeTab}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -20 }}
              transition={{ duration: 0.5 }}
              className="mt-8"
            >
              <Card className="overflow-hidden shadow-2xl rounded-3xl bg-white/90 backdrop-blur-sm">
                <CardContent className="p-6">
                  <div className="flex justify-between items-center mb-4">
                    <h2 className="text-3xl font-bold text-purple-800">
                      Generated Notes
                    </h2>
                    <Button
                      className="bg-red-500 hover:bg-red-600 text-white rounded-full p-2"
                      onClick={() =>
                        setNotes((prev) => ({ ...prev, [activeTab]: null }))
                      }
                    >
                      <X className="w-5 h-5" />
                    </Button>
                  </div>
                  <div className="bg-white p-6 rounded-2xl border border-purple-200 shadow-inner max-h-96 overflow-y-auto">
                    <h3 className="text-xl font-semibold mb-2">
                      {notes[activeTab]?.title}
                    </h3>
                    <ReactMarkdown>{notes[activeTab]?.content}</ReactMarkdown>
                  </div>
                  <Button
                    className="mt-6 w-full bg-purple-600 hover:bg-purple-700 text-white rounded-xl py-3 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:-translate-y-1"
                    onClick={() =>
                      handleDownload(
                        notes[activeTab]?.pdfUrl,
                        notes[activeTab]?.title || "notes"
                      )
                    }
                  >
                    <Download className="w-5 h-5 mr-2" />
                    Download Notes
                  </Button>
                </CardContent>
              </Card>
            </motion.div>
          )}
        </AnimatePresence>
      </motion.div>
    </div>
  );
}
