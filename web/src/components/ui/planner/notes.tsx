import React, { useState } from "react";

export function NotesCard({
  title,
  children,
}: {
  title?: string;
  children?: React.ReactNode;
}) {
  return (
    <div className="h-64  rounded-3xl border bg-[#fced99] p-4 font-sans text-zinc-950 shadow-sm">
      <div className="text-lg font-bold tracking-wide">{title}</div>
      <div className="mt-3 flex flex-col gap-3 text-sm">{children}</div>
    </div>
  );
}

export default function Notes() {
  const [notes, setNotes] = useState<string[]>([]);
  const [input, setInput] = useState<string>("");

  const handleAddNote = () => {
    if (input.trim()) {
      setNotes([...notes, input]);
      setInput("");
    }
  };

  return (
    <div>
      <NotesCard title="Study Notes">
        {notes.map((note, index) => (
          <div key={index}>{note}</div>
        ))}
      </NotesCard>
      <div className="mt-4">
        <input
          type="text"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          className="border rounded p-2"
          placeholder="Add a new note"
        />
        <button
          onClick={handleAddNote}
          className="ml-2 p-2 bg-green-500 rounded-md text-white border-spacing-2"
        >
          Add Note
        </button>
      </div>
    </div>
  );
}
