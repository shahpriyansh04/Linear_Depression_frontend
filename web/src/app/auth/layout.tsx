import { auth } from "@/auth";
import { isRedirectError } from "next/dist/client/components/redirect";
import { redirect } from "next/navigation";
import React from "react";
export default async function layout({
  children,
}: {
  children: React.ReactNode;
}) {
  const session = await auth();
  try {
    if (session) return redirect("/dashboard");
  } catch (error) {
    if (isRedirectError(error)) {
      throw error;
    }
  }
  return <div>{children}</div>;
}
