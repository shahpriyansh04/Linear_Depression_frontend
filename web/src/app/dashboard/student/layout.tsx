import React from "react";
import { NavbarDashboard } from "./(components)/Navbar";

export default function layout({ children }: { children: React.ReactNode }) {
  return (
    <div className="h-screen flex flex-col bg-[#FAF5FF] relative">
      <NavbarDashboard />
      <div className="mt-24">{children}</div>
    </div>
  );
}
