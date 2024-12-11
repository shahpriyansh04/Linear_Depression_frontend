export default function listenForOutsideClicks(
  listening,
  setListening,
  menuRef,
  buttonRef,
  popUpActive,
  setPopUpActive,
  popUpActiveKeyCode
) {
  return () => {
    if (listening || !menuRef.current) return;

    setListening(true);

    function handleEvents(evt, type) {
      const cur = menuRef.current;
      const clickedNode = evt.target;

      if (type === "keydown" && evt.keyCode === popUpActiveKeyCode) {
        setPopUpActive(true);
        return;
      }

      if (
        cur.contains(clickedNode) ||
        (buttonRef.current && buttonRef.current.contains(clickedNode)) ||
        (type === "keydown" && evt.keyCode !== 27)
      ) {
        return;
      }

      setPopUpActive(false);
    }

    ["click", "touchstart", "keydown"].forEach((type) => {
      document.addEventListener(type, (evt) => handleEvents(evt, type));
    });

    // Cleanup function
    return () => {
      ["click", "touchstart", "keydown"].forEach((type) => {
        document.removeEventListener(type, handleEvents);
      });
    };
  };
}
