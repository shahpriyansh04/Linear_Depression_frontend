"use client";

import React from "react";
import { motion } from "framer-motion";

const Transition = () => {
  return (
    <motion.div
      className="fixed inset-0  bg-black overflow-hidden"
      initial={{
        opacity: 1,
        scale: 0.1,
        backgroundImage:
          "radial-gradient(circle at center, rgba(0,255,0,0.2) 0%, rgba(0,0,0,1) 70%)",
        filter: "blur(10px)",
      }}
      animate={{
        opacity: 1,
        scale: 10,
        backgroundImage:
          "radial-gradient(circle at center, rgba(0,255,0,0) 0%, rgba(0,0,0,1) 50%)",
        filter: "blur(50px)",
      }}
      exit={{
        opacity: 0,
        scale: 0.1,
        backgroundImage:
          "radial-gradient(circle at center, rgba(0,255,0,0.2) 0%, rgba(0,0,0,1) 70%)",
        filter: "blur(10px)",
      }}
      transition={{
        duration: 0.6,
        ease: "easeInOut",
      }}
    >
      {/* Light trail effect */}
      <div className="absolute inset-0 pointer-events-none">
        {[...Array(10)].map((_, i) => (
          <motion.div
            key={i}
            initial={{
              opacity: 0.8,
              scale: 0.5,
              y: "50%",
              rotate: Math.random() * 360,
            }}
            animate={{
              opacity: 0,
              scale: 2,
              y: "-100%",
              rotate: Math.random() * 360 + 180,
            }}
            transition={{
              duration: 0.6,
              delay: i * 0.05,
              ease: "easeInOut",
            }}
            className="absolute bottom-0 left-0 right-0 h-1 bg-gradient-to-r from-transparent via-green-500 to-transparent"
            style={{
              width: `${Math.random() * 100 + 50}%`,
              left: `${Math.random() * 50}%`,
            }}
          />
        ))}
      </div>
    </motion.div>
  );
};

export default Transition;
