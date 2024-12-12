"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  BookOpen,
  Calendar,
  ChevronLeft,
  ChevronRight,
  GraduationCap,
  Home,
  Library,
  LogOut,
  MessageCircle,
  Settings,
  Star,
  User2,
  FileText,
  Users,
  Bell,
} from "lucide-react";


export default function SchedulePage() {
  const [currentWeek, setCurrentWeek] = useState("Week of January 15, 2024");

  const scheduleData = [
    {
      day: "Monday",
      classes: [
        {
          time: "09:00 AM - 10:30 AM",
          subject: "Mathematics",
          teacher: "Ms. Davis",
          room: "Room 202",
          color: "bg-pink-100",
        },
        {
          time: "11:00 AM - 12:30 PM",
          subject: "English Literature",
          teacher: "Mr. Thompson",
          room: "Room 105",
          color: "bg-blue-100",
        },
        {
          time: "02:00 PM - 03:30 PM",
          subject: "Physics",
          teacher: "Dr. Martinez",
          room: "Lab 301",
          color: "bg-green-100",
        },
      ],
    },
    {
      day: "Tuesday",
      classes: [
        {
          time: "09:00 AM - 10:30 AM",
          subject: "History",
          teacher: "Mrs. Anderson",
          room: "Room 204",
          color: "bg-yellow-100",
        },
        {
          time: "11:00 AM - 12:30 PM",
          subject: "Computer Science",
          teacher: "Mr. Wilson",
          room: "Computer Lab",
          color: "bg-purple-100",
        },
        {
          time: "02:00 PM - 03:30 PM",
          subject: "Art & Crafts",
          teacher: "Ms. Johnson",
          room: "Art Room A",
          color: "bg-orange-100",
        },
      ],
    },
    {
      day: "Wednesday",
      classes: [
        {
          time: "09:00 AM - 10:30 AM",
          subject: "Biology",
          teacher: "Dr. Patel",
          room: "Lab 201",
          color: "bg-pink-100",
        },
        {
          time: "11:00 AM - 12:30 PM",
          subject: "Physical Education",
          teacher: "Coach Brown",
          room: "Gymnasium",
          color: "bg-blue-100",
        },
        {
          time: "02:00 PM - 03:30 PM",
          subject: "Mathematics",
          teacher: "Ms. Davis",
          room: "Room 202",
          color: "bg-green-100",
        },
      ],
    },
    {
      day: "Thursday",
      classes: [
        {
          time: "09:00 AM - 10:30 AM",
          subject: "English Literature",
          teacher: "Mr. Thompson",
          room: "Room 105",
          color: "bg-yellow-100",
        },
        {
          time: "11:00 AM - 12:30 PM",
          subject: "Chemistry",
          teacher: "Dr. Lee",
          room: "Lab 302",
          color: "bg-purple-100",
        },
        {
          time: "02:00 PM - 03:30 PM",
          subject: "Music",
          teacher: "Mr. Garcia",
          room: "Music Room",
          color: "bg-orange-100",
        },
      ],
    },
    {
      day: "Friday",
      classes: [
        {
          time: "09:00 AM - 10:30 AM",
          subject: "Physics",
          teacher: "Dr. Martinez",
          room: "Lab 301",
          color: "bg-pink-100",
        },
        {
          time: "11:00 AM - 12:30 PM",
          subject: "History",
          teacher: "Mrs. Anderson",
          room: "Room 204",
          color: "bg-blue-100",
        },
        {
          time: "02:00 PM - 03:30 PM",
          subject: "Computer Science",
          teacher: "Mr. Wilson",
          room: "Computer Lab",
          color: "bg-green-100",
        },
      ],
    },
  ];

  return (
    <div className="flex min-h-screen bg-purple-50">
      {/* Sidebar */}
      {/* Main Content */}
      <div className="flex-1 overflow-auto p-6">
        <div className="mb-6">
          <h1 className="text-2xl font-bold">📅 Your Schedule</h1>
        </div>
        <Card className="overflow-hidden">
          <CardContent className="p-0">
            <div className="overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead className="w-[120px] bg-blue-100 text-center">
                      Time
                    </TableHead>
                    {scheduleData.map((day) => (
                      <TableHead
                        key={day.day}
                        className="bg-blue-100 text-center"
                      >
                        {day.day}
                      </TableHead>
                    ))}
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {[
                    "09:00 AM - 10:30 AM",
                    "11:00 AM - 12:30 PM",
                    "02:00 PM - 03:30 PM",
                    "04:00 PM - 05:30 PM",
                  ].map((timeSlot) => (
                    <TableRow key={timeSlot}>
                      <TableCell className="text-center font-medium">
                        {timeSlot}
                      </TableCell>
                      {scheduleData.map((day) => {
                        const classInfo = day.classes.find(
                          (c) => c.time === timeSlot
                        );
                        return (
                          <TableCell key={day.day} className="p-1">
                            {classInfo ? (
                              <div
                                className={`rounded-md ${classInfo.color} p-4 text-center h-[160px] flex flex-col justify-center`}
                              >
                                <div className="font-semibold">
                                  {classInfo.subject}
                                </div>
                                <div className="text-sm text-gray-600">
                                  {classInfo.teacher}
                                </div>
                                <div className="text-sm text-gray-600">
                                  {classInfo.room}
                                </div>
                              </div>
                            ) : (
                              <div className="h-full min-h-[160px]"></div>
                            )}
                          </TableCell>
                        );
                      })}
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
