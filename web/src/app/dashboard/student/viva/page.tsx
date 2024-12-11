'use client'

import React, { useState, useEffect, useRef } from 'react'
import { DotLottieReact } from '@lottiefiles/dotlottie-react'
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Mic, Send } from 'lucide-react'

export default function VoiceChat() {
  const [isRecording, setIsRecording] = useState(false)
  const [transcript, setTranscript] = useState('')
  const [messages, setMessages] = useState<{ text: string; isUser: boolean }[]>([])
  const [audioURL, setAudioURL] = useState<string | null>(null)
  const [dotLottie, setDotLottie] = useState<any>(null)
  const mediaRecorderRef = useRef<MediaRecorder | null>(null)
  const audioChunksRef = useRef<Blob[]>([])
  const recognitionRef = useRef<any>(null)

  useEffect(() => {
    if (!('webkitSpeechRecognition' in window)) {
      console.error('Speech recognition not available')
      return
    }

    recognitionRef.current = new (window as any).webkitSpeechRecognition()
    recognitionRef.current.continuous = true
    recognitionRef.current.interimResults = true

    recognitionRef.current.onresult = (event: any) => {
      let finalTranscript = ''
      for (let i = event.resultIndex; i < event.results.length; i++) {
        const transcript = event.results[i][0].transcript
        if (event.results[i].isFinal) {
          finalTranscript += transcript + ' '
        }
      }
      if (finalTranscript) {
        setTranscript(finalTranscript)
      }
    }

    return () => {
      if (recognitionRef.current) {
        recognitionRef.current.stop()
      }
    }
  }, [])

  const dotLottieRefCallback = (dotLottieInstance: any) => {
    setDotLottie(dotLottieInstance)
  }

  const startRecording = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true })
      const mediaRecorder = new MediaRecorder(stream)
      mediaRecorderRef.current = mediaRecorder
      audioChunksRef.current = []

      mediaRecorder.ondataavailable = (event) => {
        audioChunksRef.current.push(event.data)
      }

      mediaRecorder.onstop = () => {
        const audioBlob = new Blob(audioChunksRef.current, { type: 'audio/webm' })
        const url = URL.createObjectURL(audioBlob)
        setAudioURL(url)
      }

      mediaRecorder.start()
      recognitionRef.current?.start()
      setIsRecording(true)
      if (dotLottie) {
        dotLottie.play()
      }
    } catch (error) {
      console.error('Error starting recording:', error)
    }
  }

  const stopRecording = () => {
    mediaRecorderRef.current?.stop()
    recognitionRef.current?.stop()
    setIsRecording(false)
    if (dotLottie) {
      dotLottie.stop()
    }
  }

  const handleSend = () => {
    if (transcript.trim()) {
      setMessages(prev => [...prev, { text: transcript, isUser: true }])
      setTranscript('')
      setAudioURL(null)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-white via-purple-100 to-purple-300 flex items-center justify-center p-4">
      <div className="w-full max-w-7xl  flex items-start">
        <div className="w-1/2 flex items-center justify-center">
          <DotLottieReact
            src="https://lottie.host/197276e4-1363-4fed-8856-b8ed365d2e25/OD78mJPdGx.lottie"
            autoplay={false}
            loop
            dotLottieRefCallback={dotLottieRefCallback}
            className="w-[60vw] h-[500px] opacity-60"
          />
        </div>

        <div className="w-1/2 pl-8">
        <div className="h-[500px] mb-4 space-y-4 pr-8 overflow-y-auto">
    {messages.map((message, index) => (
      <div
        key={index}
        className={`p-3 rounded-lg h-auto max-w-[50%] ${
          message.isUser ? 'ml-auto bg-white' : 'bg-white'
        } shadow-md break-words`}
      >
        {message.text}
      </div>
    ))}
  </div>

          <div className="flex gap-2">
            <Button
              onClick={isRecording ? stopRecording : startRecording}
              variant={isRecording ? "destructive" : "secondary"}
              size="icon"
              className="rounded-full shadow-md"
            >
              <Mic className="h-4 w-4" />
            </Button>

            <Input
              value={transcript}
              onChange={(e) => setTranscript(e.target.value)}
              placeholder="Your message..."
              className="rounded-full bg-white shadow-md border-purple-200 focus:border-purple-300 focus:ring-purple-300"
            />

            <Button
              onClick={handleSend}
              size="icon"
              className="rounded-full shadow-md bg-purple-500 hover:bg-purple-600 text-white"
              disabled={!transcript.trim()}
            >
              <Send className="h-4 w-4" />
            </Button>
          </div>

          {audioURL && (
            <audio controls src={audioURL} className="mt-4 w-full">
              Your browser does not support the audio element.
            </audio>
          )}
        </div>
      </div>
    </div>
  )
}

