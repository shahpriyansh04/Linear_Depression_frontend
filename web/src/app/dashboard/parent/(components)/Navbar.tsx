"use client";
import React, { useState } from "react";
import { HoveredLink, Menu, MenuItem, ProductItem } from "./NavbarMenu";
import { cn } from "@/lib/utils";
import { signOut, useSession } from "next-auth/react";
import {logout} from "@/app/auth/action";
import Link from "next/link";

export function NavbarDashboard({ className }: { className?: string }) {
  const { data: session } = useSession();
  const [active, setActive] = useState<string | null>(null);
  return (
    <div
      className={cn("fixed top-10 inset-x-0 max-w-2xl mx-auto z-50", className)}
    >
      <Menu setActive={setActive}>
        <Link href="/dashboard/parent">
          <p>UDAAN</p>
        </Link>
        <div className="flex space-x-6">
          <Link href="/dashboard/parent/progress">
            <p>Progress</p>
          </Link>
          <Link href="/dashboard/parent/community">
            <p>Community</p>
          </Link>
          <Link href="/dashboard/parent/communication">
            <p>Communication</p>
          </Link>
          <Link href="/auth/login" onClick={async () => await logout()}>
            <p>Logout</p>
          </Link>
          {/* <Link href="/dashboard/parent/resources">
            <p>Resources</p>
          </Link> */}
          
          {/* <MenuItem setActive={setActive} active={active} item="Financial Aid">
            <div className="flex flex-col space-y-4 text-sm">
              <HoveredLink href="/dashboard/parent/communication">
                shaba
              </HoveredLink>
              <HoveredLink href="/dashboard/student/financial-aid/scholarships">
                bale
              </HoveredLink>
            </div>
          </MenuItem>
          <MenuItem setActive={setActive} active={active} item="AI Tools">
            <div className="flex flex-col space-y-4 text-sm">
              <HoveredLink href="/dashboard/parent/viva">teachers</HoveredLink>
              <HoveredLink href="/dashboard/student/child-progress">childprog</HoveredLink>
              <HoveredLink href="/dashboard/student/planner">
               bale
              </HoveredLink>
              <HoveredLink href="/dashboard/student/notesgenerator">
              shaba
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
