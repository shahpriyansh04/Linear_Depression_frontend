import React, { useEffect, useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useSession } from "next-auth/react";

const Community = ({
  setIsChatOpen,
  isChatOpen,
}: {
  setIsChatOpen: (value: boolean) => void;
  isChatOpen: boolean;
}) => {
  const [activeTab, setActiveTab] = useState("Mentor Chat");
  const [message, setMessage] = useState("");
  const { data: session } = useSession();
  const [mentorChats, setMentorChats] = useState();
  const [allChats, setAllChats] = useState();
  if (!session) return <p>Loading...</p>;

  const handleSend = async () => {
    try {
      const response = await fetch("http://localhost:4000/send-chat/", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${session.user.token}`,
        },
        body: JSON.stringify({
          senderName: session.user.name,
          messageContent: message,
          image: "",
          receiverId:
            session?.user.mentorId !== ""
              ? session?.user.mentorId
              : session?.user.menteeId,
          senderId: session.user._id,
        }),
      });
    } catch (error) {
      console.error("Error sending message:", error);
    }
    getMentorChats();
    getAllChats();
    setMessage(""); // Clear the input field after sending
  };

  const getMentorChats = async () => {
    try {
      const req = await fetch(
        `http://localhost:4000/get-my-chat/${session.user?._id}/${
          session?.user.mentorId !== ""
            ? session?.user.mentorId
            : session?.user.menteeId
        }/`,
        {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${session.user.token}`, // Add the Bearer token here
          },
        }
      );
      const res = await req.json();
      console.log(res);
      setMentorChats(res.data);
    } catch (error) {
      console.error("Error retrieving mentor chats:", error);
    }
  };
  const getAllChats = async () => {
    try {
      const req = await fetch(
        `http://localhost:4000/getAllChats/${session.user?._id}/`,
        {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${session.user.token}`, // Add the Bearer token here
          },
        }
      );
      const res = await req.json();
      console.log(res);
      setAllChats(res.data);
    } catch (error) {
      console.error("Error retrieving mentor chats:", error);
    }
  };
  useEffect(() => {
    getMentorChats();
    getAllChats();
  }, []);

  return (
    <AnimatePresence mode="wait">
      {isChatOpen && (
        <motion.div
          initial={{ width: 0, opacity: 0 }}
          animate={{ width: "20rem", opacity: 1 }}
          exit={{ width: 0, opacity: 0 }}
          transition={{
            duration: 0.3,
            ease: "easeInOut",
          }}
          className="bg-white border border-gray-200 shadow-lg rounded-lg overflow-hidden flex flex-col  h-[700px]"
        >
          <div className="p-4 bg-purple-100 flex justify-between items-center rounded-t-lg">
            <h1 className="font-semibold text-purple-900">Chat</h1>
            <Button
              variant="ghost"
              size="sm"
              onClick={() => setIsChatOpen(false)}
              className="hover:bg-purple-200"
            >
              <X className="h-4 w-4 text-purple-900" />
            </Button>
          </div>
          <div className="p-4 flex-1 overflow-auto">
            <div className="flex justify-around mb-4">
              <button
                className={`px-4 py-2 rounded-full ${
                  activeTab === "Mentor Chat"
                    ? "bg-purple-200 text-purple-900"
                    : "bg-purple-100 text-purple-700"
                }`}
                onClick={() => setActiveTab("Mentor Chat")}
              >
                Mentor Chat
              </button>
              <button
                className={`px-4 py-2 rounded-full ${
                  activeTab === "Community Chat"
                    ? "bg-purple-200 text-purple-900"
                    : "bg-purple-100 text-purple-700"
                }`}
                onClick={() => setActiveTab("Community Chat")}
              >
                Community Chat
              </button>
            </div>
            <div className="text-gray-500 text-center">
              {activeTab === "Mentor Chat" && mentorChats && (
                <div>
                  {mentorChats?.map((chat) => (
                    <div
                      key={chat._id}
                      className={`flex ${
                        chat.senderId === session.user._id
                          ? "justify-end"
                          : "justify-start"
                      } mb-2`}
                    >
                      <div
                        className={`p-2 rounded-lg ${
                          chat.senderId === session.user._id
                            ? "bg-purple-200 text-purple-900"
                            : "bg-gray-200 text-gray-900"
                        }`}
                      >
                        <p className="text-sm font-semibold">
                          {chat.senderName}
                        </p>
                        <p>{chat.messageContent}</p>
                      </div>
                    </div>
                  ))}
                </div>
              )}
              {activeTab === "Community Chat" && (
                <div>
                  {allChats?.map((chat) => (
                    <div
                      key={chat._id}
                      className={`flex ${
                        chat.senderId === session.user._id
                          ? "justify-end"
                          : "justify-start"
                      } mb-2`}
                    >
                      <div
                        className={`p-2 rounded-lg ${
                          chat.senderId === session.user._id
                            ? "bg-purple-200 text-purple-900"
                            : "bg-gray-200 text-gray-900"
                        }`}
                      >
                        <p className="text-sm font-semibold">
                          {chat.senderName}
                        </p>
                        <p>{chat.messageContent}</p>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
          <div className="p-4 bg-purple-100 flex items-center rounded-b-lg">
            <input
              type="text"
              value={message}
              onChange={(e) => setMessage(e.target.value)}
              className="flex-1 px-4 py-2 rounded-full border border-gray-300 focus:outline-none focus:ring-2 focus:ring-purple-500"
              placeholder="Type your message..."
            />
            <Button
              size="sm"
              onClick={handleSend}
              className="ml-2 bg-purple-600 hover:bg-purple-700 text-white"
            >
              Send
            </Button>
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  );
};

export default Community;
