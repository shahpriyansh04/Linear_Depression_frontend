"use client";

import React, { useState } from "react";
import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Progress } from "@/components/ui/progress";
import {
  CalendarDays,
  Clock,
  Download,
  Trash2,
  Plus,
  BookOpen,
} from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Checkbox } from "@/components/ui/checkbox";
import Link from "next/link";
import StudyTimer from "@/components/ui/planner/studytime";
import WeeklyProgress from "@/components/ui/planner/weeklyprogress";
import Notes from "@/components/ui/planner/notes";
import CommitGraph from "@/components/ui/planner/commitgraph";
import RoadmapTimeline from "@/components/ui/planner/roadmap/roadmaptimeline";

const schedules = [
  {
    id: 1,
    date: "2024-03-15",
    followed: false,
    tasks: [
      { time: "09:00 AM", task: "Math Study" },
      { time: "11:00 AM", task: "Science Experiment" },
      { time: "02:00 PM", task: "English Literature" },
    ],
  },
  {
    id: 2,
    date: "2024-03-16",
    followed: true,
    tasks: [
      { time: "10:00 AM", task: "History Review" },
      { time: "01:00 PM", task: "Computer Science Project" },
      { time: "03:00 PM", task: "Physical Education" },
    ],
  },
];

const roadmaps = [
  {
    id: 1,
    subject: "Mathematics",
    duration: "12 weeks",
    progress: 25,
    chapters: [
      { name: "Algebra Basics", week: 1, completed: true },
      { name: "Linear Equations", week: 2, completed: true },
      { name: "Quadratic Equations", week: 3, completed: false },
      { name: "Polynomials", week: 4, completed: false },
    ],
  },
  {
    id: 2,
    subject: "Physics",
    duration: "10 weeks",
    progress: 40,
    chapters: [
      { name: "Kinematics", week: 1, completed: true },
      { name: "Dynamics", week: 2, completed: true },
      { name: "Work and Energy", week: 3, completed: true },
      { name: "Rotational Motion", week: 4, completed: false },
      { name: "Gravitation", week: 5, completed: false },
    ],
  },
];

const handleDownload = (scheduleId: Number) => {
  const schedule = schedules.find((s) => s.id === scheduleId);
  if (schedule) {
    const blob = new Blob([JSON.stringify(schedule, null, 2)], {
      type: "application/json",
    });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `schedule_${schedule.date}.json`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  }
};

const handleDelete = (scheduleId: Number) => {
  // Implement delete functionality
  console.log(`Deleting schedule ${scheduleId}`);
};

