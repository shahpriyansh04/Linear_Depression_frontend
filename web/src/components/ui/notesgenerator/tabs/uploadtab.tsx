"use client";

import React, { useState } from "react";

export const UploadTab = () => {
  const [file, setFile] = useState<File | null>(null);

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const uploadedFile = e.target.files?.[0] || null;
    setFile(uploadedFile);
  };

  return (
    <div>
      <h2 className="text-lg font-semibold mb-2">Upload Notes</h2>
      <input
        type="file"
        className="block w-full text-sm"
        onChange={handleFileChange}
      />
      {file && <p className="mt-2">Uploaded File: {file.name}</p>}
    </div>
  );
};
