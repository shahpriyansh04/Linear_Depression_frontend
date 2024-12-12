"use client";

import React, { useState, useEffect, useCallback, useRef } from "react";
import axios from "axios";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { ScrollArea } from "@/components/ui/scroll-area";
import { MessageCircle, Send } from "lucide-react";
import { useSession } from "next-auth/react";
import { useSearchParams } from "next/navigation";

interface ParentChat {
  id: string;
  name: string;
}

interface Message {
  _id: string;
  senderName: string | null;
  messageContent: string;
  image: string;
  receiverId: string;
  senderId: string;
  sentTime: string;
}

export default function TeacherCommunication() {
  const [selectedParent, setSelectedParent] = useState<ParentChat | null>(null);
  const [messages, setMessages] = useState<Message[]>([]);
  const [newMessage, setNewMessage] = useState("");
  const [parents, setParents] = useState<ParentChat[]>([]);
  const { data: session } = useSession();
  const scrollAreaRef = useRef<HTMLDivElement>(null);
  const searchParams = useSearchParams();

  useEffect(() => {
    const fetchParentsAndStudents = async () => {
      if (!session?.user?.token) return;

      try {
        // Fetch all students
        const studentsResponse = await axios.get(
          "http://localhost:8000/student/get-all",
          {
            headers: {
              Authorization: `Bearer ${session.user.token}`,
            },
          }
        );
        const allStudents = studentsResponse.data.data;
        console.log(allStudents);
        // Filter students based on teacherId
        const isTeacherIdMatching = (student) => {
          console.log("Student:", student);
          console.log("Teacherid:", student.Teacherid);

          // Check if Teacherid is an object and convert it to an array if necessary
          let teacherIds = student.Teacherid;
          if (typeof teacherIds === "object" && !Array.isArray(teacherIds)) {
            teacherIds = Object.values(teacherIds);
          }

          return (
            Array.isArray(teacherIds) && teacherIds.includes(session.user.id)
          );
        };

        // Filter students based on Teacherid being an array and including session.user.id
        const filteredStudents = allStudents.filter(isTeacherIdMatching);

        // Debugging: Log filtered students
        console.log("Filtered Students:", filteredStudents);

        const parentIds = filteredStudents
          .filter((student) => student.parentId)
          .map((student) => student.parentId);

        const uniqueParentIds = [...new Set(parentIds)];

        // Fetch parent data based on unique parentIds
        const parentResponses = await Promise.all(
          uniqueParentIds.map((parentId) =>
            axios.get(`http://localhost:8000/parent/get-by-id/${parentId}`, {
              headers: {
                Authorization: `Bearer ${session?.user?.token}`,
              },
            })
          )
        );

        const allParents = parentResponses.map((response) => response.data);

        setParents(allParents);
      } catch (error) {
        console.error("Error fetching parents and students data:", error);
      }
    };

    fetchParentsAndStudents();
  }, [session?.user?.token]);
  console.log(parents);

  const fetchMessages = useCallback(
    async (parentId: string) => {
      if (!session?.user?.token) return;

      try {
        const response = await axios.get(
          `http://localhost:8000/get-my-chat/${session.user.id}/${parentId}`,
          {
            headers: {
              Authorization: `Bearer ${session.user.token}`,
            },
          }
        );

        if (response.data.success) {
          const fetchedMessages = response.data.data || [];
          setMessages(fetchedMessages);

          // Scroll to bottom after messages are fetched
          setTimeout(() => {
            if (scrollAreaRef.current) {
              scrollAreaRef.current.scrollTop =
                scrollAreaRef.current.scrollHeight;
            }
          }, 100);
        }
      } catch (error) {
        console.error("Error fetching messages:", error);
      }
    },
    [session]
  );

  const selectParent = useCallback(
    (parent: ParentChat) => {
      setSelectedParent(parent);
      fetchMessages(parent.id);
    },
    [fetchMessages]
  );

  const sendMessage = async () => {
    if (!newMessage.trim() || !selectedParent || !session?.user) return;

    try {
      await axios.post(
        "http://localhost:8000/send-chat",
        {
          senderId: `${session.user.id}`, // Teacher's ID
          receiverId: selectedParent.id,
          messageContent: newMessage,
        },
        {
          headers: {
            Authorization: `Bearer ${session.user.token}`,
          },
        }
      );

      await fetchMessages(selectedParent.id);
      setNewMessage("");
    } catch (error) {
      console.error("Error sending message:", error);
    }
  };

  const formatDate = (date: string) => {
    return new Date(date).toLocaleTimeString([], {
      hour: "2-digit",
      minute: "2-digit",
    });
  };

  useEffect(() => {
    // Read the `parentid` query parameter
    const parentIdFromQuery = searchParams.get("parentid");
    if (parentIdFromQuery) {
      const matchingParent = parents.find(
        (parent) => parent.id === parentIdFromQuery
      );
      if (matchingParent) {
        selectParent(matchingParent);
      }
    }
  }, [searchParams, parents, selectParent]);

  useEffect(() => {
    if (selectedParent) {
      const intervalId = setInterval(() => {
        fetchMessages(selectedParent.id);
      }, 3000);

      return () => clearInterval(intervalId);
    }
  }, [selectedParent, fetchMessages]);

  return (
    <div className="min-h-screen bg-purple-50 p-8">
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Parent List */}
        <Card className="bg-white shadow-lg">
          <CardHeader>
            <CardTitle className="text-2xl font-bold text-gray-800 flex items-center">
              <MessageCircle className="mr-2" /> Parents
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {parents.map((parent) => (
                <div
                  key={parent.id}
                  className={`flex items-center space-x-4 p-3 rounded-lg cursor-pointer transition-colors ${
                    selectedParent?.id === parent.id
                      ? "bg-blue-100"
                      : "hover:bg-gray-100"
                  }`}
                  onClick={() => selectParent(parent)}
                >
                  <Avatar>
                    <AvatarImage
                      src={`/placeholder.svg?height=40&width=40&text=${parent.name.charAt(
                        0
                      )}`}
                    />
                    <AvatarFallback>{parent.name.charAt(0)}</AvatarFallback>
                  </Avatar>
                  <div className="flex-1">
                    <h4 className="font-semibold">{parent.name}</h4>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Chat Area */}
        <Card className="lg:col-span-2 bg-white shadow-lg">
          <CardHeader>
            <CardTitle className="text-2xl font-bold text-gray-800 flex items-center">
              <MessageCircle className="mr-2" />
              {selectedParent
                ? `Chat with ${selectedParent.name}`
                : "Select a parent to start chatting"}
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ScrollArea>
              <div
                ref={scrollAreaRef}
                className="h-[400px] mb-4 p-4 bg-gray-50 rounded-lg overflow-y-auto"
              >
                {messages.length === 0 ? (
                  <div className="text-center text-gray-500">
                    No messages yet. Start a conversation!
                  </div>
                ) : (
                  messages.map((message) => (
                    <div
                      key={message._id}
                      className={`mb-2 flex ${
                        message.senderId === "1"
                          ? "justify-end"
                          : "justify-start"
                      }`}
                    >
                      <div
                        className={`p-3 rounded-lg max-w-xs shadow-md ${
                          message.senderId === "1"
                            ? "bg-blue-500 text-white"
                            : "bg-gray-200 text-black"
                        }`}
                      >
                        <p>{message.messageContent}</p>
                        <span className="text-xs text-gray-400 block mt-1 text-right">
                          {formatDate(message.sentTime)}
                        </span>
                      </div>
                    </div>
                  ))
                )}
              </div>
            </ScrollArea>
            {selectedParent && (
              <div className="flex items-center space-x-4">
                <Input
                  placeholder="Type a message..."
                  value={newMessage}
                  onChange={(e) => setNewMessage(e.target.value)}
                  onKeyPress={(e) => e.key === "Enter" && sendMessage()}
                />
                <Button
                  onClick={sendMessage}
                  className="bg-blue-600 hover:bg-blue-700"
                >
                  <Send />
                </Button>
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
