"use client";
import { useState, useEffect, useRef } from "react";

import toast from "react-hot-toast";

import "./components/stylesheets/home.css";
import Header from "./components/Header";
import SidePanel from "./components/Home/Side/SidePanel";
import GraphArea from "./components/Home/Graph/GraphArea";
import Protractor from "./components/protractor/Protractor";
import Plane from "./components/Home/Graph/Plane";
import DraggableComponent from "./utils/DraggableComponent";

const Home = () => {
  const userSettings = JSON.parse(localStorage.getItem("user-settings"));

  const [panelVisible, setPanelVisible] = useState(
    userSettings ? userSettings.panelVisible : true
  );

  const [angleAvailable, setAngleAvailable] = useState(false);

  const [calcAnglesPopUpActive, setCalcAnglesPopUpActive] = useState(false);
  const anglesPopUpBttnRef = useRef(null);

  const [planes, setPlanes] = useState(
    localStorage.getItem("planes")
      ? JSON.parse(localStorage.getItem("planes")).map((plane, index) => {
          return new Plane([plane.a, plane.b, plane.c, plane.d], plane.colour);
        })
      : []
  );

  const [draggableComponentisMounted, setDraggableComponentIsMounted] =
    useState(false);

  useEffect(() => {
    if (draggableComponentisMounted) {
      toast("Drag the protractor to move.\nScroll over it to rotate.", {
        icon: "ℹ️",
        duration: 6000,
      });
    }
  }, [draggableComponentisMounted]);

  const [tutorialShown, setTutorialShown] = useState(
    localStorage.getItem("tutorial-shown")
      ? JSON.parse(localStorage.getItem("tutorial-shown"))
      : false
  );

  const panelRef = useRef(null);
  const panelButtonRef = useRef(null);
  // useEffect(listenForOutsideClicks(listening, setListening, panelRef, panelButtonRef, panelVisible, setPanelVisible));

  useEffect(() => {
    const planesInfo = planes.map((plane, index) => {
      const { a, b, c, d } = plane.coordinates;
      const { colour } = plane.colour;

      return {
        a: a,
        b: b,
        c: c,
        d: d,
        colour: colour,
      };
    });
    localStorage.setItem("planes", JSON.stringify(planesInfo));
  }, [planes]);

  useEffect(() => {
    const newSetting = { ...userSettings };
    newSetting.panelVisible = panelVisible;

    localStorage.setItem("user-settings", JSON.stringify(newSetting));
  }, [panelVisible, userSettings]);

  return (
    <div id="home">
      <Header setDraggableComponentIsMounted={setDraggableComponentIsMounted} />
      <SidePanel
        planes={planes}
        setPlanes={setPlanes}
        panelVisible={panelVisible}
        setPanelVisible={setPanelVisible}
        panelRef={panelRef}
        panelButtonRef={panelButtonRef}
        setCalcAnglesPopUpActive={setCalcAnglesPopUpActive}
        anglesPopUpBttnRef={anglesPopUpBttnRef}
        angleAvailable={angleAvailable}
        tutorialShown={tutorialShown}
        setTutorialShown={setTutorialShown}
        setDraggableComponentIsMounted={setDraggableComponentIsMounted}
      />
      <GraphArea
        planes={planes}
        panelVisible={panelVisible}
        calcAnglesPopUpActive={calcAnglesPopUpActive}
        setCalcAnglesPopUpActive={setCalcAnglesPopUpActive}
        anglesPopUpBttnRef={anglesPopUpBttnRef}
        setAngleAvailable={setAngleAvailable}
        angleAvailable={angleAvailable}
      />
      {draggableComponentisMounted && (
        <DraggableComponent children={<Protractor />} />
      )}
    </div>
  );
};

export default Home;
