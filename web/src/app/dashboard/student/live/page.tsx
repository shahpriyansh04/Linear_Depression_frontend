"use client";
import {
  InputOTP,
  InputOTPGroup,
  InputOTPSeparator,
  InputOTPSlot,
} from "@/components/ui/input-otp";
import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import Link from "next/link";
import { headers } from "next/headers";
import axios from "axios";
import { getLectures } from "./action";
//@ts-ignore

export default function Home() {
  const [value, setValue] = useState("");
  const [lectures, setLectures] = useState([]);
  const formattedValue =
    value.length === 10
      ? `${value.slice(0, 3)}-${value.slice(3, 7)}-${value.slice(7)}`
      : "";

  const getRecordedLectures = async () => {
    const lectures = await getLectures();
    setLectures(lectures);
  };

  useEffect(() => {
    getRecordedLectures();
  }, []);
  console.log(lectures);

  return (
    <div className="-mt-24 h-screen flex flex-col items-center justify-center">
      <p className="text-4xl font-semibold">Enter Room Code</p>
      <div className="my-12">
        <InputOTP
          maxLength={10}
          value={value}
          onChange={(value) => setValue(value)}
        >
          <InputOTPGroup>
            <InputOTPSlot index={0} />
            <InputOTPSlot index={1} />
            <InputOTPSlot index={2} />
          </InputOTPGroup>
          <InputOTPSeparator />
          <InputOTPGroup>
            <InputOTPSlot index={3} />
            <InputOTPSlot index={4} />
            <InputOTPSlot index={5} />
            <InputOTPSlot index={6} />
          </InputOTPGroup>
          <InputOTPSeparator />
          <InputOTPGroup>
            <InputOTPSlot index={7} />
            <InputOTPSlot index={8} />
            <InputOTPSlot index={9} />
          </InputOTPGroup>
        </InputOTP>
      </div>
      {formattedValue && (
        <Link href={`/dashboard/student/live/room?code=${formattedValue}`}>
          <Button size="lg" className="">
            Join Room
          </Button>
        </Link>
      )}

      <div className="grid grid-cols-2 gap-6">
        {lectures.map((lecture: any) => (
          <div className="mt-12 w-96 h-96">
            <video className="" controls src={lecture.url}></video>
          </div>
        ))}
      </div>
    </div>
  );
}
