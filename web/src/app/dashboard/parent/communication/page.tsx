'use client'

import React, { useState, useEffect, useCallback, useRef } from 'react'
import axios from 'axios'
import { 
  Card, 
  CardContent, 
  CardHeader, 
  CardTitle,
} from '@/components/ui/card'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { ScrollArea } from '@/components/ui/scroll-area'
import { MessageCircle, Send } from 'lucide-react'
import { useSession } from 'next-auth/react'

interface Teacher {
  id: string;
  name: string;
  subject: string;
  lastMessage: string;
}

interface Message {
  _id: string;
  senderName: string | null;
  messageContent: string;
  image: string;
  receiverId: string;
  senderId: string;
  sentTime: string;
}

export default function ParentCommunication() {
  const [selectedTeacher, setSelectedTeacher] = useState<Teacher | null>(null)
  const [messages, setMessages] = useState<Message[]>([])
  const [newMessage, setNewMessage] = useState('')
  const { data: session } = useSession()
  const scrollAreaRef = useRef<HTMLDivElement>(null)

  // Predefined teachers list
  const teachers: Teacher[] = [
    { id: "1", name: "Mrs. Sharma", subject: "Mathematics", lastMessage: "2 hours ago" },
    { id: "2", name: "Mr. Patel", subject: "Science", lastMessage: "1 day ago" },
    { id: "3", name: "Ms. Gupta", subject: "English", lastMessage: "3 days ago" },
    { id: "4", name: "Mr. Singh", subject: "History", lastMessage: "1 week ago" },
  ]

  console.log(session?.user?.token +"here")
  const fetchMessages = useCallback(async (teacherId: string) => {
    if (!session?.user?.token) return;

    try {
      const response = await axios.get(`http://localhost:4000/get-my-chat/8/${teacherId}`, {
        headers: {
          Authorization: `Bearer ${session.user.token}`,
        }
      });

      if (response.data.success) {
        const fetchedMessages = response.data.data || [];
        setMessages(fetchedMessages);
        
        // Scroll to bottom after messages are fetched
        setTimeout(() => {
          if (scrollAreaRef.current) {
            scrollAreaRef.current.scrollTop = scrollAreaRef.current.scrollHeight;
          }
        }, 100);
      }
    } catch (error) {
      console.error("Error fetching messages:", error);
    }
  }, [session]);

  const selectTeacher = useCallback((teacher: Teacher) => {
    setSelectedTeacher(teacher);
    fetchMessages(teacher.id);
  }, [fetchMessages]);

  const sendMessage = async () => {
    if (!newMessage.trim() || !selectedTeacher || !session?.user) return;

    try {
      const response = await axios.post('http://localhost:4000/send-chat', {
        senderId: "8", // Parent's ID
        receiverId: selectedTeacher.id,
        messageContent: newMessage
      }, {
        headers: {
          Authorization: `Bearer ${session.user.token}`,
        }
      });
      
      await fetchMessages(selectedTeacher.id);
      setNewMessage('');
    } catch (error) {
      console.error("Error sending message:", error);
    }
  };

  const formatDate = (date: string) => {
    return new Date(date).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  };

  useEffect(() => {
    if (selectedTeacher) {
      const intervalId = setInterval(() => {
        fetchMessages(selectedTeacher.id);
      }, 3000);

      return () => clearInterval(intervalId);
    }
  }, [selectedTeacher, fetchMessages]);

  return (
    <div className="min-h-screen bg-purple-50 p-8">
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Teacher List */}
        <Card className="bg-white shadow-lg">
          <CardHeader>
            <CardTitle className="text-2xl font-bold text-gray-800 flex items-center">
              <MessageCircle className="mr-2" /> Teachers
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {teachers.map((teacher) => (
                <div 
                  key={teacher.id} 
                  className={`flex items-center space-x-4 p-3 rounded-lg cursor-pointer transition-colors ${
                    selectedTeacher?.id === teacher.id ? 'bg-blue-100' : 'hover:bg-gray-100'
                  }`}
                  onClick={() => selectTeacher(teacher)}
                >
                  <Avatar>
                    <AvatarImage src={`/placeholder.svg?height=40&width=40&text=${teacher.name.charAt(0)}`} />
                    <AvatarFallback>{teacher.name.charAt(0)}</AvatarFallback>
                  </Avatar>
                  <div className="flex-1">
                    <h4 className="font-semibold">{teacher.name}</h4>
                    <p className="text-sm text-gray-600">{teacher.subject}</p>
                  </div>
                  <Badge variant="outline">{teacher.lastMessage}</Badge>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Chat Area */}
        <Card className="lg:col-span-2 bg-white shadow-lg">
          <CardHeader>
            <CardTitle className="text-2xl font-bold text-gray-800 flex items-center">
              <MessageCircle className="mr-2" />
              {selectedTeacher ? `Chat with ${selectedTeacher.name}` : 'Select a teacher to start chatting'}
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ScrollArea>
              <div 
                ref={scrollAreaRef} 
                className="h-[400px] mb-4 p-4 bg-gray-50 rounded-lg overflow-y-auto"
              >
                {messages.length === 0 ? (
                  <div className="text-center text-gray-500">No messages yet. Start a conversation!</div>
                ) : (
                  messages.map((message) => (
                    <div 
                      key={message._id} 
                      className={`mb-2 flex ${
                        message.senderId === "8" ? "justify-end" : "justify-start"
                      }`}
                    >
                      <div 
                        className={`p-3 rounded-lg max-w-xs shadow-md ${
                          message.senderId === "8" 
                            ? "bg-blue-500 text-white" 
                            : "bg-gray-200 text-black"
                        }`}
                      >
                        <p>{message.messageContent}</p>
                        <span className="text-xs text-gray-400 block mt-1 text-right">
                          {formatDate(message.sentTime)}
                        </span>
                      </div>
                    </div>
                  ))
                )}
              </div>
            </ScrollArea>
            {selectedTeacher && (
              <div className="flex items-center space-x-4">
                <Input 
                  placeholder="Type a message..." 
                  value={newMessage} 
                  onChange={(e) => setNewMessage(e.target.value)}
                  onKeyPress={(e) => e.key === 'Enter' && sendMessage()}
                />
                <Button onClick={sendMessage} className="bg-blue-600 hover:bg-blue-700">
                  <Send />
                </Button>
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}

// 'use client'

// import React, { useState } from 'react'
// import axios from 'axios'
// import { 
//   Card, 
//   CardContent, 
//   CardHeader, 
//   CardTitle,
  
// } from '@/components/ui/card'
// import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
// import { Badge } from '@/components/ui/badge'
// import { Button } from '@/components/ui/button'
// import { Input } from '@/components/ui/input'
// import { Pagination } from '@/components/ui/pagination'
// import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover'
// import { ScrollArea } from '@/components/ui/scroll-area'
// import { Calendar } from '@/components/ui/calendar'
// import { MessageCircle, Bell, CalendarIcon, Send, Search, Phone, Video, ChevronLeft, ChevronRight } from 'lucide-react'

// export default function Communication() {
//   const [selectedTeacher, setSelectedTeacher] = useState(null)
//   const [messages, setMessages] = useState([])
//   const [newMessage, setNewMessage] = useState('')
//   const [date, setDate] = useState(new Date())
//   const [currentPage, setCurrentPage] = useState(1)
//   const notificationsPerPage = 5

//   const teachers = [
//     { id: 1, name: "Mrs. Sharma", subject: "Mathematics", lastMessage: "2 hours ago" },
//     { id: 2, name: "Mr. Patel", subject: "Science", lastMessage: "1 day ago" },
//     { id: 3, name: "Ms. Gupta", subject: "English", lastMessage: "3 days ago" },
//     { id: 4, name: "Mr. Singh", subject: "History", lastMessage: "1 week ago" },
//   ]

//   const notifications = [
//     { id: 1, title: "Parent-Teacher Meeting", message: "Scheduled for next Friday at 4 PM", time: "2 hours ago" },
//     { id: 2, title: "Report Card", message: "Term 1 report card is now available", time: "1 day ago" },
//     { id: 3, title: "School Event", message: "Annual Day celebrations on 15th December", time: "3 days ago" },
//     { id: 4, title: "Exam Schedule", message: "Final exams start from 1st December", time: "4 days ago" },
//     { id: 5, title: "Sports Day", message: "Annual sports day on 20th November", time: "5 days ago" },
//     { id: 6, title: "Holiday Notice", message: "School closed on 26th November for Diwali", time: "1 week ago" },
//     { id: 7, title: "Parent Workshop", message: "Digital safety workshop on 10th December", time: "1 week ago" },
//     { id: 8, title: "Fee Reminder", message: "Last date for fee payment is 30th November", time: "2 weeks ago" },
//   ]

//   const events = [
//     { id: 1, title: "Math Quiz", date: "2023-08-15" },
//     { id: 2, title: "Science Fair", date: "2023-08-22" },
//     { id: 3, title: "Parent-Teacher Meeting", date: "2023-08-25" },
//     { id: 4, title: "Sports Day", date: "2023-09-05" },
//     { id: 5, title: "Annual Day", date: "2023-09-15" },
//     { id: 6, title: "Field Trip", date: "2023-09-20" },
//   ]

//   const faqs = [
//     { 
//       question: "How can I track my child's attendance?", 
//       answer: "You can view your child's attendance record in the 'Attendance' section of the dashboard. It provides a monthly overview and highlights any absences." 
//     },
//     { 
//       question: "What is the school's policy on homework?", 
//       answer: "Our school believes in quality over quantity. Students typically receive homework that should take no more than 1-2 hours per day, depending on their grade level." 
//     },
//     { 
//       question: "How can I get involved in school activities?", 
//       answer: "We welcome parent involvement! You can join the Parent-Teacher Association (PTA), volunteer for school events, or participate in our regular parent workshops." 
//     },
//     { 
//       question: "What should I do if my child is struggling in a subject?", 
//       answer: "First, discuss the issue with your child's teacher. They can provide insights and recommend additional support, such as after-school tutoring or study groups." 
//     },
//   ]

//   const selectTeacher = (teacher) => {
//     setSelectedTeacher(teacher)
//     // Simulating API call to fetch messages
//     axios.get(`/api/messages/${teacher.id}`)
//       .then(response => setMessages(response.data))
//       .catch(error => console.error('Error fetching messages:', error))
//   }

//   const sendMessage = () => {
//     if (newMessage.trim() && selectedTeacher) {
//       // Simulating API call to send message
//       axios.post(`/api/messages/${selectedTeacher.id}`, { message: newMessage })
//         .then(response => {
//           setMessages([...messages, response.data])
//           setNewMessage('')
//         })
//         .catch(error => console.error('Error sending message:', error))
//     }
//   }

//   const indexOfLastNotification = currentPage * notificationsPerPage
//   const indexOfFirstNotification = indexOfLastNotification - notificationsPerPage
//   const currentNotifications = notifications.slice(indexOfFirstNotification, indexOfLastNotification)

//   return (
//     <div className="min-h-screen bg-purple-50 p-8">
      
//       <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
//         {/* Teacher List */}
//         <Card className="bg-white shadow-lg">
//           <CardHeader>
//             <CardTitle className="text-2xl font-bold text-gray-800 flex items-center">
//               <MessageCircle className="mr-2" />
//               Teachers
//             </CardTitle>
//           </CardHeader>
//           <CardContent>
//             <div className="space-y-4">
//               {teachers.map((teacher) => (
//                 <div 
//                   key={teacher.id} 
//                   className={`flex items-center space-x-4 p-3 rounded-lg cursor-pointer transition-colors ${
//                     selectedTeacher?.id === teacher.id ? 'bg-blue-100' : 'hover:bg-gray-100'
//                   }`}
//                   onClick={() => selectTeacher(teacher)}
//                 >
//                   <Avatar>
//                     <AvatarImage src={`/placeholder.svg?height=40&width=40&text=${teacher.name.charAt(0)}`} />
//                     <AvatarFallback>{teacher.name.charAt(0)}</AvatarFallback>
//                   </Avatar>
//                   <div className="flex-1">
//                     <h4 className="font-semibold">{teacher.name}</h4>
//                     <p className="text-sm text-gray-600">{teacher.subject}</p>
//                   </div>
//                   <Badge variant="outline">{teacher.lastMessage}</Badge>
//                 </div>
//               ))}
//             </div>
//           </CardContent>
//         </Card>

//         {/* Chat Area */}
//         <Card className="lg:col-span-2 bg-white shadow-lg">
//           <CardHeader>
//             <CardTitle className="text-2xl font-bold text-gray-800 flex items-center justify-between">
//               <div className="flex items-center">
//                 <MessageCircle className="mr-2" />
//                 {selectedTeacher ? `Chat with ${selectedTeacher.name}` : 'Select a teacher to start chatting'}
//               </div>
//               {selectedTeacher && (
//                 <div className="flex space-x-2">
//                   <Popover>
//                     <PopoverTrigger asChild>
//                       <Button size="sm" variant="outline">
//                         <Phone className="w-4 h-4 mr-2" />
//                         Call
//                       </Button>
//                     </PopoverTrigger>
//                     <PopoverContent>
//                       <p>Call feature coming soon!</p>
//                     </PopoverContent>
//                   </Popover>
//                   <Popover>
//                     <PopoverTrigger asChild>
//                       <Button size="sm" variant="outline">
//                         <Video className="w-4 h-4 mr-2" />
//                         Video
//                       </Button>
//                     </PopoverTrigger>
//                     <PopoverContent>
//                       <p>Video call feature coming soon!</p>
//                     </PopoverContent>
//                   </Popover>
//                 </div>
//               )}
//             </CardTitle>
//           </CardHeader>
//           <CardContent>
//             <ScrollArea className="h-[400px] mb-4 p-4 bg-gray-50 rounded-lg">
//               {messages.map((message, index) => (
//                 <div key={index} className={`flex ${message.sender === "You" ? "justify-end" : "justify-start"} mb-4`}>
//                   <div className={`max-w-[70%] p-3 rounded-lg ${message.sender === "You" ? "bg-blue-100 text-blue-800" : "bg-gray-200 text-gray-800"}`}>
//                     <p className="text-sm">{message.content}</p>
//                     <p className="text-xs text-gray-600 mt-1">{message.time}</p>
//                   </div>
//                 </div>
//               ))}
//             </ScrollArea>
//             <div className="flex items-center space-x-2">
//               <Input 
//                 type="text" 
//                 placeholder="Type your message..." 
//                 value={newMessage}
//                 onChange={(e) => setNewMessage(e.target.value)}
//                 onKeyPress={(e) => e.key === 'Enter' && sendMessage()}
//               />
//               <Button onClick={sendMessage}>
//                 <Send className="w-4 h-4 mr-2" />
//                 Send
//               </Button>
//             </div>
//           </CardContent>
//         </Card>

//         {/* Notifications */}
//         <Card className="col-span-full lg:col-span-2 bg-white shadow-lg">
//           <CardHeader>
//             <CardTitle className="text-2xl font-bold text-gray-800 flex items-center justify-between">
//               <div className="flex items-center">
//                 <Bell className="mr-2" />
//                 Notifications
//               </div>
//               <Pagination>
//                 <Button
//                   variant="outline"
//                   size="sm"
//                   onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
//                   disabled={currentPage === 1}
//                 >
//                   <ChevronLeft className="h-4 w-4" />
//                   Previous
//                 </Button>
//                 <Button
//                   variant="outline"
//                   size="sm"
//                   onClick={() => setCurrentPage(prev => Math.min(prev + 1, Math.ceil(notifications.length / notificationsPerPage)))}
//                   disabled={currentPage === Math.ceil(notifications.length / notificationsPerPage)}
//                 >
//                   Next
//                   <ChevronRight className="h-4 w-4" />
//                 </Button>
//               </Pagination>
//             </CardTitle>
//           </CardHeader>
//           <CardContent>
//             <div className="space-y-4">
//               {currentNotifications.map((notification) => (
//                 <Popover key={notification.id}>
//                   <PopoverTrigger asChild>
//                     <div className="bg-gradient-to-r from-yellow-50 to-orange-100 p-3 rounded-lg shadow-sm cursor-pointer">
//                       <h4 className="font-semibold">{notification.title}</h4>
//                       <p className="text-sm text-gray-600">{notification.message}</p>
//                       <p className="text-xs text-gray-500 mt-1">{notification.time}</p>
//                     </div>
//                   </PopoverTrigger>
//                   <PopoverContent>
//                     <h3 className="font-bold mb-2">{notification.title}</h3>
//                     <p>{notification.message}</p>
//                     <p className="text-sm text-gray-500 mt-2">Received: {notification.time}</p>
//                   </PopoverContent>
//                 </Popover>
//               ))}
//             </div>
//           </CardContent>
//         </Card>

//         {/* Calendar */}
//         <Card className="col-span-full lg:col-span-1 bg-white shadow-lg">
//           <CardHeader>
//             <CardTitle className="text-2xl font-bold text-gray-800 flex items-center">
//               <CalendarIcon className="mr-2" />
//               Calendar
//             </CardTitle>
//           </CardHeader>
//           <CardContent>
//             <Calendar
//               mode="single"
//               selected={date}
//               onSelect={setDate}
//               className="rounded-md border"
//             />
//             <div className="mt-4">
//               <h4 className="font-semibold mb-2">Upcoming Events:</h4>
//               <ul className="space-y-2">
//                 {events.map((event) => (
//                   <li key={event.id} className="flex items-center space-x-2">
//                     <CalendarIcon className="w-4 h-4 text-blue-500" />
//                     <span>{event.title} - {event.date}</span>
//                   </li>
//                 ))}
//               </ul>
//             </div>
//           </CardContent>
//         </Card>

//         {/* FAQ Section */}
//         <Card className="col-span-full bg-white shadow-lg">
//           <CardHeader>
//             <CardTitle className="text-2xl font-bold text-gray-800 flex items-center">
//               <Search className="mr-2" />
//               Frequently Asked Questions
//             </CardTitle>
//           </CardHeader>
//           <CardContent>
//             <div className="space-y-4">
//               {faqs.map((faq, index) => (
//                 <Popover key={index}>
//                   <PopoverTrigger asChild>
//                     <div className="bg-gradient-to-r from-purple-100 to-indigo-50 p-4 rounded-lg shadow-sm cursor-pointer">
//                       <h4 className="font-semibold text-indigo-800 mb-2">{faq.question}</h4>
//                     </div>
//                   </PopoverTrigger>
//                   <PopoverContent>
//                     <h3 className="font-bold mb-2">{faq.question}</h3>
//                     <p>{faq.answer}</p>
//                   </PopoverContent>
//                 </Popover>
//               ))}
//             </div>
//             <div className="mt-4 flex items-center">
//               <Input 
//                 type="text" 
//                 placeholder="Search FAQs..." 
//                 className="flex-1 mr-2"
//               />
//               <Button>
//                 <Search className="w-4 h-4 mr-2" />
//                 Search
//               </Button>
//             </div>
//           </CardContent>
//         </Card>
//       </div>
//     </div>
//   )
// }
