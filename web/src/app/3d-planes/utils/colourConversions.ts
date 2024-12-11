function rgbToHex(rgbStr) {
  rgbStr = rgbStr.substring(4);

  const rgbVals = rgbStr.split(",");
  const r = parseInt(rgbVals[0], 10);
  const g = parseInt(rgbVals[1], 10);
  const b = parseInt(rgbVals[2].substring(0, rgbVals[2].length - 1), 10);

  let hexR = r.toString(16);
  let hexG = g.toString(16);
  let hexB = b.toString(16);

  if (hexR.length === 1) {
    hexR = "0" + hexR;
  }
  if (hexG.length === 1) {
    hexG = "0" + hexG;
  }
  if (hexB.length === 1) {
    hexB = "0" + hexB;
  }

  return "#" + hexR + hexG + hexB;
}

function hexToRGB(hexStr) {
  hexStr = hexStr.substring(1);

  const rgbVals = hexStr.split("");

  const r = parseInt(rgbVals[0] + rgbVals[1], 16);
  const g = parseInt(rgbVals[2] + rgbVals[3], 16);
  const b = parseInt(rgbVals[4] + rgbVals[5], 16);

  return "rgb(" + r + ", " + g + ", " + b + ")";
}

export { rgbToHex, hexToRGB };
