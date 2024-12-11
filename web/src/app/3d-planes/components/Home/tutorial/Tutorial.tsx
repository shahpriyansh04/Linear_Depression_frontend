import { useState, useEffect } from "react";
import "../../stylesheets/tutorial.css";
const Tutorial = (props) => {
  const [currentStep, setCurrentStep] = useState(0);
  const [prevId, setPrevId] = useState([]);

  // Define tutorial steps
  const steps = [
    {
      message: "Click the 'Add Plane' button to add a plane",
      highlightIds: ["add-plane-bttn"],
      isStepReady: () => !!document.getElementById("add-plane-bttn"),
    },
    {
      message: "Add variables to the plane equation",
      highlightIds: ["graph-details-wrapper"],
      isStepReady: () => !!document.getElementById("graph-details-wrapper"),
    },
    {
      message: "Add another plane",
      highlightIds: ["add-plane-bttn"],
      isStepReady: () => !!document.getElementById("add-plane-bttn"),
    },
    {
      message: "Add variables to the plane equation",
      highlightIds: ["graph-details-wrapper"],
      isStepReady: () => {
        const elem = document.getElementById("graph-details-wrapper");
        return elem.getElementsByClassName("planeInfoContainer").length >= 2;
      },
    },
    {
      message: "Play around with the planes and visualize it",
      highlightIds: ["side-panel-options", "graph-details-wrapper", "plot"],
      isStepReady: () => !!document.getElementById("plot"),
    },
    {
      message: "Click on the protractor icon to access protractor",
      highlightIds: ["protractor-options", "toggle-protractor-bttn"],
      isStepReady: () =>
        !!document.getElementById("toggle-protractor-bttn") &&
        !!document.getElementById("protractor-options"),
    },
    {
      message:
        "Using your mouse move protractor to measure the angle between the planes (scroll on the protractor to rotate it )",
      highlightIds: ["plot", "protractor"],
      isStepReady: () =>
        !!document.getElementById("protractor") &&
        !!document.getElementById("plot"),
    },
    {
      message: "Now take a quiz to check your answer!",
      highlightIds: ["test-angle-bttn"],
      isStepReady: () => !!document.getElementById("test-angle-bttn"),
    },
  ];

  function handleTutorialStep(idx = 0) {
    const classTrack = [];
    for (let i = 0; i < steps[idx]?.highlightIds.length; ++i) {
      const elem = document.getElementById(steps[idx].highlightIds[i]);

      if (
        !!steps[idx].isStepReady &&
        !(
          typeof steps[idx].isStepReady === "function" &&
          steps[idx].isStepReady()
        )
      ) {
        console.log("Complete the previous step first");
        return idx - 1;
      }

      if (!elem) {
        console.log("Component to be highlighted is not mounted yet.");
        return idx - 1;
      }

      elem.classList.add("highlight");
      classTrack.push(steps[idx].highlightIds[i]);
    }

    prevId.map((id, _) => {
      const elem = document.getElementById(id);
      elem.classList.remove("highlight");
    });

    setPrevId(classTrack);

    return idx;
  }

  useEffect(() => {
    handleTutorialStep();
    setCurrentStep(0);
  }, []);

  if (currentStep === steps.length) {
    localStorage.setItem("tutorial-shown", "true");
    return <></>;
  }

  return (
    <>
      <div className="tutorial-overlay">
        <div className="tutorial-text">
          <div className="tutorial-message">{steps[currentStep]?.message}</div>
          <button
            onClick={() =>
              setCurrentStep((prev) => handleTutorialStep(prev + 1))
            }
          >
            Next
          </button>
        </div>
      </div>
    </>
  );
};

export default Tutorial;
