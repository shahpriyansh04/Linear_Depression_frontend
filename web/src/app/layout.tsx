"use client";

// import { ChatProvider } from "@/hooks/useChat";
import "./globals.css";

import { AppProgressBar as ProgressBar } from "next-nprogress-bar";

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={` antialiased`}>
        {/* <ChatProvider> */}
        <ProgressBar
          height="4px"
          color="#000000"
          options={{ showSpinner: false }}
          shallowRouting
        />
        {/* <Navbar /> */}
        {children}
        {/* </ChatProvider> */}
      </body>
    </html>
  );
}
