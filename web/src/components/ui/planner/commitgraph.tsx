import React from "react";
import { cn } from "@/lib/utils";

const getColor = (count: number): string => {
  const colors: { [key: number]: string } = {
    0: "bg-indigo-100",
    1: "bg-indigo-200",
    2: "bg-indigo-400",
  };
  return colors[count] ?? "bg-indigo-600";
};

function CommitGraph() {
  const commitsData = Array.from({ length: 53 }, () =>
    Array.from({ length: 7 }, () => Math.floor(Math.random() * 4))
  );

  return (
    <section>
      <div className="flex w-full flex-col items-center justify-center p-6">
        <div id="contributions" className="flex gap-1">
          {commitsData.map((week, i) => (
            <div
              key={`week-${i}`}
              id={`week-${i}`}
              className={cn(
                "flex flex-col gap-1",
                i < 20 ? "hidden md:flex" : "flex"
              )}
            >
              {week.map((commitCount, j) => (
                <div
                  key={`week-${i}-day-${j}`}
                  id={`week-${i}-day-${j}`}
                  className={cn(
                    "h-1 w-1 sm:h-2 sm:w-2 md:h-3 md:w-3 md:rounded-[2px] lg:h-4 lg:w-4",
                    getColor(commitCount)
                  )}
                />
              ))}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

export default CommitGraph;
