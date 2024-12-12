"use client";

import React, { useState } from "react";
import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { useRouter } from "next/navigation";
import { TextGenerateEffect } from "@/components/ui/text-generate-effect";
import { Timeline } from "@/components/ui/planner/roadmap/timeline";
import { title } from "process";

export default function AddRoadmap() {
  const router = useRouter();
  const [subject, setSubject] = useState("");
  const [duration, setDuration] = useState("");
  const [roadmap, setRoadmap] = useState(null);

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log("Generating roadmap for:", subject, "Duration:", duration);
    const mockRoadmap = {
      subject,
      duration,
      weeks: [
        {
          week: 1,
          title: "foundation",
          content: (
            <h1>
              Lorem ipsum dolor sit amet consectetur adipisicing elit. Veniam
              ipsa adipisci ullam inventore obcaecati explicabo, aliquid odio
              distinctio quia, alias quae non tempore rerum recusandae nemo
              nobis voluptatum numquam vel voluptatem a expedita eum? Voluptatum
              recusandae quos consequatur eveniet, amet similique blanditiis.
              Dicta doloremque expedita, est iure esse error ratione earum
              eligendi quod provident. Sunt, architecto repellendus cum fuga
              suscipit quas unde sequi, accusantium voluptatem ullam, vero
              pariatur nostrum. Nemo quidem dolorum repellendus recusandae,
              nostrum saepe rem. Ipsam ipsa blanditiis voluptatum eius saepe
              impedit eum fugit, similique illo sunt et excepturi dolor quod,
              quas molestiae distinctio doloribus, cumque quaerat est?
            </h1>
          ),
        },
        {
          week: 2,
          title: "intermediate",
          content: (
            <h1>
              Lorem ipsum dolor sit amet consectetur adipisicing elit. Veniam
              ipsa adipisci ullam inventore obcaecati explicabo, aliquid odio
              distinctio quia, alias quae non tempore rerum recusandae nemo
              nobis voluptatum numquam vel voluptatem a expedita eum? Voluptatum
              recusandae quos consequatur eveniet, amet similique blanditiis.
              Dicta doloremque expedita, est iure esse error ratione earum
              eligendi quod provident. Sunt, architecto repellendus cum fuga
              suscipit quas unde sequi, accusantium voluptatem ullam, vero
              pariatur nostrum. Nemo quidem dolorum repellendus recusandae,
              nostrum saepe rem. Ipsam ipsa blanditiis voluptatum eius saepe
              impedit eum fugit, similique illo sunt et excepturi dolor quod,
              quas molestiae distinctio doloribus, cumque quaerat est?
            </h1>
          ),
        },
        {
          week: 3,
          title: "Advanced Topics",
          content: (
            <h1>
              Lorem ipsum dolor sit amet consectetur adipisicing elit. Veniam
              ipsa adipisci ullam inventore obcaecati explicabo, aliquid odio
              distinctio quia, alias quae non tempore rerum recusandae nemo
              nobis voluptatum numquam vel voluptatem a expedita eum? Voluptatum
              recusandae quos consequatur eveniet, amet similique blanditiis.
              Dicta doloremque expedita, est iure esse error ratione earum
              eligendi quod provident. Sunt, architecto repellendus cum fuga
              suscipit quas unde sequi, accusantium voluptatem ullam, vero
              pariatur nostrum. Nemo quidem dolorum repellendus recusandae,
              nostrum saepe rem. Ipsam ipsa blanditiis voluptatum eius saepe
              impedit eum fugit, similique illo sunt et excepturi dolor quod,
              quas molestiae distinctio doloribus, cumque quaerat est?
            </h1>
          ),
        },
        {
          week: 4,
          title: "Practical Application",
          content: (
            <h1>
              Lorem ipsum dolor sit amet consectetur adipisicing elit. Veniam
              ipsa adipisci ullam inventore obcaecati explicabo, aliquid odio
              distinctio quia, alias quae non tempore rerum recusandae nemo
              nobis voluptatum numquam vel voluptatem a expedita eum? Voluptatum
              recusandae quos consequatur eveniet, amet similique blanditiis.
              Dicta doloremque expedita, est iure esse error ratione earum
              eligendi quod provident. Sunt, architecto repellendus cum fuga
              suscipit quas unde sequi, accusantium voluptatem ullam, vero
              pariatur nostrum. Nemo quidem dolorum repellendus recusandae,
              nostrum saepe rem. Ipsam ipsa blanditiis voluptatum eius saepe
              impedit eum fugit, similique illo sunt et excepturi dolor quod,
              quas molestiae distinctio doloribus, cumque quaerat est?
            </h1>
          ),
        },
        {
          week: 5,
          title: "Specialization",
          content: (
            <h1>
              Lorem ipsum dolor sit amet consectetur adipisicing elit. Veniam
              ipsa adipisci ullam inventore obcaecati explicabo, aliquid odio
              distinctio quia, alias quae non tempore rerum recusandae nemo
              nobis voluptatum numquam vel voluptatem a expedita eum? Voluptatum
              recusandae quos consequatur eveniet, amet similique blanditiis.
              Dicta doloremque expedita, est iure esse error ratione earum
              eligendi quod provident. Sunt, architecto repellendus cum fuga
              suscipit quas unde sequi, accusantium voluptatem ullam, vero
              pariatur nostrum. Nemo quidem dolorum repellendus recusandae,
              nostrum saepe rem. Ipsam ipsa blanditiis voluptatum eius saepe
              impedit eum fugit, similique illo sunt et excepturi dolor quod,
              quas molestiae distinctio doloribus, cumque quaerat est?
            </h1>
          ),
        },
        {
          week: 6,
          title: "Integration",
          content: (
            <h1>
              Lorem ipsum dolor sit amet consectetur adipisicing elit. Veniam
              ipsa adipisci ullam inventore obcaecati explicabo, aliquid odio
              distinctio quia, alias quae non tempore rerum recusandae nemo
              nobis voluptatum numquam vel voluptatem a expedita eum? Voluptatum
              recusandae quos consequatur eveniet, amet similique blanditiis.
              Dicta doloremque expedita, est iure esse error ratione earum
              eligendi quod provident. Sunt, architecto repellendus cum fuga
              suscipit quas unde sequi, accusantium voluptatem ullam, vero
              pariatur nostrum. Nemo quidem dolorum repellendus recusandae,
              nostrum saepe rem. Ipsam ipsa blanditiis voluptatum eius saepe
              impedit eum fugit, similique illo sunt et excepturi dolor quod,
              quas molestiae distinctio doloribus, cumque quaerat est?
            </h1>
          ),
        },
        {
          week: 7,
          title: "Research and Innovation",
          content: (
            <h1>
              Lorem ipsum dolor sit amet consectetur adipisicing elit. Veniam
              ipsa adipisci ullam inventore obcaecati explicabo, aliquid odio
              distinctio quia, alias quae non tempore rerum recusandae nemo
              nobis voluptatum numquam vel voluptatem a expedita eum? Voluptatum
              recusandae quos consequatur eveniet, amet similique blanditiis.
              Dicta doloremque expedita, est iure esse error ratione earum
              eligendi quod provident. Sunt, architecto repellendus cum fuga
              suscipit quas unde sequi, accusantium voluptatem ullam, vero
              pariatur nostrum. Nemo quidem dolorum repellendus recusandae,
              nostrum saepe rem. Ipsam ipsa blanditiis voluptatum eius saepe
              impedit eum fugit, similique illo sunt et excepturi dolor quod,
              quas molestiae distinctio doloribus, cumque quaerat est?
            </h1>
          ),
        },
        {
          week: 8,
          title: "Mastery and Reflection",
          content: (
            <h1>
              Lorem ipsum dolor sit amet consectetur adipisicing elit. Veniam
              ipsa adipisci ullam inventore obcaecati explicabo, aliquid odio
              distinctio quia, alias quae non tempore rerum recusandae nemo
              nobis voluptatum numquam vel voluptatem a expedita eum? Voluptatum
              recusandae quos consequatur eveniet, amet similique blanditiis.
              Dicta doloremque expedita, est iure esse error ratione earum
              eligendi quod provident. Sunt, architecto repellendus cum fuga
              suscipit quas unde sequi, accusantium voluptatem ullam, vero
              pariatur nostrum. Nemo quidem dolorum repellendus recusandae,
              nostrum saepe rem. Ipsam ipsa blanditiis voluptatum eius saepe
              impedit eum fugit, similique illo sunt et excepturi dolor quod,
              quas molestiae distinctio doloribus, cumque quaerat est?
            </h1>
          ),
        },
      ].slice(0, parseInt(duration) * 2), // Adjust based on selected duration
    };
    setRoadmap(mockRoadmap);
  };

  const handleSave = () => {
    console.log("Saving roadmap:", roadmap);
    router.push("/");
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
            Create Your Learning Roadmap
          </CardTitle>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-6">
            <div className="grid gap-6 md:grid-cols-2">
              <div className="space-y-2">
                <Label
                  htmlFor="subject"
                  className="text-lg font-semibold text-indigo-600"
                >
                  Subject
                </Label>
                <Input
                  id="subject"
                  value={subject}
                  onChange={(e) => setSubject(e.target.value)}
                  placeholder="Enter subject name"
                  className="rounded-full border-indigo-300 focus:border-indigo-500 focus:ring-indigo-500"
                />
              </div>
              <div className="space-y-2">
                <Label
                  htmlFor="duration"
                  className="text-lg font-semibold text-indigo-600"
                >
                  Duration (in months)
                </Label>
                <Select onValueChange={setDuration}>
                  <SelectTrigger className="rounded-full border-indigo-300 focus:border-indigo-500 focus:ring-indigo-500">
                    <SelectValue placeholder="Select duration" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="1">1 month</SelectItem>
                    <SelectItem value="2">2 months</SelectItem>
                    <SelectItem value="3">3 months</SelectItem>
                    <SelectItem value="4">4 months</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>
            <div className="flex justify-center">
              <Button
                type="submit"
                className="bg-indigo-600 hover:bg-indigo-700 text-white rounded-full shadow-md px-8 py-2 text-lg"
              >
                Generate Roadmap
              </Button>
            </div>
          </form>

          {roadmap && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5 }}
              className="mt-12 space-y-6"
            >
              <TextGenerateEffect
                words={`${roadmap.subject} Learning Roadmap - ${roadmap.duration} month(s)`}
                className="text-2xl font-bold text-center text-indigo-700"
              />
              <Timeline
                data={roadmap.weeks.map((week, index) => ({
                  week: `Week ${week.week}`,
                  title: week.title,
                  content: (
                    <div>
                      <p className="text-neutral-800 dark:text-neutral-200 text-xs md:text-sm font-normal mb-4">
                        {week.content}
                      </p>
                    </div>
                  ),
                }))}
              />
              <div className="flex justify-center mt-8">
                <Button
                  onClick={handleSave}
                  className="bg-green-500 hover:bg-green-600 text-white rounded-full shadow-md px-8 py-2 text-lg"
                >
                  Save Roadmap
                </Button>
              </div>
            </motion.div>
          )}
        </CardContent>
      </Card>
    </motion.div>
  );
}
