"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from "recharts";
import { Award, Book, Clock, Target, TrendingUp, User } from "lucide-react";
// import axios from 'axios';

// Consolidated types and mock data
interface Subject {
  id: string;
  name: string;
  description: string;
  chapters: Chapter[];
}

interface Chapter {
  id: string;
  name: string;
  subjectId: string;
}

interface Quiz {
  id: string;
  title: string;
  subjectId: string;
  chapterId: string;
  description: string;
  prerequisites: string[];
  difficulty: "Easy" | "Medium" | "Hard";
  estimatedTime: number;
  questions: Question[];
}

interface Question {
  id: string;
  text: string;
  options: string[];
  correctAnswer: string;
}

interface QuizResult {
  id: string;
  quizId: string;
  quizTitle: string;
  score: number;
  totalQuestions: number;
  dateTaken: Date;
  timeTaken: number;
  subjectName: string;
}

export default function QuizPage() {
  const router = useRouter();
  const [subjects, setSubjects] = useState<Subject[]>([]);
  const [quizResults, setQuizResults] = useState<QuizResult[]>([]);
  const [quizzes, setQuizzes] = useState<Quiz[]>([]);

  // Commented out axios fetch code
  /*
  useEffect(() => {
    const fetchData = async () => {
      try {
        const [subjectsResponse, quizResultsResponse, quizzesResponse] = await Promise.all([
          axios.get('/api/subjects'),
          axios.get('/api/quiz-results'),
          axios.get('/api/quizzes')
        ]);
        setSubjects(subjectsResponse.data);
        setQuizResults(quizResultsResponse.data);
        setQuizzes(quizzesResponse.data);
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    };

    fetchData();
  }, []);
  */

  // Mock data and services combined in the same file
  const mockSubjects: Subject[] = [
    {
      id: "math",
      name: "Mathematics",
      description:
        "Explore the world of numbers, patterns, and logical reasoning.",
      chapters: [
        { id: "algebra", name: "Algebra", subjectId: "math" },
        { id: "geometry", name: "Geometry", subjectId: "math" },
        { id: "calculus", name: "Calculus", subjectId: "math" },
        { id: "statistics", name: "Statistics", subjectId: "math" },
      ],
    },
    {
      id: "physics",
      name: "Physics",
      description: "Understand the fundamental laws that govern the universe.",
      chapters: [
        { id: "mechanics", name: "Mechanics", subjectId: "physics" },
        { id: "electricity", name: "Electricity", subjectId: "physics" },
        { id: "thermodynamics", name: "Thermodynamics", subjectId: "physics" },
        { id: "quantum", name: "Quantum Physics", subjectId: "physics" },
      ],
    },
    {
      id: "biology",
      name: "Biology",
      description: "Discover the wonders of life and living organisms.",
      chapters: [
        { id: "cell-biology", name: "Cell Biology", subjectId: "biology" },
        { id: "genetics", name: "Genetics", subjectId: "biology" },
        { id: "ecology", name: "Ecology", subjectId: "biology" },
        { id: "evolution", name: "Evolution", subjectId: "biology" },
      ],
    },
  ];

  const mockQuizzes: Quiz[] = [
    {
      id: "math-algebra-quiz",
      title: "Algebra Basics",
      subjectId: "math",
      chapterId: "algebra",
      description: "Test your knowledge of fundamental algebraic concepts.",
      prerequisites: ["Basic arithmetic", "Understanding of variables"],
      difficulty: "Medium",
      estimatedTime: 30,
      questions: [
        {
          id: "q1",
          text: "What is x in the equation 2x + 3 = 7?",
          options: ["2", "3", "4", "5"],
          correctAnswer: "2",
        },
      ],
    },
    {
      id: "physics-mechanics-quiz",
      title: "Mechanics Fundamentals",
      subjectId: "physics",
      chapterId: "mechanics",
      description: "Explore the basic principles of classical mechanics.",
      prerequisites: ["Basic algebra", "Understanding of vectors"],
      difficulty: "Hard",
      estimatedTime: 45,
      questions: [
        {
          id: "q1",
          text: "What is Newton's First Law of Motion?",
          options: [
            "Objects at rest stay at rest",
            "Force equals mass times acceleration",
            "Every action has an equal reaction",
            "Gravity affects all objects equally",
          ],
          correctAnswer: "Objects at rest stay at rest",
        },
      ],
    },
    {
      id: "biology-cell-quiz",
      title: "Cell Structure and Function",
      subjectId: "biology",
      chapterId: "cell-biology",
      description: "Dive into the microscopic world of cells.",
      prerequisites: [
        "Basic biology knowledge",
        "Familiarity with microscopes",
      ],
      difficulty: "Easy",
      estimatedTime: 20,
      questions: [
        {
          id: "q1",
          text: "What is the powerhouse of the cell?",
          options: [
            "Nucleus",
            "Mitochondria",
            "Endoplasmic Reticulum",
            "Golgi Apparatus",
          ],
          correctAnswer: "Mitochondria",
        },
      ],
    },
  ];

  const mockQuizResults: QuizResult[] = [
    {
      id: "result1",
      quizId: "math-algebra-quiz",
      quizTitle: "Algebra Basics",
      score: 8,
      totalQuestions: 10,
      dateTaken: new Date(2023, 5, 15),
      timeTaken: 25,
      subjectName: "Mathematics",
    },
    {
      id: "result2",
      quizId: "physics-mechanics-quiz",
      quizTitle: "Mechanics Fundamentals",
      score: 7,
      totalQuestions: 10,
      dateTaken: new Date(2023, 5, 20),
      timeTaken: 40,
      subjectName: "Physics",
    },
    {
      id: "result3",
      quizId: "biology-cell-quiz",
      quizTitle: "Cell Structure and Function",
      score: 9,
      totalQuestions: 10,
      dateTaken: new Date(2023, 5, 25),
      timeTaken: 18,
      subjectName: "Biology",
    },
  ];

  useEffect(() => {
    // Simulate data fetch
    setSubjects(mockSubjects);
    setQuizResults(mockQuizResults);
    setQuizzes(mockQuizzes);
  }, []);

  const navigateToQuizReport = (quizId: string) => {
    router.push(`/dashboard/student/quizes/report/${quizId}`);
  };

  const navigateToQuiz = (quizId: string) => {
    router.push(`/dashboard/student/quizes/take-quiz/${quizId}`);
  };

  const getPerformanceData = () => {
    return quizResults.map((result) => ({
      name: result.quizTitle,
      score: (result.score / result.totalQuestions) * 100,
    }));
  };

  return (
    <div className="container mx-auto p-6 bg-purple-50">
      {/* Quiz Results Section */}
      <section className="mb-12">
        <h2 className="text-3xl font-bold mb-6 text-purple-700">
          Your Recent Quiz Results
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {quizResults.map((result) => (
            <div
              key={result.id}
              className="bg-yellow-50 p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow duration-300 cursor-pointer"
              onClick={() => navigateToQuizReport(result.quizId)}
            >
              <h3 className="text-xl font-semibold mb-2 text-purple-600">
                {result.quizTitle}
              </h3>
              <p className="text-gray-600 mb-2">{result.subjectName}</p>
              <div className="flex items-center mb-2">
                <Award className="text-yellow-500 mr-2" size={20} />
                <span className="font-bold text-lg">
                  {result.score}/{result.totalQuestions}
                </span>
              </div>
              <div className="flex items-center mb-2">
                <Clock className="text-blue-500 mr-2" size={20} />
                <span>{result.timeTaken} minutes</span>
              </div>
              <p className="text-sm text-gray-500">
                Taken on {result.dateTaken.toLocaleDateString()}
              </p>
            </div>
          ))}
        </div>
      </section>

      {/* Performance Overview */}
      {/* <section className="mb-12 bg-blue-50 p-6 rounded-lg shadow-md">
        <h2 className="text-2xl font-bold mb-4 text-purple-700">Performance Overview</h2>
        <ResponsiveContainer width="100%" height={300}>
          <BarChart data={getPerformanceData()}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="name" />
            <YAxis />
            <Tooltip />
            <Bar dataKey="score" fill="#8884d8" />
          </BarChart>
        </ResponsiveContainer>
      </section> */}

      {/* Subjects and Quizzes Section */}
      {subjects.map((subject) => (
        <section key={subject.id} className="mb-12">
          <h2 className="text-3xl font-bold mb-4 text-purple-700">
            {subject.name} Quizzes
          </h2>
          <p className="text-gray-600 mb-6">{subject.description}</p>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {subject.chapters.map((chapter) => {
              const quiz = quizzes.find(
                (q) => q.subjectId === subject.id && q.chapterId === chapter.id
              );
              return quiz ? (
                <div
                  key={chapter.id}
                  className="bg-blue-50 p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow duration-300 cursor-pointer"
                  onClick={() => navigateToQuiz(quiz.id)}
                >
                  <h3 className="text-xl font-semibold mb-2 text-purple-600">
                    {quiz.title}
                  </h3>
                  <p className="text-gray-600 mb-4">{quiz.description}</p>
                  <div className="flex items-center mb-2">
                    <Book className="text-green-500 mr-2" size={20} />
                    <span>{chapter.name}</span>
                  </div>
                  <div className="flex items-center mb-2">
                    <Target className="text-red-500 mr-2" size={20} />
                    <span>Difficulty: {quiz.difficulty}</span>
                  </div>
                  <div className="flex items-center mb-4">
                    <Clock className="text-blue-500 mr-2" size={20} />
                    <span>Estimated time: {quiz.estimatedTime} minutes</span>
                  </div>
                  <div>
                    <h4 className="font-semibold mb-2">Prerequisites:</h4>
                    <ul className="list-disc list-inside text-sm text-gray-600">
                      {quiz.prerequisites.map((prereq, index) => (
                        <li key={index}>{prereq}</li>
                      ))}
                    </ul>
                  </div>
                </div>
              ) : null;
            })}
          </div>
        </section>
      ))}

      {/* Study Tips Section */}
      <section className="bg-blue-50 p-6 rounded-lg shadow-md mb-12">
        <h2 className="text-2xl font-bold mb-4 text-purple-700">Study Tips</h2>
        <ul className="space-y-2">
          <li className="flex items-start">
            <TrendingUp
              className="text-green-500 mr-2 mt-1 flex-shrink-0"
              size={20}
            />
            <span>Set specific, achievable goals for each study session.</span>
          </li>
          <li className="flex items-start">
            <Clock
              className="text-blue-500 mr-2 mt-1 flex-shrink-0"
              size={20}
            />
            <span>
              Use the Pomodoro Technique: Study for 25 minutes, then take a
              5-minute break.
            </span>
          </li>
          <li className="flex items-start">
            <User
              className="text-purple-500 mr-2 mt-1 flex-shrink-0"
              size={20}
            />
            <span>
              Teach the material to someone else to reinforce your
              understanding.
            </span>
          </li>
          <li className="flex items-start">
            <Book
              className="text-yellow-500 mr-2 mt-1 flex-shrink-0"
              size={20}
            />
            <span>
              Review your notes and quiz results regularly to identify areas for
              improvement.
            </span>
          </li>
        </ul>
      </section>
    </div>
  );
}
