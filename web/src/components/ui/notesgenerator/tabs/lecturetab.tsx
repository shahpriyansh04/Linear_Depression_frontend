"use client";

import React, { useState } from "react";

export const LectureTab = () => {
  const [notes, setNotes] = useState("");

  const handleInputChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    setNotes(e.target.value);
  };

  return (
    <div>
      <h2 className="text-lg font-semibold mb-2">Lecture Notes</h2>
      <textarea
        placeholder="Enter lecture notes here"
        value={notes}
        onChange={handleInputChange}
        className="block w-full p-2 border rounded h-32"
      />
      {notes && <p className="mt-2">Notes: {notes}</p>}
    </div>
  );
};
