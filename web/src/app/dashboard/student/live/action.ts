"use server";

import axios from "axios";

export const getLectures = async () => {
  const options = {
    method: "get",
    url: "https://api.100ms.live/v2/recording-assets",
    headers: {
      Accept: "*/*",
      "User-Agent": "Flashpost",
      Authorization:
        "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MzM3NDcxODUsImV4cCI6MTczNDM1MTk4NSwianRpIjoiYmZjZTgxNWUtODYyYi00YmJiLThkODctNjZiNWNmYmU3MDQ4IiwidHlwZSI6Im1hbmFnZW1lbnQiLCJ2ZXJzaW9uIjoyLCJuYmYiOjE3MzM3NDcxODUsImFjY2Vzc19rZXkiOiI2NzNlZDdkNTMzY2U3NGFiOWJlOTQ4NjUifQ.EXWX9lvi7UkJUDlYwA7IHKmrIz1qiV5s9ZMISropRLc",
    },
  };

  try {
    const response = await axios.request(options);
    const data = response.data.data;
    console.log(data);

    const lecturesData = await Promise.all(
      data.map(async (lecture: any) => {
        const lectureOptions = {
          method: "get",
          url: `https://api.100ms.live/v2/recording-assets/${lecture.id}/presigned-url`,
          headers: {
            Accept: "*/*",
            Authorization:
              "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MzM3NDcxODUsImV4cCI6MTczNDM1MTk4NSwianRpIjoiYmZjZTgxNWUtODYyYi00YmJiLThkODctNjZiNWNmYmU3MDQ4IiwidHlwZSI6Im1hbmFnZW1lbnQiLCJ2ZXJzaW9uIjoyLCJuYmYiOjE3MzM3NDcxODUsImFjY2Vzc19rZXkiOiI2NzNlZDdkNTMzY2U3NGFiOWJlOTQ4NjUifQ.EXWX9lvi7UkJUDlYwA7IHKmrIz1qiV5s9ZMISropRLc",
          },
        };

        const lectureResponse = await axios.request(lectureOptions);
        return lectureResponse.data;
      })
    );

    return lecturesData;
  } catch (error) {
    console.log(error);
  }
};
