"use client";

import React, { useState, useEffect } from "react";
import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Play, Pause, RotateCcw } from "lucide-react";
import { AnimatePresence } from "framer-motion";

export default function StudyTimer() {
  const [time, setTime] = useState(25 * 60); // 25 minutes in seconds
  const [isActive, setIsActive] = useState(false);
  const [inputMinutes, setInputMinutes] = useState(25);

  useEffect(() => {
    let interval = null;

    if (isActive && time > 0) {
      interval = setInterval(() => {
        setTime((time) => time - 1);
      }, 1000);
    } else if (time === 0) {
      setIsActive(false);
    }

    return () => clearInterval(interval);
  }, [isActive, time]);

  const toggleTimer = () => {
    setIsActive(!isActive);
  };

  const resetTimer = () => {
    setTime(inputMinutes * 60);
    setIsActive(false);
  };

  const handleInputChange = (e) => {
    const value = parseInt(e.target.value, 10);
    if (!isNaN(value) && value > 0) {
      setInputMinutes(value);
      setTime(value * 60);
    }
  };

  const formatTime = (seconds) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, "0")}:${secs
      .toString()
      .padStart(2, "0")}`;
  };

  return (
    <Card className="bg-indigo-50 shadow-inner">
      <CardContent className="pt-6">
        <motion.div
          className="text-6xl font-bold text-center text-indigo-700 mb-6"
          key={time}
          initial={{ scale: 0.8, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ type: "spring", stiffness: 300, damping: 20 }}
        >
          {formatTime(time)}
        </motion.div>
        <div className="flex justify-center space-x-4 mb-4">
          <Button
            onClick={toggleTimer}
            variant="outline"
            className="bg-indigo-100 hover:bg-indigo-200 text-indigo-700"
          >
            <AnimatePresence mode="wait" initial={false}>
              <motion.div
                key={isActive ? "pause" : "play"}
                initial={{ y: -20, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                exit={{ y: 20, opacity: 0 }}
                transition={{ duration: 0.2 }}
              >
                {isActive ? (
                  <Pause className="w-5 h-5" />
                ) : (
                  <Play className="w-5 h-5" />
                )}
              </motion.div>
            </AnimatePresence>
          </Button>
          <Button
            onClick={resetTimer}
            variant="outline"
            className="bg-indigo-100 hover:bg-indigo-200 text-indigo-700"
          >
            <RotateCcw className="w-5 h-5" />
          </Button>
        </div>
        <div className="flex items-center justify-center space-x-2">
          <Input
            type="number"
            value={inputMinutes}
            onChange={handleInputChange}
            className="w-20 text-center border-indigo-300 focus:border-indigo-500"
            min="1"
          />
          <span className="text-indigo-700">minutes</span>
        </div>
      </CardContent>
    </Card>
  );
}
