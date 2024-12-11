"use client";
import React, { useState } from "react";
import { cn } from "@/lib/utils";
import { useSession } from "next-auth/react";
import Link from "next/link";
import { Menu } from "@/app/dashboard/student/(components)/NavbarMenu";
import { logout } from "@/app/auth/action";

export function NavbarCode({ className }: { className?: string }) {
  const { data: session } = useSession();
  const [active, setActive] = useState<string | null>(null);
  return (
    <div
      className={cn("fixed top-10 inset-x-0 max-w-2xl mx-auto z-50", className)}
    >
      <Menu setActive={setActive}>
        <Link href="/dashboard/student">
          <p>UDAAN</p>
        </Link>
        <div className="flex space-x-6">
          <Link href="/code">
            <p>Code</p>
          </Link>
          <Link href="/dashboard/student/live">
            <p>Live Classes</p>
          </Link>
          <Link href="/dashboard/student/wellbeing/therapybot/">
            <p>Wellbeing</p>
          </Link>
        </div>
        {session === undefined ? (
          <p>Loading...</p>
        ) : (
          <p onClick={async () => await logout()}> {session?.user?.name}</p>
        )}
      </Menu>
    </div>
  );
}
