"use client";
import React, { useEffect, useState } from "react";
import Markdown from "react-markdown";
import { MDXProvider } from "@mdx-js/react";
import { CopyToClipboard } from "react-copy-to-clipboard";
import { MagnifyingGlass } from "react-loader-spinner";
import {
  GoogleGenerativeAI,
  HarmCategory,
  HarmBlockThreshold,
} from "@google/generative-ai";
import { CodeBlock } from "react-code-blocks";
import { generationConfig, safetySettings, getModel } from "@/lib/ai";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Card, CardHeader } from "@/components/ui/card";
import { Home, Image } from "lucide-react";
import { cn } from "@/lib/utils";

const MyComponent = () => {
  const components = {
    code: CodeBlock,
    // Add other components you want to use in your MDX content here
  };
  const [file, setFile] = useState(null);
  const [code, setCode] = useState();
  const [text, setText] = useState();
  const [filePath, setFilePath] = useState();
  const [loading, setLoading] = useState(false);
  const [isCopied, setIsCopied] = useState(false);
  const model = getModel("gemini-1.5-pro");
  const handleCopy = () => {
    setIsCopied(true);
    setTimeout(() => setIsCopied(false), 2000); // Reset after 2 seconds
  };

  const handleFileChange = (event) => {
    const file = event.target.files[0];
    const reader = new FileReader();

    reader.onloadend = () => {
      setFile(reader.result.split(",")[1]); // remove the data:image/jpeg;base64, part
    };
    const url = URL.createObjectURL(file);
    setFilePath(url);
    reader.readAsDataURL(file);
  };

  const generateContent = async () => {
    setText(null);
    setLoading(true);
    const parts = [
      {
        text: "You are extremely efficient bot to produce html code with appropriate styling. Provide me the html and the css of the given image and most importantly, make sure that you do not provide two separate codes for html and css.You have to incorporate the css styling inline and return only one code of html with appropriate styling applied in it",
      },
      {
        inlineData: {
          mimeType: "image/jpeg",
          data: file,
        },
      },
    ];

    const result = await model.generateContent({
      contents: [{ role: "user", parts }],
      generationConfig,
      safetySettings,
    });
    console.log(result);

    const response = result.response;
    let text = response.text();
    text = text.replace(/```/g, "");

    text = text.replace(`html\n`, "").slice(0, -1);
    setCode(text);
    setLoading(false);
    setText(result.response.text());
    console.log(text);
  };

  return (
    <>
      <div
        key="1"
        className="w-full grid items-center  gap-4 p-4 text-center md:px-6 lg:gap-10  dark:text-gray-50"
      >
        <div className="space-y-3 text-center w-full">
          <h1 className="text-3xl text-white font-bold tracking-tighter sm:text-4xl md:text-5xl">
            Image to Code
          </h1>
          <p className="mx-auto text-muted-foreground max-w-[700px]  md:text-xl/relaxed lg:text-base/relaxed xl:text-xl/relaxed dark:text-gray-400">
            Upload an image and convert it to code.
          </p>
        </div>
        <div className="w-full mt-12 gap-20 justify-center  flex mx-auto">
          <div>
            {!file && (
              <div className="flex items-center justify-center w-[30rem] h-96 border-2 border-dashed border-gray-400 rounded-lg">
                <label
                  htmlFor="file-upload"
                  className="flex flex-col  items-center px-4 py-6 text-white/50 rounded-lg tracking-wide uppercase cursor-pointer "
                >
                  <Image className="w-20 h-20 obj" />
                  <span className="mt-2 text-base leading-normal">
                    Select a file
                  </span>
                  <input
                    type="file"
                    className="hidden"
                    id="file-upload"
                    onChange={handleFileChange}
                  />
                </label>
              </div>
            )}
            {file && (
              <img
                src={filePath}
                className="w-[30rem] h-96 rounded-lg object-contain"
              />
            )}
            <Button
              onClick={generateContent}
              className="mt-6 w-full bg-white rounded-md text-[#1a202c] hover:text-white"
            >
              Generate
            </Button>
          </div>
          <div className="flex items-start text-white">
            <Card className={cn("dark:bg-[#1b1b1b] w-[30rem]")}>
              {text ? (
                <CardHeader>
                  <ScrollArea className="h-[500px] text-start relative">
                    <Markdown children={text} />
                    <CopyToClipboard
                      text={text}
                      onCopy={handleCopy}
                      className="absolute top-0 right-3"
                    >
                      <button>{isCopied ? "Copied!" : "Copy"}</button>
                    </CopyToClipboard>
                  </ScrollArea>
                </CardHeader>
              ) : (
                <CardHeader className="flex h-96 w-[30rem] items-center justify-center">
                  {loading ? (
                    <MagnifyingGlass
                      visible={true}
                      height="80"
                      width="80"
                      ariaLabel="magnifying-glass-loading"
                      wrapperStyle={{}}
                      wrapperClass="magnifying-glass-wrapper"
                      glassColor="#c0efff"
                      color="#e15b64"
                    />
                  ) : (
                    <p>Please select an image to view the code</p>
                  )}
                </CardHeader>
              )}
            </Card>
          </div>
        </div>
      </div>
    </>
  );
};

export default MyComponent;
