"use client";
import { Button } from "@/components/ui/button";
import { useSession } from "next-auth/react";
import React from "react";
import logout from "../auth/action";

export default function page() {
  const { data: session } = useSession();
  console.log(session?.user);

  return (
    <div>
      {session?.user.name + " " + session?.user.role}
      <Button>Logout</Button>
    </div>
  );
}
