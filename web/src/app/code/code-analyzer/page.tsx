"use client";

import { Button } from "@/components/ui/button";

import { useEffect, useState } from "react";
import AceEditor from "react-ace";
import { MagnifyingGlass } from "react-loader-spinner";
import Markdown from "react-markdown";
import { model, generationConfig, safetySettings } from "@/lib/ai";

import { Card } from "@/components/ui/card";
import { ScrollArea } from "@/components/ui/scroll-area";
import { cn } from "@/lib/utils";
import { Speaker } from "lucide-react";
import { useRouter, useParams, useSearchParams } from "next/navigation";

export default function CodeAnalyzer() {
  const [loading, setLoading] = useState(false);
  const searchParams = useSearchParams();
  console.log(searchParams);

  const [message, setMessage] = useState<string>();
  const [userPrompt, setUserPrompt] = useState();
  const [code, setCode] = useState(searchParams.get("code") || "");
  const [input, setInput] = useState();

  function onChange(newValue) {
    setCode(newValue);
  }
  console.log(code);

  const analyzeCode = async () => {
    setMessage("");
    setLoading(true);
    const parts = [
      {
        text: "You are expert at detecting errors and improving the efficiency of the given code.If there are any errors in the code, keep the first line specifying the error in short and then begin to explain ways to resolve the error. Further irrespective of any error or not give ways to improve the efficiency of code and give the code in an improved format which is precise and most efficient.For the errors, if any focus on the biggest error and then the small ones.Most importantly, return the output in mdx form only",
      },
      { text: code },
    ];
    let input;

    const result = await model.generateContent({
      contents: [{ role: "user", parts }],
      generationConfig,
      safetySettings,
    });
    console.log(result);
    setLoading(false);
    setMessage(result.response.text());
  };

  const generateSummary = async () => {
    const parts = [
      {
        text: "I am providing you with a code report. I want you to summarise it as short as possible while leaving the code out. Make it as concise as possible. Make it so that it can be read out by a narrator",
      },
      {
        text: message,
      },
    ];
    const result = await model.generateContent({
      contents: [{ role: "user", parts }],
      generationConfig,
      safetySettings,
    });
    console.log(result.response.text());
    setInput(result.response.text());
    start();

    // Speak the text using ResponsiveVoice
  };

  return (
    <>
      <p className="text-7xl text-white font-bold text-center mt-12">
        Code Analyzer
      </p>
      <div className="flex-1 flex  items-center justify-center gap-20 mt-20">
        <div className="w-[500px]">
          <AceEditor
            mode="java"
            theme="github"
            onChange={onChange}
            value={code}
            name="UNIQUE_ID_OF_DIV"
            width="500px"
            height="500px"
            fontSize={20}
            editorProps={{ $blockScrolling: true }}
          />
        </div>
        <Button
          onClick={analyzeCode}
          className="text-xl rounded-md  py-5 flex -1 "
          size="lg"
        >
          Analyse
        </Button>
        <Card className="h-full p-5 text-xl">
          <ScrollArea className={cn("h-[500px] w-[500px]  text-wrap relative")}>
            <div className=" h-full w-full items-center justify-center">
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
                <div className="">
                  <Speaker
                    className="absolute top-0 right-4 cursor-pointer"
                    onClick={generateSummary}
                  />
                  <Markdown children={message} />
                </div>
              )}
            </div>
          </ScrollArea>
        </Card>
      </div>
    </>
  );
}
