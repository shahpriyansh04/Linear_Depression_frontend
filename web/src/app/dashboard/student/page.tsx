"use client";

import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Progress } from "@/components/ui/progress";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Award,
  BookOpen,
  FileText,
  GraduationCap,
  Loader2,
  MessageCircle,
  Star,
  TrendingUp,
  X,
  Zap,
} from "lucide-react";
import { useSession } from "next-auth/react";
import { useState } from "react";
import { AnimatePresence, motion } from "framer-motion";
import Community from "./(components)/Community";

export default function StudentDashboard() {
  const [currentMonth, setCurrentMonth] = useState("January 2024");
  const { data: session } = useSession();
  const [currentSemester, setCurrentSemester] = useState(
    "First Semester 2023-24"
  );
  const [isChatOpen, setIsChatOpen] = useState(false);
  const gradesData = [
    {
      subject: "Mathematics",
      totalMarks: 92,
      maxMarks: 100,
      teacher: "Ms. Davis",
      color: "#FF6B6B",
      icon: <Zap className="h-4 w-4" />,
      exams: [
        { name: "Unit Test 1", marks: 23, maxMarks: 25 },
        { name: "Mid-term Exam", marks: 35, maxMarks: 40 },
        { name: "Unit Test 2", marks: 22, maxMarks: 25 },
        { name: "Final Exam", marks: 12, maxMarks: 10 },
      ],
    },
    {
      subject: "English",
      totalMarks: 88,
      maxMarks: 100,
      teacher: "Mr. Thompson",
      color: "#4ECDC4",
      icon: <BookOpen className="h-4 w-4" />,
      exams: [
        { name: "Unit Test 1", marks: 22, maxMarks: 25 },
        { name: "Mid-term Exam", marks: 33, maxMarks: 40 },
        { name: "Unit Test 2", marks: 21, maxMarks: 25 },
        { name: "Final Exam", marks: 12, maxMarks: 10 },
      ],
    },
    {
      subject: "Physics",
      totalMarks: 90,
      maxMarks: 100,
      teacher: "Dr. Martinez",
      color: "#45B7D1",
      icon: <TrendingUp className="h-4 w-4" />,
      exams: [
        { name: "Unit Test 1", marks: 24, maxMarks: 25 },
        { name: "Mid-term Exam", marks: 36, maxMarks: 40 },
        { name: "Unit Test 2", marks: 20, maxMarks: 25 },
        { name: "Final Exam", marks: 10, maxMarks: 10 },
      ],
    },
    {
      subject: "History",
      totalMarks: 85,
      maxMarks: 100,
      teacher: "Mrs. Anderson",
      color: "#FFA07A",
      icon: <FileText className="h-4 w-4" />,
      exams: [
        { name: "Unit Test 1", marks: 21, maxMarks: 25 },
        { name: "Mid-term Exam", marks: 32, maxMarks: 40 },
        { name: "Unit Test 2", marks: 22, maxMarks: 25 },
        { name: "Final Exam", marks: 10, maxMarks: 10 },
      ],
    },
    {
      subject: "Computer Science",
      totalMarks: 95,
      maxMarks: 100,
      teacher: "Mr. Wilson",
      color: "#98D8C8",
      icon: <Zap className="h-4 w-4" />,
      exams: [
        { name: "Unit Test 1", marks: 24, maxMarks: 25 },
        { name: "Mid-term Exam", marks: 38, maxMarks: 40 },
        { name: "Unit Test 2", marks: 23, maxMarks: 25 },
        { name: "Final Exam", marks: 10, maxMarks: 10 },
      ],
    },
    {
      subject: "Biology",
      totalMarks: 87,
      maxMarks: 100,
      teacher: "Dr. Patel",
      color: "#7FDBDA",
      icon: <FileText className="h-4 w-4" />,
      exams: [
        { name: "Unit Test 1", marks: 22, maxMarks: 25 },
        { name: "Mid-term Exam", marks: 34, maxMarks: 40 },
        { name: "Unit Test 2", marks: 21, maxMarks: 25 },
        { name: "Final Exam", marks: 10, maxMarks: 10 },
      ],
    },
  ];

  const calculateOverallPercentage = (grades: any) => {
    const totalMarks = grades.reduce(
      (sum: any, grade: any): any => sum + grade.totalMarks,
      0
    );
    const totalMaxMarks = grades.reduce(
      (sum: any, grade: any) => sum + grade.maxMarks,
      0
    );
    return ((totalMarks / totalMaxMarks) * 100).toFixed(2);
  };

  const overallPercentage = calculateOverallPercentage(gradesData);
  if (!session)
    return (
      <div className="h-screen flex items-center justify-center">
        <Loader2 className="animate-spin w-12 h-12" />
      </div>
    );

  return (
    <div className=" min-h-screen bg-purple-50">
      <div className="">
        <h1 className=" text-2xl font-bold px-8">
          👋 Welcome, {session?.user?.name}!
        </h1>
      </div>
      <div className="flex">
        {/* Main Content */}
        <div className="flex-1 overflow-auto">
          <div className="p-8">
            <div className="mb-8">
              <Card className="bg-gradient-to-r from-blue-100 to-purple-100">
                <CardContent className="flex items-center justify-between p-6">
                  <div>
                    <h2 className="mb-2 text-xl font-semibold">
                      📊 Your Progress
                    </h2>
                    <p className="mb-4 text-gray-600">
                      Great job! You're making excellent progress this semester.
                    </p>
                    <div className="mb-4 flex items-center">
                      <div className="mr-4 text-3xl font-bold text-purple-600">
                        A-
                      </div>
                      <div>
                        <div className="font-semibold">Overall Grade</div>
                        <div className="text-sm text-gray-600">
                          Keep up the good work!
                        </div>
                      </div>
                    </div>
                    <Button className="bg-purple-600 hover:bg-purple-700">
                      View Detailed Report
                    </Button>
                  </div>
                  <div className="flex gap-8">
                    <div className="flex flex-col items-center">
                      <div className="mb-2 text-2xl font-bold text-purple-600">
                        🏆
                      </div>
                      <div className="text-center text-sm font-semibold">
                        Recent Achievements
                      </div>
                      <div className="text-center text-xs text-gray-600">
                        Perfect Attendance
                      </div>
                      <div className="text-center text-xs text-gray-600">
                        Science Fair Winner
                      </div>
                    </div>{" "}
                    <div className="flex flex-col items-center">
                      <div className="mb-2 text-2xl font-bold text-purple-600">
                        🏆
                      </div>
                      <div className="text-center text-sm font-semibold">
                        Recent Achievements
                      </div>
                      <div className="text-center text-xs text-gray-600">
                        Perfect Attendance
                      </div>
                      <div className="text-center text-xs text-gray-600">
                        Science Fair Winner
                      </div>
                    </div>
                    <div className="flex flex-col items-center">
                      <div className="mb-2 text-2xl font-bold text-purple-600">
                        🏆
                      </div>
                      <div className="text-center text-sm font-semibold">
                        Recent Achievements
                      </div>
                      <div className="text-center text-xs text-gray-600">
                        Perfect Attendance
                      </div>
                      <div className="text-center text-xs text-gray-600">
                        Science Fair Winner
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>

            {/* Enrolled Courses */}
            <div className="mb-2">
              <div className="mb-2 flex items-center justify-between">
                <h2 className="text-xl font-semibold">📚 Enrolled Courses</h2>
                <Button variant="link">View all</Button>
              </div>
              <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-4">
                <Card className="bg-pink-100">
                  <CardContent className="p-4">
                    <h3 className="font-semibold">Art & Crafts</h3>
                    <p className="text-sm text-gray-600">Mrs. Johnson</p>
                    <p className="text-sm text-gray-600">Monday & Wednesday</p>
                    <p className="text-sm text-gray-600">Art Room A</p>
                  </CardContent>
                </Card>
                <Card className="bg-yellow-100">
                  <CardContent className="p-4">
                    <h3 className="font-semibold">Science Lab</h3>
                    <p className="text-sm text-gray-600">Mr. Smith</p>
                    <p className="text-sm text-gray-600">Tuesday & Thursday</p>
                    <p className="text-sm text-gray-600">Lab 101</p>
                  </CardContent>
                </Card>
                <Card className="bg-blue-100">
                  <CardContent className="p-4">
                    <h3 className="font-semibold">Mathematics</h3>
                    <p className="text-sm text-gray-600">Ms. Davis</p>
                    <p className="text-sm text-gray-600">Monday & Friday</p>
                    <p className="text-sm text-gray-600">Room 202</p>
                  </CardContent>
                </Card>
                <Card className="bg-green-100">
                  <CardContent className="p-4">
                    <h3 className="font-semibold">Computer Science</h3>
                    <p className="text-sm text-gray-600">Mr. Wilson</p>
                    <p className="text-sm text-gray-600">Wednesday</p>
                    <p className="text-sm text-gray-600">Computer Lab</p>
                  </CardContent>
                </Card>
              </div>
            </div>
          </div>
          <div className="flex-1 overflow-auto p-6 bg-purple-50 bg-opacity-50 bg-[radial-gradient(#e5e7eb_1px,transparent_1px)] [background-size:16px_16px]">
            <h1 className="mb-6 text-2xl font-semibold text-gray-800">
              Your Grades Dashboard
            </h1>

            <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
              {/* Overall Percentage Card */}
              <Card className="col-span-1 bg-gradient-to-br from-blue-50 to-blue-100">
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                  <CardTitle className="text-sm font-medium">
                    Overall Percentage
                  </CardTitle>
                  <GraduationCap className="h-4 w-4 text-muted-foreground" />
                </CardHeader>
                <CardContent>
                  <div className="text-2xl font-bold">{overallPercentage}%</div>
                  <p className="text-xs text-muted-foreground">
                    Current Semester: {currentSemester}
                  </p>
                  <div className="mt-4 flex items-center">
                    <span className="text-green-600 font-semibold mr-2">
                      ↑ 2.5%
                    </span>
                    <span className="text-sm text-muted-foreground">
                      from last semester
                    </span>
                  </div>
                </CardContent>
              </Card>

              {/* Best Performing Subject Card */}
              <Card className="col-span-1 bg-gradient-to-br from-green-50 to-green-100">
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                  <CardTitle className="text-sm font-medium">
                    Best Performing Subject
                  </CardTitle>
                  <Award className="h-4 w-4 text-muted-foreground" />
                </CardHeader>
                <CardContent>
                  <div className="text-2xl font-bold">
                    {
                      gradesData.reduce((best, current) =>
                        current.totalMarks > best.totalMarks ? current : best
                      ).subject
                    }
                  </div>
                  <Progress
                    value={Math.max(
                      ...gradesData.map((grade) => grade.totalMarks)
                    )}
                    className="mt-2"
                  />
                  <p className="mt-2 text-sm text-muted-foreground">
                    Keep up the excellent work in this subject!
                  </p>
                </CardContent>
              </Card>

              <Card className="col-span-1 md:col-span-2 lg:col-span-1 bg-gradient-to-br from-yellow-50 to-yellow-100">
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                  <CardTitle className="text-sm font-medium">
                    Recent Achievements
                  </CardTitle>
                  <Star className="h-4 w-4 text-muted-foreground" />
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div className="flex items-center">
                      <div className="mr-4 rounded-full bg-yellow-100 p-2">
                        <Award className="h-4 w-4 text-yellow-600" />
                      </div>
                      <div>
                        <h3 className="font-semibold">
                          Top Scorer in Computer Science
                        </h3>
                        <p className="text-sm text-muted-foreground">
                          Highest marks in the class!
                        </p>
                      </div>
                    </div>
                    <div className="flex items-center">
                      <div className="mr-4 rounded-full bg-green-100 p-2">
                        <TrendingUp className="h-4 w-4 text-green-600" />
                      </div>
                      <div>
                        <h3 className="font-semibold">
                          Most Improved in Mathematics
                        </h3>
                        <p className="text-sm text-muted-foreground">
                          Significant progress from last term
                        </p>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>

            {/* Grades Table */}
            <Card className="mt-6 overflow-hidden border-t-4 border-purple-500">
              <CardContent className="px-10 py-5">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Subject</TableHead>
                      <TableHead>Marks Obtained</TableHead>
                      <TableHead>Percentage</TableHead>
                      <TableHead>Teacher</TableHead>
                      <TableHead>Details</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {gradesData.map((grade, index) => (
                      <TableRow key={index}>
                        <TableCell className="font-medium">
                          <div className="flex items-center">
                            <div
                              className="mr-2 rounded-full p-1"
                              style={{ backgroundColor: grade.color }}
                            >
                              {grade.icon}
                            </div>
                            {grade.subject}
                          </div>
                        </TableCell>
                        <TableCell>
                          {grade.totalMarks}/{grade.maxMarks}
                        </TableCell>
                        <TableCell>
                          <div className="flex items-center">
                            <span className="mr-2">
                              {(
                                (grade.totalMarks / grade.maxMarks) *
                                100
                              ).toFixed(2)}
                              %
                            </span>
                            <Progress
                              value={(grade.totalMarks / grade.maxMarks) * 100}
                              className="w-[60px]"
                            />
                          </div>
                        </TableCell>
                        <TableCell>{grade.teacher}</TableCell>
                        <TableCell>
                          <Dialog>
                            <DialogTrigger asChild>
                              <Button variant="outline" size="sm">
                                View Breakdown
                              </Button>
                            </DialogTrigger>
                            <DialogContent className="sm:max-w-[425px]">
                              <DialogHeader>
                                <DialogTitle>
                                  {grade.subject} - Exam Breakdown
                                </DialogTitle>
                                <DialogDescription>
                                  Detailed breakdown of marks for each exam in{" "}
                                  {grade.subject}.
                                </DialogDescription>
                              </DialogHeader>
                              <Table>
                                <TableHeader>
                                  <TableRow>
                                    <TableHead>Exam</TableHead>
                                    <TableHead>Marks</TableHead>
                                    <TableHead>Percentage</TableHead>
                                  </TableRow>
                                </TableHeader>
                                <TableBody>
                                  {grade.exams.map((exam, examIndex) => (
                                    <TableRow key={examIndex}>
                                      <TableCell>{exam.name}</TableCell>
                                      <TableCell>
                                        {exam.marks}/{exam.maxMarks}
                                      </TableCell>
                                      <TableCell>
                                        {(
                                          (exam.marks / exam.maxMarks) *
                                          100
                                        ).toFixed(2)}
                                        %
                                      </TableCell>
                                    </TableRow>
                                  ))}
                                </TableBody>
                              </Table>
                            </DialogContent>
                          </Dialog>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </CardContent>
            </Card>
          </div>
        </div>
        '
        <div className="py-8">
          <Community setIsChatOpen={setIsChatOpen} isChatOpen={isChatOpen} />
        </div>
        {/* Toggle Button - Fixed Position */}
        {!isChatOpen && (
          <motion.div
            className="fixed bottom-4 right-4"
            animate={{
              right: isChatOpen ? "21rem" : "1rem",
            }}
            transition={{
              duration: 0.3,
              ease: "easeInOut",
            }}
          >
            <Button
              onClick={() => setIsChatOpen(!isChatOpen)}
              className="rounded-full w-12 h-12 bg-purple-600 hover:bg-purple-700 shadow-lg flex items-center justify-center"
            >
              <MessageCircle className="h-6 w-6" />
            </Button>
          </motion.div>
        )}
      </div>
    </div>
  );
}
