import { auth } from "@/auth";
import React from "react";
import { redirect } from "next/navigation";

export default async function page() {
  const session = await auth();
  console.log(session?.user);

  if (session?.user?.role === "student") redirect("/dashboard/student");
  if (session?.user?.role === "teacher") redirect("/dashboard/teacher");
  if (session?.user?.role === "parent") redirect("/dashboard/parent");
}
