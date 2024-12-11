// "use client";
// /* 
// THE BELOW IS FOR FILE UPLOAD.
// First thing is we will upload a PDF file, it will be sent to the backend using Axios. 
// Then whatever response we get in the form of a different PDF will be:
// 1. Displayed in the preview.
// 2. Allowed to download.

// TALKING ABOUT YOUTUBE UPLOAD LINK.
// so here we will first take input of the youtube link, send it to the backend, receive pdf file and then display it in the preview and allow to download.

// TALKING ABOUT LECTURE NOTES.
// we will select the subject, topic, and lecture no. from a drop down (please geenrate that drop down as well with dummy data now). this will just be a string of text. we will send it to the backend, receive pdf file and then display it in the preview and allow to download.

// Last about generate notes. its easy. we will type something and just make a pdf out of it and let the users download. no backend connection is needed.
// */

// import React, { useState } from "react";
// import axios from "axios";

// const Page: React.FC = () => {
//   const [pdfFile, setPdfFile] = useState<File | null>(null);
//   const [pdfPreviewUrl, setPdfPreviewUrl] = useState<string | null>(null);
//   const [downloadUrl, setDownloadUrl] = useState<string | null>(null);

//   // Handle file input change
//   const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
//     const file = event.target.files?.[0];
//     if (file && file.type === "application/pdf") {
//       setPdfFile(file);
//     } else {
//       alert("Please upload a valid PDF file.");
//     }
//   };

//   // Upload PDF and handle response
//   const handleFileUpload = async () => {
//     if (!pdfFile) {
//       alert("No PDF file selected.");
//       return;
//     }

//     const formData = new FormData();
//     formData.append("file", pdfFile);

//     try {
//       // Send the file to the backend
//       const response = await axios.post(
//         "http://localhost:5000/upload", 
//         //replace kardiyo
//         formData,
//         { responseType: "blob" } 
//         // pdf response 
//       );

//       // Create a URL for the returned PDF
//       const blob = new Blob([response.data], { type: "application/pdf" });
//       const previewUrl = URL.createObjectURL(blob);
//       setPdfPreviewUrl(previewUrl);
//       setDownloadUrl(previewUrl);

//       alert("PDF uploaded and processed successfully!");
//     } catch (error) {
//       console.error("Error uploading and processing PDF:", error);
//       alert("Failed to process the PDF.");
//     }
//   };

//   return (
//     <div className="p-4">
//       <h1 className="text-2xl font-bold mb-4">Upload, Preview, and Download PDF</h1>
      
//       {/* File Input */}
//       <input
//         type="file"
//         accept="application/pdf"
//         onChange={handleFileChange}
//         className="block mb-4"
//       />

//       {/* Preview PDF */}
//       {pdfPreviewUrl && (
//         <div className="mb-4">
//           <h2 className="text-xl font-semibold">Preview:</h2>
//           <iframe
//             src={pdfPreviewUrl}
//             width="100%"
//             height="500px"
//             className="border"
//             title="PDF Preview"
//           />
//         </div>
//       )}

//       {/* Upload Button */}
//       <button
//         onClick={handleFileUpload}
//         className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 mb-4"
//       >
//         Upload and Process PDF
//       </button>

//       {/* Download Button */}
//       {downloadUrl && (
//         <a
//           href={downloadUrl}
//           download="generated_notes.pdf"
//           className="px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600"
//         >
//           Download Processed PDF
//         </a>
//       )}
//     </div>
//   );
// };

// export default Page;




import NotesGenerator from "@/components/ui/notesgenerator/notesgenerator";

export default function Notes() {
  return <NotesGenerator />;
}