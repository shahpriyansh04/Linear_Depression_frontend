"use client";

import React, { useState } from "react";

export const YouTubeTab = () => {
  const [videoUrl, setVideoUrl] = useState("");

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setVideoUrl(e.target.value);
  };

  return (
    <div>
      <h2 className="text-lg font-semibold mb-2">YouTube Notes</h2>
      <input
        type="text"
        placeholder="Enter YouTube URL"
        value={videoUrl}
        onChange={handleInputChange}
        className="block w-full p-2 border rounded"
      />
      {videoUrl && <p className="mt-2">URL Entered: {videoUrl}</p>}
    </div>
  );
};
