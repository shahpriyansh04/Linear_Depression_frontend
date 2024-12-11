import { useEffect, useRef, useState } from "react";
import Draggable from "react-draggable";

const DraggableComponent = (props) => {
  const draggableRef = useRef(null);

  const [rotation, setRotation] = useState(0);

  useEffect(() => {
    const handleWheel = (event) => {
      setRotation((prevRotation) => prevRotation + event.deltaY / 100);
      event.preventDefault();
    };

    const handleTouchMove = (event) => {
      if (event.touches.length === 2) {
        const [touch1, touch2] = event.touches;

        const angle = Math.atan2(
          touch2.clientY - touch1.clientY,
          touch2.clientX - touch1.clientX
        );

        setRotation((prevRotation) => (angle * 180) / Math.PI);
      }
    };

    const containerElement = draggableRef.current;
    containerElement.addEventListener("wheel", handleWheel);
    containerElement.addEventListener("touchmove", handleTouchMove);

    return () => {
      containerElement.removeEventListener("wheel", handleWheel);
      containerElement.removeEventListener("touchmove", handleTouchMove);
    };
  }, []);

  return (
    <Draggable nodeRef={draggableRef}>
      <div className="draggable-container" ref={draggableRef}>
        <div
          className="draggable-inner"
          style={{ transform: `rotate(${rotation}deg)` }}
        >
          {props.children}
        </div>
      </div>
    </Draggable>
  );
};

export default DraggableComponent;
