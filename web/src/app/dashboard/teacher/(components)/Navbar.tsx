"use client";
import React, { useState } from "react";
import { HoveredLink, Menu, MenuItem, ProductItem } from "./NavbarMenu";
import { cn } from "@/lib/utils";
import { useSession } from "next-auth/react";
import Link from "next/link";
import { logout } from "@/app/auth/action";
import { useRouter } from "next/router";
import Router from "next/router";

export function NavbarDashboard({ className }: { className?: string }) {
  const { data: session } = useSession();
  const [active, setActive] = useState<string | null>(null);
  console.log(session?.user);
  
  const handleLogout = () => {
    logout();
    Router.push("/auth/login");
  }
  return (
    <div
      className={cn("fixed top-10 inset-x-0 max-w-2xl mx-auto z-50", className)}
    >
      <Menu setActive={setActive}>
        <Link href="/dashboard/student">
          <p>UDAAN</p>
        </Link>
        <div className="flex space-x-6">
          <Link href="/dashboard/student/live">
            <p>Live Classes</p>
          </Link>
          <Link href="/dashboard/student/wellbeing">
            <p>Student details</p>
          </Link>
          <Link href="/dashboard/student/wellbeing" onClick={handleLogout}>
            <p>Logout</p>
          </Link>
          {/* <MenuItem setActive={setActive} active={active} item="Financial Aid">
            <div className="flex flex-col space-y-4 text-sm">
              <HoveredLink href="/dashboard/student/financial-aid/jobs">
                upload resources
              </HoveredLink>
              <HoveredLink href="/dashboard/student/financial-aid/scholarships">
                Scholarships
              </HoveredLink>
            </div>
          </MenuItem> */}
          {/* <MenuItem setActive={setActive} active={active} item="AI Tools">
            <div className="flex flex-col space-y-4 text-sm">
              <HoveredLink href="/dashboard/student/viva">Viva</HoveredLink>
              <HoveredLink href="/dashboard/student/viva">Quizes</HoveredLink>
              <HoveredLink href="/dashboard/student/planner">
                Planner
              </HoveredLink>
              <HoveredLink href="/dashboard/student/notesgenerator">
                Notes Generator
              </HoveredLink>
            </div>
          </MenuItem> */}
        </div>
        {session === undefined ? (
          <p>Loading...</p>
        ) : (
          <p onClick={logout}> {session?.user?.name}</p>
        )}
      </Menu>
    </div>
  );
}
