import { BookOpen } from "lucide-react";
import { cn } from "@/lib/utils";

export default function WeeklyProgress() {
  const days = ["M", "T", "W", "TH", "F", "S", "SU"];
  return (
    <div className={cn("group w-[30vw] rounded-3xl bg-indigo-100 p-4")}>
      <div>
        <p className="text-sm font-semibold text-gray-500">Weekly Goal</p>
        <p className="text-lg font-bold text-black">Study Progress</p>
      </div>
      <div className="mt-1 inline-flex items-center justify-around gap-2 rounded-full border-2 border-indigo-300 px-2 py-1">
        <BookOpen size={20} fill="indigo" color="indigo" className="top-4" />
        <p className="text-sm font-bold text-black">30%</p>
      </div>
      <div className="mt-5 flex flex-wrap justify-center">
        {days.map((day, index) => (
          <svg
            key={index}
            width="5vw"
            height="10vh"
            viewBox="-25 -25 250 250"
            version="1.1"
            xmlns="http://www.w3.org/2000/svg"
            style={{ transform: "rotate(-90deg)" }}
          >
            <circle
              r="90"
              cx="100"
              cy="100"
              fill="transparent"
              stroke="#e0e0e0"
              strokeWidth="16px"
              strokeDasharray="565.48px"
              strokeDashoffset="0"
            ></circle>
            <circle
              r="90"
              cx="100"
              cy="100"
              stroke="#818cf8"
              strokeWidth="16px"
              strokeLinecap="round"
              fill="transparent"
              strokeDasharray="565.48px"
              strokeDashoffset="565.48px"
            >
              <animate
                attributeName="stroke-dashoffset"
                from="565.48"
                to="118.692"
                dur={0.5 + index * 0.1 + "s"}
                fill="freeze"
              />
            </circle>
            <text
              className="text-6xl font-bold"
              x="100px"
              y="105px"
              fill="black"
              dominantBaseline="middle"
              textAnchor="middle"
              style={{ transform: "rotate(90deg) translate(0px, -196px)" }}
            >
              <animate
                attributeName="opacity"
                from="0"
                to="1"
                dur={0.5 + index * 0.1 + "s"}
                fill="freeze"
              />
              {day}
            </text>
          </svg>
        ))}
      </div>
    </div>
  );
}
