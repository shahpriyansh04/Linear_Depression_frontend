"use client";

import { useState, useEffect } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Slider } from "@/components/ui/slider";
import axios from "axios";
import { useSession } from "next-auth/react";
import Quiz from "../(component)/Quiz";

export default function GenerateQuiz() {
  const searchParams = useSearchParams();
  const [formData, setFormData] = useState({
    subject: searchParams.get("subject") || "hh",
    chapter: "",
    difficulty: "medium",
    timer: 30,
    questions: 5,
  });
  const { data: session } = useSession();
  console.log(session?.user);
  const [questions, setQuestions] = useState([]);
  console.log(formData);
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    // In a real application, you would generate a quiz ID here

    const options = {
      method: "post",
      url: "http://localhost:5001/quiz",
      headers: {
        Accept: "*/*",
        "User-Agent": "Flashpost",
        "Content-Type": "application/json",
      },
      data: { topic: formData.chapter, num_questions: formData.questions },
    };

    axios
      .request(options)
      .then(function (response) {
        console.log(response);

        setQuestions(response.data.quiz_questions);
      })
      .catch(function (error) {
        console.error(error);
      });
  };

  return (
    <div className="min-h-screen bg-purple-50 p-8">
      <div className="max-w-md mx-auto">
        <Card className="border-none bg-white shadow-sm">
          <CardHeader>
            <CardTitle className="text-2xl font-bold text-gray-900">
              Create Quiz
            </CardTitle>
            <p className="text-gray-600">
              Fill the details to create your Quiz..
            </p>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSubmit} className="space-y-6">
              {/* Subject Selection (disabled since it's pre-selected) */}

              {/* Chapter Name */}
              <div className="space-y-2">
                <label className="text-sm font-medium text-gray-700">
                  Topic
                </label>
                <Input
                  type="text"
                  placeholder="Enter chapter name"
                  className="bg-white border-gray-200"
                  value={formData.chapter}
                  onChange={(e) =>
                    setFormData({ ...formData, chapter: e.target.value })
                  }
                />
              </div>

              {/* Difficulty Level */}
              <div className="space-y-2">
                <label className="text-sm font-medium text-gray-700">
                  Difficulty Level
                </label>
                <Select
                  value={formData.difficulty}
                  onValueChange={(value) =>
                    setFormData({ ...formData, difficulty: value })
                  }
                >
                  <SelectTrigger className="bg-white border-gray-200">
                    <SelectValue placeholder="Select difficulty" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="easy">Easy</SelectItem>
                    <SelectItem value="medium">Medium</SelectItem>
                    <SelectItem value="hard">Hard</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              {/* Timer */}
              <div className="space-y-2">
                <label className="text-sm font-medium text-gray-700">
                  Timer (minutes): {formData.timer}
                </label>
                <Slider
                  value={[formData.timer]}
                  onValueChange={([value]) =>
                    setFormData({ ...formData, timer: value })
                  }
                  min={5}
                  max={60}
                  step={5}
                  className="py-4"
                />
              </div>

              {/* Number of Questions */}
              <div className="space-y-2">
                <label className="text-sm font-medium text-gray-700">
                  Number of Questions
                </label>
                <div className="flex gap-2">
                  {[5, 10, 15, 20].map((num) => (
                    <Button
                      key={num}
                      type="button"
                      variant={
                        formData.questions === num ? "default" : "outline"
                      }
                      onClick={() =>
                        setFormData({ ...formData, questions: num })
                      }
                    >
                      {num}
                    </Button>
                  ))}
                </div>
              </div>

              {/* Submit Button */}
              <Button
                type="submit"
                className="w-full bg-blue-500 hover:bg-blue-600"
              >
                Generate Quiz
              </Button>
            </form>
          </CardContent>
        </Card>
      </div>
      {questions.length > 0 && <Quiz questions={questions} />}{" "}
    </div>
  );
}
