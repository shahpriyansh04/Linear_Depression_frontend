"use client"

import { useState } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Progress } from '@/components/ui/progress'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, LineChart, Line, PieChart, Pie, Cell } from 'recharts'
import { Award, GraduationCap, MessageCircle, Star, TrendingUp, Users, BookOpen, AlertTriangle, Calendar, PlusCircle } from 'lucide-react'
import { motion } from 'framer-motion'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Calendar as CalendarComponent } from "@/components/ui/calendar"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"

// Mock data for teacher's dashboard
const teacherName = 'Ms. Johnson'
const classesData = [
  { name: 'Mathematics 101', students: 30, averageGrade: 85, attendance: 92 },
  { name: 'Advanced Algebra', students: 25, averageGrade: 78, attendance: 88 },
  { name: 'Geometry Basics', students: 28, averageGrade: 82, attendance: 90 },
]

const atRiskStudents = [
  { id: 1, name: 'John Doe', grade: 65, attendance: 70, reason: 'Low grades and attendance' },
  { id: 2, name: 'Jane Smith', grade: 68, attendance: 75, reason: 'Struggling with recent topics' },
  { id: 3, name: 'Mike Johnson', grade: 72, attendance: 68, reason: 'Frequent absences' },
]

const overallClassProgress = [
  { subject: 'Mathematics 101', completed: 75 },
  { subject: 'Advanced Algebra', completed: 60 },
  { subject: 'Geometry Basics', completed: 80 },
]

const attendanceData = [
  { month: 'Sep', Mathematics: 95, Algebra: 92, Geometry: 88 },
  { month: 'Oct', Mathematics: 93, Algebra: 90, Geometry: 91 },
  { month: 'Nov', Mathematics: 97, Algebra: 88, Geometry: 93 },
  { month: 'Dec', Mathematics: 94, Algebra: 91, Geometry: 90 },
]

const gradeDistribution = [
  { name: 'A', value: 30, color: '#4CAF50' },
  { name: 'B', value: 40, color: '#2196F3' },
  { name: 'C', value: 20, color: '#FFC107' },
  { name: 'D', value: 7, color: '#FF9800' },
  { name: 'F', value: 3, color: '#F44336' },
]

const upcomingLectures = [
  { id: 1, class: 'Mathematics 101', time: '9:00 AM - 10:30 AM', room: 'Room 201' },
  { id: 2, class: 'Advanced Algebra', time: '11:00 AM - 12:30 PM', room: 'Room 305' },
  { id: 3, class: 'Geometry Basics', time: '2:00 PM - 3:30 PM', room: 'Room 102' },
]

const initialAssignments = [
  { id: 1, title: 'Quadratic Equations', class: 'Mathematics 101', dueDate: '2023-07-15' },
  { id: 2, title: 'Linear Algebra Basics', class: 'Advanced Algebra', dueDate: '2023-07-20' },
  { id: 3, title: 'Triangles and Circles', class: 'Geometry Basics', dueDate: '2023-07-18' },
]

const recentChats = [
  { id: 1, parent: 'Mr. Smith', student: 'John Smith', lastMessage: 'Thank you for the update on John\'s progress.' },
  { id: 2, parent: 'Mrs. Johnson', student: 'Emily Johnson', lastMessage: 'I\'d like to schedule a meeting to discuss Emily\'s performance.' },
  { id: 3, parent: 'Mr. Brown', student: 'Michael Brown', lastMessage: 'Michael has been working hard on his math assignments.' },
]

