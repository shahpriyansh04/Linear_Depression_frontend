"use client";
import { logout } from "@/app/auth/action";
import React from "react";

export default function Student() {
  return <button onClick={async () => logout()}>Button</button>;
}
