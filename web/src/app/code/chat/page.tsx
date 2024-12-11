"use client";
import {
  GoogleGenerativeAI,
  HarmBlockThreshold,
  HarmCategory,
} from "@google/generative-ai";
import Link from "next/link";
import { useState } from "react";
import { CodeBlock } from "react-code-blocks";

import { model, generationConfig, safetySettings } from "@/lib/ai";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

export default function ChatBox() {
  const [userPrompt, setUserPrompt] = useState("");
  const [messages, setMessages] = useState([
    {
      _id: "1",
      body: "Hello! How can I assist you today?",
      isAi: true,
    },
    {
      _id: "2",
      body: "Can you help me with some code?",
      isAi: false,
    },
    {
      _id: "3",
      body: "Sure! What do you need help with?",
      isAi: true,
    },
    {
      _id: "4",
      body: "```tsx\nconst add = (a, b) => a + b;\n```",
      isAi: false,
    },
    {
      _id: "5",
      body: "Here's a simple addition function in JavaScript.",
      isAi: true,
    },
  ]);

  const getAnswer = async (userQuestion) => {
    const parts = [{ text: "" }, { text: userQuestion }];
    setUserPrompt("");

    // Add user message to the messages array
    setMessages((prevMessages) => [
      ...prevMessages,
      {
        _id: `${prevMessages.length + 1}`,

        body: userQuestion,
        isAi: false,
      },
    ]);

    const result = await model.generateContent({
      contents: [{ role: "user", parts }],
      generationConfig,
      safetySettings,
    });

    const response = result.response;
    const aiMessage = await response.text();

    // Add AI message to the messages array
    setMessages((prevMessages) => [
      ...prevMessages,
      {
        _id: `${prevMessages.length + 1}`,
        body: aiMessage,
        isAi: true,
      },
    ]);

    console.log(aiMessage);
  };
  return (
    <div className="h-screen gap-6 flex flex-col items-center justify-center max-w-3xl mx-auto">
      <Card className="w-full bg-transparent/25 dark:bg-[#18181B] text-white">
        <CardHeader>
          <CardTitle>Chat</CardTitle>
        </CardHeader>
        <ScrollArea className="h-[600px]">
          <CardContent className="grid gap-10 text-lg">
            {messages.map((message) => {
              const isCode = message.body.includes("```");
              let text = message.body;
              let code = "";

              if (isCode) {
                [text, code] = message.body.split("```");
                code = code.replace(/^[^\n]*\n/, ""); // remove the first line
              }

              return (
                <div
                  key={message._id}
                  className="flex items-start justify-start gap-8"
                >
                  {!message.isAi ? (
                    <img
                      src="https://www.shutterstock.com/image-vector/young-smiling-man-avatar-brown-260nw-2261401207.jpg"
                      alt="User Avatar"
                      className="w-8 h-8 rounded-full"
                    />
                  ) : (
                    <img
                      src="https://www.shutterstock.com/image-vector/young-smiling-man-avatar-brown-260nw-2261401207.jpg"
                      alt="AI Avatar"
                      className="w-8 h-8 rounded-full"
                    />
                  )}
                  <div className="flex justify-between items-start flex-1">
                    <div className="flex flex-col gap-3">
                      <p>{text}</p>
                      {isCode && (
                        <div>
                          <CodeBlock text={code} showLineNumbers={true} />
                          <Link
                            href={{
                              pathname: "/code/code-analyzer",
                              query: { code: code },
                            }}
                          >
                            <Button className="mt-4">
                              Check your code here
                            </Button>
                          </Link>
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              );
            })}
          </CardContent>
        </ScrollArea>
      </Card>
      <div className="flex items-center gap-12 w-full">
        <Input
          className="resize-none h-[60px] text-xl p-3 w-full bg-transparent text-white"
          value={userPrompt}
          onChange={(e) => {
            setUserPrompt(e.target.value);
          }}
        />
        <Button
          size="lg"
          className="h-full rounded-md bg-white text-[#1a202c] hover:text-white"
          onClick={() => getAnswer(userPrompt)}
        >
          Generate
        </Button>
      </div>
    </div>
  );
}