export default function TeacherDashboard() {
  const [isChatOpen, setIsChatOpen] = useState(false)
  const [date, setDate] = useState<Date | undefined>(new Date())
  const [assignments, setAssignments] = useState(initialAssignments)
  const [newAssignment, setNewAssignment] = useState({ title: '', class: '', dueDate: '' })
  const [isNewAssignmentDialogOpen, setIsNewAssignmentDialogOpen] = useState(false)

  const handleCreateAssignment = () => {
    if (newAssignment.title && newAssignment.class && newAssignment.dueDate) {
      setAssignments([...assignments, { ...newAssignment, id: assignments.length + 1 }])
      setNewAssignment({ title: '', class: '', dueDate: '' })
      setIsNewAssignmentDialogOpen(false)
    }
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="p-8">
        <h1 className="text-3xl font-bold mb-8 text-purple-800">
          👋 Welcome, {teacherName}!
        </h1>
        {/* <div className="mb-8">
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
            </div> */}

        {/* Class Progress Overview */}
        <div className="mb-8">
          <h2 className="text-2xl font-semibold mb-4 text-purple-700">Class Progress</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {classesData.map((classItem, index) => (
            //   <Card key={index} className={`bg-gradient-to-br from-${['yellow', 'blue', 'pink'][index]}-100 to-${['yellow', 'indigo', 'pink'][index]}-300`}>
               <Card key={index} className={`bg-${['blue', 'green', 'pink'][index]}-100`}> 
                <CardHeader>
                  <CardTitle className="text-lg text-gray-600">{classItem.name}</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="flex justify-between items-center mb-2">
                    <span className="text-sm text-gray-600">Students: {classItem.students}</span>
                    <Users className="h-5 w-5 text-gray-600" />
                  </div>
                  <div className="mb-2">
                    <div className="flex justify-between mb-1">
                      <span className="text-sm text-gray-600">Average Grade:</span>
                      <span className="text-sm font-semibold">{classItem.averageGrade}%</span>
                    </div>
                    <Progress value={classItem.averageGrade} className="h-2" />
                  </div>
                  <div>
                    <div className="flex justify-between mb-1">
                      <span className="text-sm text-gray-600">Attendance:</span>
                      <span className="text-sm font-semibold">{classItem.attendance}%</span>
                    </div>
                    <Progress value={classItem.attendance} className="h-2" />
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>

        {/* Overall Class Progress Chart */}
        <Card className="mb-8">
          <CardHeader>
            <CardTitle className="text-xl text-purple-700">Overall Class Progress</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="h-[300px]">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={overallClassProgress}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="subject" />
                  <YAxis />
                  <Tooltip />
                  <Legend />
                  <Bar dataKey="completed" fill="#8884d8" name="Completed (%)" />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </CardContent>
        </Card>

        {/* At-Risk Students */}
        <Card className="mb-8 border-2 border-red-300">
          <CardHeader className="bg-red-50">
            <CardTitle className="flex items-center text-xl text-red-700">
              <AlertTriangle className="mr-2 h-5 w-5 text-red-500" />
              Students at Risk
            </CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Name</TableHead>
                  <TableHead>Grade</TableHead>
                  <TableHead>Attendance</TableHead>
                  <TableHead>Reason</TableHead>
                  <TableHead>Action</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {atRiskStudents.map((student) => (
                  <TableRow key={student.id} className="hover:bg-red-50">
                    <TableCell className="font-medium">{student.name}</TableCell>
                    <TableCell className="text-red-600">{student.grade}%</TableCell>
                    <TableCell className="text-red-600">{student.attendance}%</TableCell>
                    <TableCell>{student.reason}</TableCell>
                    <TableCell>
                      <Button variant="outline" size="sm" className="text-red-600 border-red-300 hover:bg-red-50">
                        Contact Parents
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>

        {/* Upcoming Lectures and Calendar */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mb-8">
          <Card>
            <CardHeader>
              <CardTitle className="text-xl text-purple-700">Upcoming Lectures</CardTitle>
            </CardHeader>
            <CardContent>
              <ul className="space-y-4">
                {upcomingLectures.map((lecture) => (
                  <li key={lecture.id} className="flex items-center space-x-4 p-2 rounded-lg bg-gray-50">
                    <div className="flex-shrink-0 w-12 h-12 rounded-full bg-purple-200 flex items-center justify-center">
                      <BookOpen className="w-6 h-6 text-purple-600" />
                    </div>
                    <div className="flex-grow">
                      <h4 className="font-semibold text-purple-800">{lecture.class}</h4>
                      <p className="text-sm text-gray-600">{lecture.time}</p>
                      <p className="text-sm text-gray-600">{lecture.room}</p>
                    </div>
                  </li>
                ))}
              </ul>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="text-xl text-purple-700">Calendar</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="flex justify-center">
                <CalendarComponent
                  mode="single"
                  selected={date}
                  onSelect={setDate}
                  className="rounded-md border shadow-sm"
                />
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Assignments Section */}
        <Card className="mb-8">
          <CardHeader className="flex flex-row items-center justify-between">
            <CardTitle className="text-xl text-purple-700">Assignments</CardTitle>
            <Dialog open={isNewAssignmentDialogOpen} onOpenChange={setIsNewAssignmentDialogOpen}>
              <DialogTrigger asChild>
                <Button className="bg-purple-600 hover:bg-purple-700">
                  <PlusCircle className="mr-2 h-4 w-4" />
                  New Assignment
                </Button>
              </DialogTrigger>
              <DialogContent>
                <DialogHeader>
                  <DialogTitle>Create New Assignment</DialogTitle>
                </DialogHeader>
                <div className="grid gap-4 py-4">
                  <div className="grid grid-cols-4 items-center gap-4">
                    <Label htmlFor="title" className="text-right">
                      Title
                    </Label>
                    <Input
                      id="title"
                      value={newAssignment.title}
                      onChange={(e) => setNewAssignment({ ...newAssignment, title: e.target.value })}
                      className="col-span-3"
                    />
                  </div>
                  <div className="grid grid-cols-4 items-center gap-4">
                    <Label htmlFor="class" className="text-right">
                      Class
                    </Label>
                    <Select
                      value={newAssignment.class}
                      onValueChange={(value) => setNewAssignment({ ...newAssignment, class: value })}
                    >
                      <SelectTrigger className="col-span-3">
                        <SelectValue placeholder="Select a class" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="Mathematics 101">Mathematics 101</SelectItem>
                        <SelectItem value="Advanced Algebra">Advanced Algebra</SelectItem>
                        <SelectItem value="Geometry Basics">Geometry Basics</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="grid grid-cols-4 items-center gap-4">
                    <Label htmlFor="dueDate" className="text-right">
                      Due Date
                    </Label>
                    <Input
                      id="dueDate"
                      type="date"
                      value={newAssignment.dueDate}
                      onChange={(e) => setNewAssignment({ ...newAssignment, dueDate: e.target.value })}
                      className="col-span-3"
                    />
                  </div>
                </div>
                <div className="flex justify-end">
                  <Button onClick={handleCreateAssignment}>Create Assignment</Button>
                </div>
              </DialogContent>
            </Dialog>
          </CardHeader>
          <CardContent>
            <ul className="space-y-2">
              {assignments.map((assignment) => (
                <li key={assignment.id} className="flex justify-between items-center p-2 hover:bg-gray-100 rounded">
                  <div>
                    <span className="font-semibold">{assignment.title}</span>
                    <p className="text-sm text-gray-600">{assignment.class}</p>
                  </div>
                  <span className="text-sm">Due: {assignment.dueDate}</span>
                </li>
              ))}
            </ul>
          </CardContent>
        </Card>
           {/* Teacher Performance Metrics */}
           <Card className="mb-8">
          <CardHeader>
            <CardTitle className="text-xl text-purple-700">Teacher Performance Metrics</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div className="bg-blue-100 p-4 rounded-lg">
                <h3 className="font-semibold mb-2">Student Satisfaction</h3>
                <div className="text-3xl font-bold text-blue-700">92%</div>
                <p className="text-sm text-gray-600">Based on recent surveys</p>
              </div>
              <div className="bg-green-100 p-4 rounded-lg">
                <h3 className="font-semibold mb-2">Class Engagement</h3>
                <div className="text-3xl font-bold text-green-700">88%</div>
                <p className="text-sm text-gray-600">Average participation rate</p>
              </div>
              <div className="bg-yellow-100 p-4 rounded-lg">
                <h3 className="font-semibold mb-2">Lesson Plan Completion</h3>
                <div className="text-3xl font-bold text-yellow-700">95%</div>
                <p className="text-sm text-gray-600">On track with curriculum</p>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Recent Chats with Parents */}
        <Card className="mb-8">
          <CardHeader>
            <CardTitle className="text-xl text-purple-700">Recent Chats with Parents</CardTitle>
          </CardHeader>
          <CardContent>
            <ul className="space-y-2">
              {recentChats.map((chat) => (
                <li key={chat.id} className="border-b pb-2">
                  <span className="font-semibold">{chat.parent}</span> - {chat.student}
                  <p className="text-sm text-gray-600">{chat.lastMessage}</p>
                </li>
              ))}
            </ul>
            <Button className="mt-4 bg-purple-600 hover:bg-purple-700">Open Chat</Button>
          </CardContent>
        </Card>

        {/* New Announcement Section */}
        <Card className="mb-8">
          <CardHeader>
            <CardTitle className="text-xl text-purple-700">New Announcement</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              <Select>
                <SelectTrigger className="w-full">
                  <SelectValue placeholder="Select class" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All Classes</SelectItem>
                  <SelectItem value="math101">Mathematics 101</SelectItem>
                  <SelectItem value="advAlgebra">Advanced Algebra</SelectItem>
                  <SelectItem value="geometry">Geometry Basics</SelectItem>
                </SelectContent>
              </Select>
              <Select>
                <SelectTrigger className="w-full">
                  <SelectValue placeholder="Select recipient" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All</SelectItem>
                  <SelectItem value="students">Students</SelectItem>
                  <SelectItem value="parents">Parents</SelectItem>
                </SelectContent>
              </Select>
              <Button className="w-full bg-purple-600 hover:bg-purple-700">Create Announcement</Button>
            </div>
          </CardContent>
        </Card>

        {/* Attendance Trends */}
        <Card className="mb-8">
          <CardHeader>
            <CardTitle className="text-xl text-purple-700">Attendance Trends</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="h-[300px]">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={attendanceData}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="month" />
                  <YAxis />
                  <Tooltip />
                  <Legend />
                  <Line type="monotone" dataKey="Mathematics" stroke="#8884d8" />
                  <Line type="monotone" dataKey="Algebra" stroke="#82ca9d" />
                  <Line type="monotone" dataKey="Geometry" stroke="#ffc658" />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </CardContent>
        </Card>

        {/* Enhanced Grade Distribution */}
        <Card className="mb-8">
          <CardHeader>
            <CardTitle className="text-xl text-purple-700">Grade Distribution</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div className="h-[300px]">
                <ResponsiveContainer width="100%" height="100%">
                  <PieChart>
                    <Pie
                      data={gradeDistribution}
                      cx="50%"
                      cy="50%"
                      labelLine={false}
                      outerRadius={80}
                      fill="#8884d8"
                      dataKey="value"
                      label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
                    >
                      {gradeDistribution.map((entry, index) => (
                        <Cell key={`cell-${index}`} fill={entry.color} />
                      ))}
                    </Pie>
                    <Tooltip />
                    <Legend />
                  </PieChart>
                </ResponsiveContainer>
              </div>
              <div>
                <h3 className="text-lg font-semibold mb-4">Grade Breakdown</h3>
                <ul className="space-y-2">
                  {gradeDistribution.map((grade) => (
                    <li key={grade.name} className="flex items-center">
                      <div className="w-4 h-4 rounded-full mr-2" style={{ backgroundColor: grade.color }}></div>
                      <span className="font-medium">{grade.name}:</span>
                      <span className="ml-2">{grade.value} students</span>
                      <span className="ml-2 text-gray-500">
                        ({((grade.value / gradeDistribution.reduce((acc, curr) => acc + curr.value, 0)) * 100).toFixed(1)}%)
                      </span>
                    </li>
                  ))}
                </ul>
                <div className="mt-4">
                  <h4 className="font-semibold">Class Average: B-</h4>
                  <p className="text-sm text-gray-600">Overall performance is good, but there's room for improvement in the lower grades.</p>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>

     
      </div>

      {/* Community Chat Toggle Button */}
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
    </div>
  )
}

