'use client'
import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import axios from "axios";
import { useSession } from "next-auth/react";

export default function StudentReportPage() {
  const [studentData, setStudentData] = useState(null);
  const { data: session } = useSession();
  const { student } = useParams(); // Use useParams to get the dynamic segment

  useEffect(() => {
    if (student) {
      console.log(`Fetching data for student: ${student}`);
      console.log(`Authorization: Bearer ${session?.user?.token}`);

      axios.get(`http://localhost:8000/student/get-by-id/${student}`, {
        headers: {
          Authorization: `Bearer ${session?.user?.token}`,
        }
      })
      .then((response) => {
        console.log('Fetched data:', response.data.data);
        setStudentData(response.data.data);
    
      })
      .catch((error) => {
        console.error('Error fetching student data:', error);
      
      });
    } else {
      console.log('No student parameter found');
      setLoading(false);
    }
  }, [student, session?.user?.token]);

  return (
    <div>
      <h1>Student Details</h1>
     
        {studentData ? (
            <div>
            <h2>{studentData.lName}</h2>
            <p>{studentData.Name}</p>
            </div>
        ) : (
            <p>Loading...</p>
        )}
    </div>
  );
}