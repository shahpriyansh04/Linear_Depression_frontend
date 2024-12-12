"use client";
import React from "react";
import { NavbarDashboard } from "./(components)/Navbar";
import { useSession } from "next-auth/react";
import { redirect } from "next/navigation";

export default function layout({ children }: { children: React.ReactNode }) {
  const { data: session } = useSession();

  if (session !== undefined && session?.user.role !== "student")
    redirect(`/dashboard/${session?.user?.role}`);

  return (
    <div className="h-screen flex flex-col bg-[#FAF5FF] relative">
      <NavbarDashboard />
      <div className="mt-24">{children}</div>
    </div>
  );
}
