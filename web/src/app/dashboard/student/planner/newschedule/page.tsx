"use client";

import React, { useState } from "react";
import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Slider } from "@/components/ui/slider";
import { useRouter } from "next/navigation";
import { Plus, Minus } from "lucide-react";

export default function AddSchedule() {
  const router = useRouter();
  const [subjects, setSubjects] = useState([{ name: "", difficulty: 5 }]);
  const [generatedSchedule, setGeneratedSchedule] = useState(null);

  const handleAddSubject = () => {
    setSubjects([...subjects, { name: "", difficulty: 5 }]);
  };

  const handleRemoveSubject = (index) => {
    const newSubjects = subjects.filter((_, i) => i !== index);
    setSubjects(newSubjects);
  };

  const handleSubjectChange = (index, field, value) => {
    const newSubjects = [...subjects];
    newSubjects[index][field] = value;
    setSubjects(newSubjects);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    // Here you would typically send the data to your backend
    console.log("Generating schedule with:", subjects);

    // Generate a dummy schedule
    const dummySchedule = [
      {
        time: "08:00 AM - 09:30 AM",
        subject: subjects[0]?.name || "Study Session 1",
      },
      {
        time: "09:45 AM - 11:15 AM",
        subject: subjects[1]?.name || "Study Session 2",
      },
      {
        time: "11:30 AM - 01:00 PM",
        subject: subjects[2]?.name || "Study Session 3",
      },
      { time: "01:00 PM - 02:00 PM", subject: "Lunch Break" },
      {
        time: "02:00 PM - 03:30 PM",
        subject: subjects[3]?.name || "Study Session 4",
      },
      {
        time: "03:45 PM - 05:15 PM",
        subject: subjects[4]?.name || "Study Session 5",
      },
      {
        time: "05:30 PM - 07:00 PM",
        subject: subjects[5]?.name || "Study Session 6",
      },
    ];
    setGeneratedSchedule(dummySchedule);
  };

  return (
    <motion.div
      className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-100 p-8"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ duration: 0.5 }}
    >
      <Card className="max-w-4xl mx-auto bg-white/90 backdrop-blur-sm shadow-xl rounded-xl">
        <CardHeader>
          <CardTitle className="text-3xl font-bold text-center text-indigo-700">
            Create Your Study Schedule
          </CardTitle>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-6">
            <div className="grid gap-6 md:grid-cols-2">
              {subjects.map((subject, index) => (
                <Card
                  key={index}
                  className="p-4 bg-blue-50 shadow-md rounded-xl"
                >
                  <div className="space-y-2">
                    <Label
                      htmlFor={`subject-${index}`}
                      className="text-lg font-semibold text-indigo-600"
                    >
                      Subject {index + 1}
                    </Label>
                    <Input
                      id={`subject-${index}`}
                      value={subject.name}
                      onChange={(e) =>
                        handleSubjectChange(index, "name", e.target.value)
                      }
                      placeholder="Enter subject name"
                      className="rounded-full border-indigo-300 focus:border-indigo-500 focus:ring-indigo-500"
                    />
                    <Label className="text-sm font-medium text-gray-600">
                      Difficulty (1-10)
                    </Label>
                    <div className="flex items-center space-x-2">
                      <Slider
                        min={1}
                        max={10}
                        step={1}
                        value={[subject.difficulty]}
                        onValueChange={(value) =>
                          handleSubjectChange(index, "difficulty", value[0])
                        }
                        className="flex-grow"
                      />
                      <span className="text-indigo-700 font-semibold">
                        {subject.difficulty}
                      </span>
                    </div>
                    {index > 0 && (
                      <Button
                        type="button"
                        onClick={() => handleRemoveSubject(index)}
                        variant="destructive"
                        size="icon"
                        className="mt-2 rounded-full"
                      >
                        <Minus className="h-4 w-4" />
                      </Button>
                    )}
                  </div>
                </Card>
              ))}
            </div>
            <div className="flex justify-center space-x-4">
              <Button
                type="button"
                onClick={handleAddSubject}
                variant="outline"
                className="bg-green-100 hover:bg-green-200 text-green-700 rounded-full shadow-md"
              >
                <Plus className="h-4 w-4 mr-2" /> Add Subject
              </Button>
              <Button
                type="submit"
                className="bg-indigo-600 hover:bg-indigo-700 text-white rounded-full shadow-md"
              >
                Generate Schedule
              </Button>
            </div>
          </form>

          {generatedSchedule && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5 }}
              className="mt-8"
            >
              <h3 className="text-2xl font-bold text-center text-indigo-700 mb-4">
                Your Generated Schedule
              </h3>
              <div className="bg-white rounded-xl shadow-lg overflow-hidden">
                <table className="w-full">
                  <thead className="bg-indigo-100">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-indigo-700 uppercase tracking-wider">
                        Time
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-indigo-700 uppercase tracking-wider">
                        Subject
                      </th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-indigo-200">
                    {generatedSchedule.map((slot, index) => (
                      <tr
                        key={index}
                        className={
                          index % 2 === 0 ? "bg-indigo-50" : "bg-white"
                        }
                      >
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                          {slot.time}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                          {slot.subject}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </motion.div>
          )}
        </CardContent>
      </Card>
    </motion.div>
  );
}
