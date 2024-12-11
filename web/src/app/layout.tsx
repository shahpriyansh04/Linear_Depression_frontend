"use client";
import { SessionProvider } from "next-auth/react";
import "./globals.css";
import { ChatProvider } from "./hooks/useChat";

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">
        <SessionProvider>
          <ChatProvider>{children}</ChatProvider>
          </SessionProvider>
      </body>
    </html>
  );
}
