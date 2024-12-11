"use client";
import React, { useState } from "react";
import { cn } from "@/lib/utils";
import { useSession } from "next-auth/react";
import Link from "next/link";
import { HoveredLink, Menu, MenuItem } from "./NavbarMenu";
import { logout } from "@/app/auth/action";

export function NavbarDashboard({ className }: { className?: string }) {
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
          <Link href="/dashboard/student/live">
            <p>Live Classes</p>
          </Link>
          <Link href="/dashboard/student/wellbeing/therapybot/">
            <p>Wellbeing</p>
          </Link>
          <MenuItem setActive={setActive} active={active} item="Financial Aid">
            <div className="flex flex-col space-y-4 text-sm">
              <HoveredLink href="/dashboard/student/financial-aid/jobs">
                Jobs
              </HoveredLink>
              <HoveredLink href="/dashboard/student/financial-aid/scholarships">
                Scholarships
              </HoveredLink>
            </div>
          </MenuItem>
          <MenuItem setActive={setActive} active={active} item="AI Tools">
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
          </MenuItem>
        </div>

        <p onClick={async () => await logout()}>Logout {session?.user?.name}</p>
      </Menu>
    </div>
  );
}