export default function StudyPlanner() {
  const [selectedSchedule, setSelectedSchedule] = useState(null);
  const [scheduleList, setScheduleList] = useState(schedules);

  const toggleFollowed = (id: Number) => {
    setScheduleList(
      scheduleList.map((schedule) =>
        schedule.id === id
          ? { ...schedule, followed: !schedule.followed }
          : schedule
      )
    );
  };

  return (
    <motion.div
      className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-100 p-8"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ duration: 0.5 }}
    >
      <motion.h1
        className="text-4xl font-bold text-center text-indigo-800 mb-8"
        initial={{ opacity: 0, y: -50 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
      >
        Study Planner & Roadmap Generator
      </motion.h1>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-12">
        <Card className="col-span-2 bg-white/90 backdrop-blur-sm shadow-xl">
          <CardHeader className="flex flex-row items-center justify-between">
            <CardTitle className="text-2xl font-semibold text-indigo-700">
              Schedule Planner
            </CardTitle>
            <Link href="/dashboard/student/planner/newschedule">
              //{" "}
              <Button
                variant="outline"
                className="bg-yellow-200 hover:bg-yellow-300 text-indigo-700 rounded-full shadow-md"
              >
                // <Plus className="w-4 h-4 mr-2" /> Create New Schedule //{" "}
              </Button>
              //{" "}
            </Link>
          </CardHeader>
          <CardContent>
            <ScrollArea className="h-[300px] w-full rounded-md border p-4">
              {scheduleList.map((schedule) => (
                <motion.div
                  key={schedule.id}
                  className="mb-4 last:mb-0"
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ duration: 0.3 }}
                >
                  <Card className="bg-indigo-50 hover:bg-indigo-100 transition-colors duration-200">
                    <CardHeader className="flex flex-row items-center justify-between py-2">
                      <CardTitle className="text-lg font-medium flex items-center">
                        <CalendarDays className="w-5 h-5 mr-2 text-purple-500" />
                        {schedule.date}
                      </CardTitle>
                      <div className="flex space-x-2 items-center">
                        <Checkbox
                          checked={schedule.followed}
                          onCheckedChange={() => toggleFollowed(schedule.id)}
                          id={`followed-${schedule.id}`}
                        />
                        <label
                          htmlFor={`followed-${schedule.id}`}
                          className="text-sm text-gray-700 cursor-pointer"
                        >
                          Followed
                        </label>
                        <Dialog>
                          <DialogTrigger asChild>
                            <Button
                              variant="ghost"
                              size="sm"
                              className="text-blue-600 hover:text-blue-800"
                            >
                              View
                            </Button>
                          </DialogTrigger>
                          <DialogContent className="sm:max-w-[425px] rounded-lg bg-white">
                            <DialogHeader>
                              <DialogTitle>
                                Schedule for {schedule.date}
                              </DialogTitle>
                              <DialogDescription>
                                Your tasks for the day
                              </DialogDescription>
                            </DialogHeader>
                            <div className="grid gap-4 py-4">
                              {schedule.tasks.map((task, index) => (
                                <div
                                  key={index}
                                  className="flex items-center space-x-4"
                                >
                                  <Clock className="w-4 h-4 text-gray-500" />
                                  <div className="flex-1 space-y-1">
                                    <p className="text-sm font-medium leading-none">
                                      {task.time}
                                    </p>
                                    <p className="text-sm text-gray-500">
                                      {task.task}
                                    </p>
                                  </div>
                                </div>
                              ))}
                            </div>
                          </DialogContent>
                        </Dialog>
                        <Button
                          variant="ghost"
                          size="sm"
                          className="text-green-600 hover:text-green-800"
                          onClick={() => handleDownload(schedule.id)}
                        >
                          <Download className="w-4 h-4" />
                        </Button>
                        <Button
                          variant="ghost"
                          size="sm"
                          className="text-red-600 hover:text-red-800"
                          onClick={() => handleDelete(schedule.id)}
                        >
                          <Trash2 className="w-4 h-4" />
                        </Button>
                      </div>
                    </CardHeader>
                  </Card>
                </motion.div>
              ))}
            </ScrollArea>
          </CardContent>
        </Card>

        <Card className="bg-white/80 backdrop-blur-sm shadow-xl">
          <CardHeader>
            <CardTitle className="text-2xl font-semibold text-blue-700">
              Study Timer
            </CardTitle>
          </CardHeader>
          <CardContent>
            <StudyTimer />
          </CardContent>
        </Card>
      </div>
      {/* needned */}
      <Card className="bg-white/90 backdrop-blur-sm shadow-xl mb-8">
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle className="text-2xl font-semibold text-indigo-700">
            Roadmap Generator
          </CardTitle>
          <Link href="/dashboard/student/planner/newroadmap">
            //{" "}
            <Button
              variant="outline"
              className="bg-green-200 hover:bg-green-300 text-indigo-700 rounded-full shadow-md"
            >
              // <Plus className="w-4 h-4 mr-2" /> Create New Roadmap //{" "}
            </Button>
            //{" "}
          </Link>
        </CardHeader>
        <CardContent>
          <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
            {roadmaps.map((roadmap) => (
              <motion.div
                key={roadmap.id}
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ duration: 0.3 }}
              >
                <Card className="bg-purple-50 hover:bg-purple-100 transition-colors duration-200">
                  <CardHeader>
                    <CardTitle className="text-lg font-medium flex items-center">
                      <BookOpen className="w-5 h-5 mr-2 text-indigo-500" />
                      {roadmap.subject}
                    </CardTitle>
                    <CardDescription>{roadmap.duration}</CardDescription>
                  </CardHeader>
                  <CardContent>
                    <Progress value={roadmap.progress} className="w-full" />
                    <p className="text-sm text-gray-500 mt-2">
                      {roadmap.progress}% Completed
                    </p>
                  </CardContent>
                  <CardFooter>
                    <Dialog>
                      <DialogTrigger asChild>
                        <Button
                          variant="outline"
                          className="bg-yellow-200 hover:bg-yellow-300 text-indigo-700 rounded-full shadow-md"
                        >
                          // <Plus className="w-4 h-4 mr-2" /> View Roadmap //{" "}
                        </Button>
                      </DialogTrigger>
                      <DialogContent className="sm:max-w-[600px] bg-white rounded-lg ">
                        <DialogHeader>
                          <DialogTitle>{roadmap.subject} Roadmap</DialogTitle>
                          <DialogDescription>
                            Your learning journey for {roadmap.duration}
                          </DialogDescription>
                        </DialogHeader>
                        <RoadmapTimeline
                          chapters={roadmap.chapters}
                          subject={roadmap.subject}
                        />
                      </DialogContent>
                    </Dialog>
                  </CardFooter>
                </Card>
              </motion.div>
            ))}
          </div>
        </CardContent>
      </Card>

      <div className="flex flex-col gap-10">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mt-8">
          <Card className="bg-white/90 backdrop-blur-sm shadow-xl rounded-xl">
            <CardHeader>
              <CardTitle className="text-2xl font-semibold text-indigo-700">
                Weekly Progress
              </CardTitle>
            </CardHeader>
            <CardContent className="flex justify-center">
              <WeeklyProgress />
            </CardContent>
          </Card>

          <Card className="bg-white/90 backdrop-blur-sm shadow-xl rounded-xl">
            <CardHeader>
              <CardTitle className="text-2xl font-semibold text-indigo-700">
                Notes
              </CardTitle>
            </CardHeader>
            <CardContent className="flex justify-center">
              <Notes />
            </CardContent>
          </Card>
        </div>
        <Card className="bg-white/90 backdrop-blur-sm w-[90vw] shadow-xl md:col-span-2">
          <CardHeader>
            <CardTitle className="text-2xl font-semibold text-indigo-700">
              Productivity Tracker
            </CardTitle>
          </CardHeader>
          <CardContent>
            <CommitGraph />
          </CardContent>
        </Card>
      </div>
    </motion.div>
  );
} //
