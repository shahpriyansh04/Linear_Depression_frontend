"use client";

import { useRouter } from "next/navigation";
import { Card, CardContent } from "@/components/ui/card";
import { CircuitBoard, Grid2X2 } from "lucide-react";
import Link from "next/link";

export default function QuizSelection() {
  const router = useRouter();

  return (
    <div className="min-h-screen bg-purple-50 p-8">
      <div className="max-w-6xl mx-auto">
        <h1 className="text-3xl font-bold text-gray-900 mb-8">
          Select Quiz Type
        </h1>

        <div className="grid md:grid-cols-2 gap-20 mx-10">
          {/* AI Generated Quiz Card */}
          <Link href="/dashboard/student/quizes/generate/">
            <Card className="border-none bg-green-50 hover:scale-105 transition-all cursor-pointer">
              <CardContent className="p-8">
                <div className="mb-6">
                  <CircuitBoard className="m-auto w-40 h-40 text-green-500" />
                </div>
                <h2 className="text-2xl text-center font-bold text-gray-900 mb-2">
                  AI Generated Quizzes
                </h2>
                <p className="text-gray-600 text-center text-sm leading-relaxed">
                  Challenge your knowledge with AI-powered quizzes! Pick that
                  topic that you want to improve and get started. Enter the
                  topic and difficulty level and get your personliazed quiz.
                </p>
              </CardContent>
            </Card>
          </Link>

          {/* MCQ Questions Card */}
          <Card
            className="border-none bg-blue-50 hover:scale-105 transition-all cursor-pointer"
            onClick={() =>
              router.push("/dashboard/student/quizes/predefined-quiz")
            }
          >
            <CardContent className="p-8">
              <div className="mb-6">
                <Grid2X2 className="w-40 h-40 m-auto text-blue-500" />
              </div>
              <h2 className="text-2xl text-center font-bold text-gray-900 mb-2">
                Take Your Class Tests and View Reports
              </h2>
              <p className="text-gray-600 text-sm text-center leading-relaxed">
                Test your skills with questions across Categories !! From
                history to science, answer multiple-choice questions designed
                spanning a range of topics.
              </p>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
