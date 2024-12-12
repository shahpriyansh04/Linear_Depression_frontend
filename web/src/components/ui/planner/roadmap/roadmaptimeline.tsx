"use client";
// import React from 'react'
// import { CheckCircle, Circle } from 'lucide-react'

// export default function RoadmapTimeline({ chapters, subject }) {
//   return (
//     <div className="space-y-6">
//       {chapters.map((chapter, index) => (
//         <div key={index} className="flex items-start">
//           <div className="flex items-center h-10 w-10">
//             {chapter.completed ? (
//               <CheckCircle className="h-6 w-6 text-green-500" />
//             ) : (
//               <Circle className="h-6 w-6 text-gray-300" />
//             )}
//             {index < chapters.length - 1 && (
//               <div className="h-full w-0.5 bg-gray-200 ml-3" />
//             )}
//           </div>
//           <div className="ml-4 -mt-1">
//             <h3 className="text-lg font-semibold text-gray-900">{chapter.name}</h3>
//             <p className="text-sm text-gray-500">Week {chapter.week}</p>
//           </div>
//         </div>
//       ))}
//     </div>
//   )
// }

import React, { useState } from "react";
import { motion } from "framer-motion";
import { CheckCircle2, Circle, Download } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";

export default function RoadmapTimeline({
  chapters: initialChapters,
  subject,
}) {
  const [chapters, setChapters] = useState(initialChapters);

  const toggleCompletion = (index) => {
    const updatedChapters = chapters.map((chapter, i) =>
      i === index ? { ...chapter, completed: !chapter.completed } : chapter
    );
    setChapters(updatedChapters);
  };

  const completedPercentage =
    (chapters.filter((c) => c.completed).length / chapters.length) * 100;

  const downloadRoadmap = () => {
    const roadmapData = {
      subject,
      chapters: chapters.map(({ name, week, completed }) => ({
        name,
        week,
        completed,
      })),
    };
    const blob = new Blob([JSON.stringify(roadmapData, null, 2)], {
      type: "application/json",
    });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `${subject.toLowerCase().replace(" ", "_")}_roadmap.json`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  };

  return (
    <div className="relative  bg-white">
      <div className="flex justify-between items-center mb-4">
        <h2 className="text-2xl font-bold text-indigo-700">
          {subject} Roadmap
        </h2>
        <Button
          variant="outline"
          className="bg-yellow-200 hover:bg-yellow-300 text-indigo-700 rounded-full shadow-md"
        >
          <Download className="w-5 h-5 mr-2" />
          Download Roadmap
        </Button>
      </div>
      <Progress
        value={completedPercentage}
        className="mb-4 bg-indigo-200"
        indicatorClassName="bg-indigo-600"
      />
      <p className="text-sm text-gray-500 mb-6">
        {completedPercentage.toFixed(0)}% Completed
      </p>
      {chapters.map((chapter, index) => (
        <motion.div
          key={index}
          className="mb-8 flex items-center"
          initial={{ opacity: 0, x: -50 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.5, delay: index * 0.1 }}
        >
          {/* <div className="flex items-center justify-center w-10 h-10 rounded-full border-2 border-purple-500 bg-white"> */}
          {chapter.completed ? (
            <div className="flex items-center justify-center w-10 h-10 rounded-full border-2 border-purple-500 bg-green-400">
              <CheckCircle2 className="w-6 h-6 text-indigo-500" />
            </div>
          ) : (
            <div className="flex items-center justify-center w-10 h-10 rounded-full border-2 border-purple-500 bg-white">
              <Circle className="w-6 h-6 text-indigo-400" />
            </div>
          )}

          <div className="ml-4 flex-grow">
            <h3 className="text-lg font-semibold text-gray-800">
              {chapter.name}
            </h3>
            <p className="text-sm text-gray-500">Week {chapter.week}</p>
          </div>
          <Button
            className={`px-4 py-2 rounded-full text-sm font-medium ${
              chapter.completed
                ? "bg-green-100 text-green-700 hover:bg-green-200"
                : "bg-indigo-100 text-indigo-700 hover:bg-indigo-200"
            }`}
            onClick={() => toggleCompletion(index)}
          >
            {chapter.completed ? "Completed" : "Mark as Complete"}
          </Button>
        </motion.div>
      ))}
      <div className="absolute left-5  top-[150px] h-[60%] w-0.5 bg-indigo-200" />
    </div>
  );
}
