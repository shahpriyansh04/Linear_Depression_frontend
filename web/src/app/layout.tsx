"use client";

import "./globals.css";
import { AppProgressBar as ProgressBar } from "next-nprogress-bar";
import { ChatProvider } from "./hooks/useChat";
import { SessionProvider } from "next-auth/react";

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">
        <SessionProvider>
          <ChatProvider>
            <ProgressBar
              height="4px"
              color="#000000"
              options={{ showSpinner: false }}
              shallowRouting
            />
            {children}
          </ChatProvider>
        </SessionProvider>
      </body>
    </html>
  );
}
