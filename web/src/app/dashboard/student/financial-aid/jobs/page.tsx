"use client";

import { useEffect, useRef, useState } from "react";
import {
  MapPin,
  Bell,
  Settings,
  Search,
  ChevronDown,
  Filter,
  Bookmark,
} from "lucide-react";
import Lenis from "@studio-freight/lenis";
// import axios from 'axios'
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { Checkbox } from "@/components/ui/checkbox";

const backgroundColors = [
  "bg-pink-100",
  "bg-green-100",
  "bg-yellow-100",
  "bg-blue-100",
  "bg-red-100",
  "bg-purple-100",
];

const filters = {
  workingSchedule: [
    { id: "full-time", label: "Full time" },
    { id: "part-time", label: "Part time" },
    { id: "internship", label: "Internship" },
    { id: "project-work", label: "Project work" },
    { id: "volunteering", label: "Volunteering" },
  ],
  employmentType: [
    { id: "full-day", label: "Full day" },
    { id: "flexible-schedule", label: "Flexible schedule" },
    { id: "shift-work", label: "Shift work" },
    { id: "distant-work", label: "Distant work" },
    { id: "shift-method", label: "Shift method" },
  ],
};

const dummyJobListings = [
  {
    date: "20 May, 2023",
    title: "Senior UI/UX Designer",
    company: "Tata Consultancy Services",
    logo: "https://logo.clearbit.com/tcs.com",
    badges: ["Full time", "Senior level", "Distant", "Project work"],
    salary: "₹1,50,000/mo",
    location: "Bangalore, Karnataka",
  },
  {
    date: "4 Feb, 2023",
    title: "Junior UI/UX Designer",
    company: "Infosys",
    logo: "https://logo.clearbit.com/infosys.com",
    badges: ["Full time", "Junior level", "On-site", "Flexible Schedule"],
    salary: "₹60,000/mo",
    location: "Hyderabad, Telangana",
  },
  {
    date: "29 Jan, 2023",
    title: "Senior Motion Designer",
    company: "Wipro",
    logo: "https://logo.clearbit.com/wipro.com",
    badges: ["Part time", "Senior level", "Hybrid", "Shift work"],
    salary: "₹1,20,000/mo",
    location: "Mumbai, Maharashtra",
  },
  {
    date: "15 Jun, 2023",
    title: "Full Stack Developer",
    company: "Tech Mahindra",
    logo: "https://logo.clearbit.com/techmahindra.com",
    badges: ["Full time", "Mid level", "Distant", "Project work"],
    salary: "₹1,80,000/mo",
    location: "Pune, Maharashtra",
  },
  {
    date: "3 Jul, 2023",
    title: "Product Manager",
    company: "HCL Technologies",
    logo: "https://logo.clearbit.com/hcltech.com",
    badges: ["Full time", "Senior level", "On-site", "Full Day"],
    salary: "₹2,00,000/mo",
    location: "Noida, Uttar Pradesh",
  },
  {
    date: "10 Aug, 2023",
    title: "Data Scientist",
    company: "Cognizant",
    logo: "https://logo.clearbit.com/cognizant.com",
    badges: ["Full time", "Mid level", "Hybrid", "Flexible Schedule"],
    salary: "₹1,40,000/mo",
    location: "Chennai, Tamil Nadu",
  },
];

