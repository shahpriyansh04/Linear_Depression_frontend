"use client";

import { useState, useEffect } from "react";
import { MapPin, Clock, GraduationCap, Search } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { useSession } from "next-auth/react";
import axios from "axios";
import Link from "next/link";

export default function ScholarshipSearch() {
  const { data: session } = useSession();
  console.log(session?.user);
  const [scholarships, setScholarships] = useState([]);
  const [filteredScholarships, setFilteredScholarships] = useState([]);
  const [recommendedScholarships, setRecommendedScholarships] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");

  const getScholarships = async () => {
    const res = await axios.get("http://localhost:5001/scholarship_info");
    const data = await res.data;
    setScholarships(data);
    setFilteredScholarships(data);
  };

  useEffect(() => {
    getScholarships();
  }, []);

  useEffect(() => {
    const filtered = scholarships.filter(
      (scholarship) =>
        scholarship["Scholarship Name"]
          ?.toLowerCase()
          .includes(searchTerm.toLowerCase()) ||
        scholarship["Scholarship Title"]
          ?.toLowerCase()
          .includes(searchTerm.toLowerCase())
    );
    setFilteredScholarships(filtered);
  }, [searchTerm, scholarships]);

  console.log(filteredScholarships);

  const handleRecommendations = async () => {
    const options = {
      method: "post",
      url: "http://localhost:5001/recommend_scholarship",
      headers: {
        Accept: "*/*",
        "Content-Type": "application/json",
        Authorization: `Bearer ${session?.user?.token}`, // Assuming the token is stored in session.user.token
      },
    };

    axios
      .request(options)
      .then(function (response) {
        console.log(response.data);
        setRecommendedScholarships(response.data);
      })
      .catch(function (error) {
        console.log(error);
      });
  };

  return (
    <div className="min-h-screen bg-purple-50">
      <div className="container mx-auto px-4 py-12">
        <div className="mb-12 text-center">
          <Badge variant="outline" className="mb-6">
            We&apos;re offering scholarships!
          </Badge>

          <h1 className="mb-4 text-4xl font-bold tracking-tight text-purple-900">
            Be part of our mission
          </h1>

          <p className="mx-auto mb-8 max-w-2xl text-lg text-purple-700">
            We&apos;re looking for passionate students to support in their
            educational journey. We value academic excellence, innovation, and
            commitment to making a positive impact.
          </p>

          <div className="mx-auto mb-8 flex max-w-md items-center space-x-2">
            <Input
              type="text"
              placeholder="Search scholarships..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="flex-grow"
            />
            <Button type="submit">
              <Search className="h-4 w-4" />
            </Button>
          </div>

          <Button onClick={handleRecommendations}>
            Recommend Scholarships
          </Button>
        </div>

        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          {recommendedScholarships.length > 0
            ? recommendedScholarships.map((scholarship, index) => (
                <Card
                  key={index}
                  className={`flex flex-col p-1 overflow-hidden ${scholarship.bgColor} transition-all duration-300 hover:shadow-lg h-full`}
                >
                  <CardContent className="flex-grow p-6 flex flex-col">
                    <h2 className="mb-2 text-2xl font-semibold tracking-tight text-purple-900">
                      {scholarship.Scholarship}
                    </h2>
                    {/* <p className="mb-4 text-sm text-purple-700 flex-grow">
                      {scholarship.Criteria}
                    </p> */}

                    <div className="mb-4 flex items-center justify-between text-sm text-purple-700">
                      <div className="flex items-center">
                        <Clock className="mr-1 h-4 w-4" />
                        Start Date from : {scholarship["Start Date From"]}
                      </div>
                      <div className="font-semibold">
                        Amount: {scholarship["Scholarship Amount (INR)"]}
                      </div>
                    </div>
                    {scholarship.link ? (
                      <Link href={scholarship.link} target="_blank">
                        <Button className="w-full bg-purple-600 hover:bg-purple-700 mt-auto">
                          Apply Now
                        </Button>
                      </Link>
                    ) : (
                      <Button
                        className="w-full bg-purple-600 hover:bg-purple-700 mt-auto"
                        disabled
                      >
                        No Link Available
                      </Button>
                    )}
                  </CardContent>
                </Card>
              ))
            : filteredScholarships.map((scholarship, index) => (
                <Card
                  key={index}
                  className={`flex flex-col p-1 overflow-hidden ${scholarship.bgColor} transition-all duration-300 hover:shadow-lg h-full`}
                >
                  <CardContent className="flex-grow p-6 flex flex-col">
                    <h2 className="mb-2 text-2xl font-semibold tracking-tight text-purple-900">
                      {scholarship["Scholarship Name"]}
                    </h2>
                    <p className="mb-4 text-sm text-purple-700 flex-grow">
                      {scholarship.Description}
                    </p>

                    <div className="mb-4 flex items-center justify-between text-sm text-purple-700">
                      <div className="flex items-center">
                        <Clock className="mr-1 h-4 w-4" />
                        Start Date from : {scholarship["Start Date From"]}
                      </div>
                      <div className="font-semibold">
                        Amount: {scholarship["Scholarship Amount (INR)"]}
                      </div>
                    </div>
                    {scholarship.link ? (
                      <Link href={scholarship.link} target="_blank">
                        <Button className="w-full bg-purple-600 hover:bg-purple-700 mt-auto">
                          Apply Now
                        </Button>
                      </Link>
                    ) : (
                      <Button
                        className="w-full bg-purple-600 hover:bg-purple-700 mt-auto"
                        disabled
                      >
                        No Link Available
                      </Button>
                    )}
                  </CardContent>
                </Card>
              ))}
        </div>
      </div>
    </div>
  );
}
