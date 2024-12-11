"use client";

import { Loader } from "@react-three/drei";
import { Canvas } from "@react-three/fiber";
import { Leva } from "leva";
import { Experience } from "@/components/ui/therapybot/Experience";
import { UI } from "@/components/ui/therapybot/UI";

function App() {
  return (
    <>
      <Loader />
      <Leva hidden={true} />
      <UI hidden={false} />
      <Canvas shadows camera={{ position: [1, 1, 1], fov: 35 }  } style={{ width: '90%', height: '90vh' }} >
        {/* fov is changing how close the avatar is standing */}
        <Experience />
      </Canvas>
    </>
  );
}

export default App;