"use client";
import { HMSPrebuilt } from "@100mslive/roomkit-react";
import { useRouter, useSearchParams } from "next/navigation";
import { useEffect, useState } from "react";

export default function Code() {
  const router = useRouter();
  const searchParams = useSearchParams();

  if (searchParams && searchParams.get("code") === null) {
    router.push("/dashboard");
  }

  return (
    <div className="-mt-24 h-screen flex flex-col items-center justify-center">
      <HMSPrebuilt
        roomCode={searchParams.get("code") as string}
        onLeave={() => {
          console.log("Leaving room");

          router.push("/dashboard/student/");
        }}
      />
    </div>
  );
}
