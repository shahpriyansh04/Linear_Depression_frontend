"use client";

import React from "react";
import Link from "next/link";
import {
  BarChart,
  Bar,
  LineChart,
  Line,
  PieChart,
  Pie,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
  Cell,
} from "recharts";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { AvatarImage, AvatarFallback } from "@/components/ui/avatar";
import { Avatar } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import {
  UserCircle,
  Bell,
  Calendar,
  BookOpen,
  Users,
  Clock,
  TrendingUp,
  Award,
  MessageCircle,
  ChevronRight,
} from "lucide-react";
import { logout } from "@/app/auth/action";

export default function ParentDashboard() {
  // Performance Trend Data
  const performanceData = [
    { month: "Apr", score: 65 },
    { month: "May", score: 68 },
    { month: "Jun", score: 75 },
    { month: "Jul", score: 78 },
    { month: "Aug", score: 82 },
  ];

  // Subject-wise Performance Data
  const subjectData = [
    { subject: "Math", score: 85 },
    { subject: "Science", score: 78 },
    { subject: "English", score: 92 },
    { subject: "History", score: 70 },
    { subject: "Geography", score: 88 },
  ];

  // Peer Comparison Data
  const peerComparisonData = [
    { name: "Top 10%", value: 10 },
    { name: "Top 25%", value: 15 },
    { name: "Average", value: 50 },
    { name: "Below Average", value: 25 },
  ];

  // Attendance Data
  const attendanceData = [
    { month: "Jan", attendance: 95 },
    { month: "Feb", attendance: 98 },
    { month: "Mar", attendance: 92 },
    { month: "Apr", attendance: 96 },
    { month: "May", attendance: 94 },
  ];

  // Extracurricular Performance Data
  const extracurricularData = [
    { activity: "Sports", score: 85 },
    { activity: "Music", score: 70 },
    { activity: "Art", score: 90 },
    { activity: "Debate", score: 75 },
    { activity: "Coding", score: 80 },
  ];

  const COLORS = ["#0088FE", "#00C49F", "#FFBB28", "#FF8042", "#8884d8"];

  return (
    <div className="min-h-screen bg-purple-50 p-8">
      <Button onClick={async () => await logout()}>Logout</Button>
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Student Overview Section */}
        <Card className="col-span-full bg-white shadow-lg">
          <CardHeader>
            <CardTitle className="text-2xl font-bold text-gray-800">
              Student Overview
            </CardTitle>
          </CardHeader>
          <CardContent className="flex items-center space-x-8">
            <Avatar className="w-24 h-24">
              <AvatarImage
                src="/placeholder.svg?height=96&width=96"
                alt="Aarav Patel"
              />
              <AvatarFallback>AP</AvatarFallback>
            </Avatar>
            <div className="space-y-2">
              <p className="text-lg">
                <span className="font-semibold">Name:</span> Aarav Patel
              </p>
              <p className="text-lg">
                <span className="font-semibold">Class:</span> 10th Standard
              </p>
              <p className="text-lg">
                <span className="font-semibold">Overall Grade:</span>{" "}
                <span className="text-green-600 font-bold">A</span>
              </p>
              <p className="text-lg">
                <span className="font-semibold">Attendance:</span> 95%
              </p>
            </div>
          </CardContent>
        </Card>

        {/* Recent Notifications Section */}
        <Card className="col-span-full lg:col-span-2 bg-white shadow-lg">
          <CardHeader>
            <CardTitle className="text-2xl font-bold text-gray-800 flex items-center">
              <Bell className="mr-2" />
              Recent Notifications
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {[
                {
                  title: "Math Test",
                  description: "Scheduled for next week",
                  icon: BookOpen,
                  color: "bg-blue-100 text-blue-600",
                },
                {
                  title: "Science Project",
                  description: "Due in 3 days",
                  icon: Clock,
                  color: "bg-green-100 text-green-600",
                },
                {
                  title: "Parent-Teacher Meeting",
                  description: "This Friday at 4 PM",
                  icon: Users,
                  color: "bg-purple-100 text-purple-600",
                },
              ].map((notification, index) => (
                <div
                  key={index}
                  className={`flex items-center p-4 rounded-lg ${notification.color}`}
                >
                  <notification.icon className="w-8 h-8 mr-4" />
                  <div>
                    <h3 className="font-semibold">{notification.title}</h3>
                    <p>{notification.description}</p>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Upcoming Events Section */}
        <Card className="col-span-full lg:col-span-1 bg-white shadow-lg">
          <CardHeader>
            <CardTitle className="text-2xl font-bold text-gray-800 flex items-center">
              <Calendar className="mr-2" />
              Upcoming Events
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {[
                { date: "15 Aug", title: "Career Guidance Workshop" },
                { date: "22 Aug", title: "Science Fair" },
                { date: "5 Sep", title: "Sports Day" },
              ].map((event, index) => (
                <div
                  key={index}
                  className="flex items-center bg-gray-100 p-4 rounded-lg"
                >
                  <div className="w-16 h-16 bg-indigo-100 text-indigo-600 rounded-full flex items-center justify-center mr-4">
                    <div className="text-center">
                      <div className="font-bold">
                        {event.date.split(" ")[0]}
                      </div>
                      <div className="text-sm">{event.date.split(" ")[1]}</div>
                    </div>
                  </div>
                  <div>
                    <h3 className="font-semibold">{event.title}</h3>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Academic Performance Graph */}
        <Card className="col-span-full bg-white shadow-lg">
          <CardHeader>
            <CardTitle className="text-2xl font-bold text-gray-800 flex items-center">
              <TrendingUp className="mr-2" />
              Academic Performance Trend
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <LineChart data={performanceData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="month" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Line type="monotone" dataKey="score" stroke="#8884d8" />
              </LineChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        {/* Subject-wise Performance */}
        <Card className="col-span-full lg:col-span-2 bg-white shadow-lg">
          <CardHeader>
            <CardTitle className="text-2xl font-bold text-gray-800 flex items-center">
              <BookOpen className="mr-2" />
              Subject-wise Performance
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <BarChart data={subjectData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="subject" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Bar dataKey="score" fill="#8884d8" />
              </BarChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        {/* Peer Comparison */}
        <Card className="col-span-full lg:col-span-1 bg-white shadow-lg">
          <CardHeader>
            <CardTitle className="text-2xl font-bold text-gray-800 flex items-center">
              <Users className="mr-2" />
              Peer Comparison
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <PieChart>
                <Pie
                  data={peerComparisonData}
                  cx="50%"
                  cy="50%"
                  outerRadius={80}
                  fill="#8884d8"
                  dataKey="value"
                  label
                >
                  {peerComparisonData.map((entry, index) => (
                    <Cell
                      key={`cell-${index}`}
                      fill={COLORS[index % COLORS.length]}
                    />
                  ))}
                </Pie>
                <Tooltip />
                <Legend />
              </PieChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        {/* Attendance Chart */}
        <Card className="col-span-full lg:col-span-2 bg-white shadow-lg">
          <CardHeader>
            <CardTitle className="text-2xl font-bold text-gray-800 flex items-center">
              <Calendar className="mr-2" />
              Monthly Attendance
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <LineChart data={attendanceData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="month" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Line type="monotone" dataKey="attendance" stroke="#82ca9d" />
              </LineChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        {/* Extracurricular Performance */}
        <Card className="col-span-full lg:col-span-1 bg-white shadow-lg">
          <CardHeader>
            <CardTitle className="text-2xl font-bold text-gray-800 flex items-center">
              <Award className="mr-2" />
              Extracurricular
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <BarChart data={extracurricularData} layout="vertical">
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis type="number" />
                <YAxis dataKey="activity" type="category" />
                <Tooltip />
                <Legend />
                <Bar dataKey="score" fill="#82ca9d" />
              </BarChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        {/* Success Stories */}
        {/* <Card className="col-span-full bg-white shadow-lg">
          <CardHeader>
            <CardTitle className="text-2xl font-bold text-gray-800 flex items-center">
              <Award className="mr-2" />
              Success Stories
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              {[
                {
                  name: "Priya Sharma",
                  year: 2020,
                  job: "Software Engineer",
                  company: "Google",
                },
                {
                  name: "Rahul Verma",
                  year: 2019,
                  job: "Data Scientist",
                  company: "Amazon",
                },
                {
                  name: "Anita Desai",
                  year: 2021,
                  job: "Product Manager",
                  company: "Microsoft",
                },
              ].map((graduate, index) => (
                <div
                  key={index}
                  className="bg-gradient-to-br from-purple-100 to-indigo-100 rounded-lg p-6 shadow-md hover:shadow-lg transition-shadow duration-300"
                >
                  <img
                    src={`/placeholder.svg?height=100&width=100&text=${graduate.name.charAt(
                      0
                    )}`}
                    alt={graduate.name}
                    className="w-24 h-24 rounded-full mx-auto mb-4 bg-white"
                  />
                  <h3 className="text-lg font-semibold text-center mb-2">
                    {graduate.name}
                  </h3>
                  <p className="text-sm text-gray-600 text-center">
                    Graduated in {graduate.year}, now working as a{" "}
                    {graduate.job} at {graduate.company}.
                  </p>
                </div>
              ))}
            </div>
          </CardContent>
        </Card> */}

        {/* Quick Links */}
        {/* <Card className="col-span-full bg-white shadow-lg">
          <CardHeader>
            <CardTitle className="text-2xl font-bold text-gray-800">
              Quick Links
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              {[
                {
                  title: "Overall Progress",
                  icon: TrendingUp,
                  href: "/dashboard/parents/progress",
                },
                {
                  title: "Community",
                  icon: Users,
                  href: "/dashboard/parents/community",
                },
                {
                  title: "Communication",
                  icon: MessageCircle,
                  href: "/dashboard/parents/communication",
                },
                {
                  title: "Resources",
                  icon: BookOpen,
                  href: "/dashboard/parents/resources",
                },
              ].map((link, index) => (
                <Link key={index} href={link.href}>
                  <Button
                    variant="outline"
                    className="w-full h-full py-6 flex flex-col items-center justify-center space-y-2"
                  >
                    <link.icon className="w-6 h-6" />
                    <span>{link.title}</span>
                  </Button>
                </Link>
              ))}
            </div>
          </CardContent>
        </Card> */}
      </div>
    </div>
  );
}
