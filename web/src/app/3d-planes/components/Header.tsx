import "./stylesheets/header.css";
import appLogo from "../resources/images/favicon.jpg";

import ProtractorIcon from "./protractor/ProtractorIcon";

const Header = (props) => {
  return (
    <header>
      <div className="app-title">
        <div className="app-logo">
          <img src={appLogo} alt="App Logo" title="ZenithAngles" />
        </div>
        <p>ZenithAngles</p>
      </div>

      <div id="protractor-options">
        <div
          className="protractor-icon"
          onClick={() => props.setDraggableComponentIsMounted((prev) => !prev)}
          title="toggle protractor"
        >
          <ProtractorIcon />
        </div>
        {/* <img src={ProtractorIcon} alt="Protractor" onClick={() => props.setDraggableComponentIsMounted((prev) => !prev)} title='toggle protractor' /> */}
      </div>
    </header>
  );
};

export default Header;
