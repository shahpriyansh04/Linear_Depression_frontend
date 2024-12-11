"use client";
import React from "react";
import { usePathname } from "next/navigation";
import { AnimatePresence } from "framer-motion";
import { NavbarCode } from "./(components)/Navbar";
import { SessionProvider } from "next-auth/react";

export default function Layout({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  const showNavbar = pathname !== "/dashboard/code";

  return (
    <AnimatePresence mode="wait">
      <SessionProvider>
        <div className="h-screen flex flex-col bg-[#020817] relative">
          {showNavbar && <NavbarCode />}
          <div className="mt-24">{children}</div>
          {/* <Transition /> */}
        </div>
      </SessionProvider>
    </AnimatePresence>
  );
}