export default function JobSearch() {
  const containerRef = useRef<HTMLDivElement>(null);
  const [jobListings, setJobListings] = useState(dummyJobListings);
  const [activeFilters, setActiveFilters] = useState({
    workingSchedule: [],
    employmentType: [],
  });

  useEffect(() => {
    const lenis = new Lenis();

    function raf(time: number) {
      lenis.raf(time);
      requestAnimationFrame(raf);
    }

    requestAnimationFrame(raf);
  }, []);

  // Commented out Axios-related code
  // useEffect(() => {
  //   fetchJobs()
  // }, [])

  // const fetchJobs = async () => {
  //   try {
  //     const response = await axios.get('https://api.example.com/jobs')
  //     setJobListings(response.data)
  //   } catch (err) {
  //     console.error('Error fetching jobs:', err)
  //   }
  // }

  const handleFilterChange = (category, id: Number) => {
    setActiveFilters((prev) => ({
      ...prev,
      [category]: prev[category].includes(id)
        ? prev[category].filter((item) => item !== id)
        : [...prev[category], id],
    }));
  };

  const filteredJobs = jobListings.filter((job) => {
    const scheduleMatch =
      activeFilters.workingSchedule.length === 0 ||
      activeFilters.workingSchedule.some((filter) =>
        job.badges.includes(filter)
      );
    const typeMatch =
      activeFilters.employmentType.length === 0 ||
      activeFilters.employmentType.some((filter) =>
        job.badges.includes(filter)
      );
    return scheduleMatch && typeMatch;
  });

  return (
    <div className="min-h-screen bg-purple-50" ref={containerRef}>
      <div className="container mx-auto px-4 py-8">
        <div className="flex gap-8">
          {/* Filters Sidebar */}
          <div className="w-64 flex-shrink-0">
            <div className="mb-8">
              <div className="relative h-[240px] w-full rounded-lg bg-blue-200 p-6 text-white">
                <div className="relative z-10">
                  <h2 className="mb-2 text-2xl font-bold">
                    Get Your best profession
                  </h2>
                  <p className="mb-4">with UdaanJob</p>
                  <Button className="bg-blue-400 hover:bg-blue-500">
                    Learn more
                  </Button>
                </div>
                <div className="absolute inset-0 rounded-lg bg-[radial-gradient(circle_at_bottom_left,rgba(255,255,255,0.1)_0%,transparent_100%)]" />
              </div>
            </div>

            <div className="space-y-6">
              <div>
                <h3 className="mb-4 text-sm font-medium text-gray-500">
                  Working schedule
                </h3>
                <div className="space-y-3">
                  {filters.workingSchedule.map((item) => (
                    <div key={item.id} className="flex items-center">
                      <Checkbox
                        id={item.id}
                        checked={activeFilters.workingSchedule.includes(
                          item.id
                        )}
                        onCheckedChange={() =>
                          handleFilterChange("workingSchedule", item.id)
                        }
                      />
                      <label
                        htmlFor={item.id}
                        className="ml-2 text-sm font-medium"
                      >
                        {item.label}
                      </label>
                    </div>
                  ))}
                </div>
              </div>

              <div>
                <h3 className="mb-4 text-sm font-medium text-gray-500">
                  Employment type
                </h3>
                <div className="space-y-3">
                  {filters.employmentType.map((item) => (
                    <div key={item.id} className="flex items-center">
                      <Checkbox
                        id={item.id}
                        checked={activeFilters.employmentType.includes(item.id)}
                        onCheckedChange={() =>
                          handleFilterChange("employmentType", item.id)
                        }
                      />
                      <label
                        htmlFor={item.id}
                        className="ml-2 text-sm font-medium"
                      >
                        {item.label}
                      </label>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>

          {/* Main Content */}
          <div className="flex-1">
            <div className="mb-6 flex items-center justify-between">
              <h1 className="text-2xl font-bold">
                Recommended jobs{" "}
                <Badge variant="outline" className="ml-2">
                  {filteredJobs.length}
                </Badge>
              </h1>
              <div className="flex items-center gap-4">
                <span className="text-sm text-gray-600">Sort by:</span>
                <Select>
                  <SelectTrigger className="w-[180px]">
                    <SelectValue placeholder="Last updated" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="last-updated">Last updated</SelectItem>
                    <SelectItem value="salary-high-low">
                      Salary: High to Low
                    </SelectItem>
                    <SelectItem value="salary-low-high">
                      Salary: Low to High
                    </SelectItem>
                  </SelectContent>
                </Select>
                <Button variant="outline" size="icon">
                  <Filter className="h-4 w-4" />
                </Button>
              </div>
            </div>

            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {filteredJobs.map((job, index) => (
                <Card
                  key={index}
                  className={`overflow-hidden ${
                    backgroundColors[index % backgroundColors.length]
                  } border-none`}
                >
                  <CardContent className="p-4">
                    <div className="mb-6 flex items-start justify-between">
                      <div className="text-sm text-gray-500">{job.date}</div>
                      <Button
                        variant="ghost"
                        size="icon"
                        className="text-gray-400 hover:text-gray-600"
                      >
                        <Bookmark className="h-5 w-5" />
                      </Button>
                    </div>
                    <div className="mb-4">
                      <div className="mb-2 flex items-center gap-2">
                        <img
                          src={job.logo}
                          alt={job.company}
                          className="h-6 w-6 rounded"
                        />
                        <span className="font-medium">{job.company}</span>
                      </div>
                      <h3 className="text-xl font-semibold">{job.title}</h3>
                    </div>
                    <div className="mb-6 flex flex-wrap gap-2">
                      {job.badges.map((badge, badgeIndex) => (
                        <Badge
                          key={badgeIndex}
                          variant="secondary"
                          className="rounded-full bg-white/50 hover:bg-white/60"
                        >
                          {badge}
                        </Badge>
                      ))}
                    </div>
                    <div className="flex items-center justify-between">
                      <div>
                        <div className="text-lg font-bold">{job.salary}</div>
                        <div className="text-sm text-gray-500">
                          {job.location}
                        </div>
                      </div>
                      <Button className="rounded-full bg-black hover:bg-gray-800">
                        Details
                      </Button>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
