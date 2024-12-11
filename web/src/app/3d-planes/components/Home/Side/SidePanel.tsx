import { useState } from "react";

import GraphInfo from "./GraphInfo";
import Plane from "../Graph/Plane";

import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faBars, faClose } from "@fortawesome/free-solid-svg-icons";

import "../../stylesheets/sidepanel.css";

import appLogo from "./../../../resources/images/favicon.jpg";
import Tutorial from "../tutorial/Tutorial";

const SidePanel = ({
  planes,
  setPlanes,
  panelVisible,
  setPanelVisible,
  panelRef,
  panelButtonRef,
  setCalcAnglesPopUpActive,
  anglesPopUpBttnRef,
  angleAvailable,
  tutorialShown,
  setTutorialShown,
  setDraggableComponentIsMounted,
}) => {
  const [hidePlanes, setHidePlanes] = useState(false);
  const [hideNormals, setHideNormals] = useState(false);

  const handleAddPlane = () => {
    setPlanes([...planes, new Plane([0, 0, 0, 0])]);
  };

  const handleDeletePlane = (planeIndex) => {
    const updatedPlanes = planes.filter((_, index) => index !== planeIndex);
    setPlanes(updatedPlanes);
  };

  const handleInputChange = (planeIndex, coordinates, colour, visibility) => {
    const updatedPlanes = [...planes];

    updatedPlanes[planeIndex].coordinates = coordinates;
    updatedPlanes[planeIndex].colour = colour;
    updatedPlanes[planeIndex].visibility = visibility;

    setPlanes(updatedPlanes);
  };

  return (
    <div
      id="side-panel"
      className={`${!panelVisible ? "side-panel-small" : ""}`}
      ref={panelRef}
    >
      {!tutorialShown ? (
        <Tutorial setTutorialShown={setTutorialShown} />
      ) : (
        <></>
      )}

      <div
        id="panel-toggle-btn"
        title={panelVisible ? "hide panel" : "show panel"}
        onClick={() => setPanelVisible((prev) => !prev)}
        ref={panelButtonRef}
      >
        <FontAwesomeIcon icon={panelVisible ? faClose : faBars} />
      </div>

      <div className="app-title">
        <div className="app-logo">
          <img src={appLogo} alt="App Logo" title="ZenithAngles" />
        </div>
        <p>ZenithAngles</p>
      </div>

      <div id="side-panel-options">
        <button
          className={`${hidePlanes ? "hidden-btn" : ""}`}
          onClick={() => setHidePlanes((prev) => !prev)}
        >
          {hidePlanes ? "Show" : "Hide"} all planes
        </button>
        <button
          className={`${hideNormals ? "hidden-btn" : ""}`}
          onClick={() => setHideNormals((prev) => !prev)}
        >
          {hideNormals ? "Show" : "Hide"} all normals
        </button>
      </div>
      {planes?.length ? (
        <div id="graph-details-wrapper">
          {planes.map((plane, index) => (
            <GraphInfo
              key={index}
              idx={index}
              plane={plane}
              hidePlanes={hidePlanes}
              hideNormals={hideNormals}
              handleDeletePlane={handleDeletePlane}
              handleInputChange={handleInputChange}
            />
          ))}
        </div>
      ) : (
        <></>
      )}

      <div id="plane-bttns-wrapper">
        <button
          onClick={handleAddPlane}
          title="Add a plane"
          id="add-plane-bttn"
        >
          Add Plane
        </button>

        <button
          onClick={() => setDraggableComponentIsMounted((prev) => !prev)}
          id="toggle-protractor-bttn"
          title="toggle protractor"
        >
          Toggle Protractor
        </button>

        <button
          disabled={!angleAvailable}
          ref={anglesPopUpBttnRef}
          onClick={() => setCalcAnglesPopUpActive(true)}
          id="test-angle-bttn"
          className={!angleAvailable ? "bttn-grey cursor-not-allowed" : ""}
          title="Calculate Angles"
        >
          Calculate Angles
        </button>
      </div>
    </div>
  );
};

export default SidePanel;
