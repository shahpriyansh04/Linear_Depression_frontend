//rgb(a, b, c) format only
function getRandomColour() {
  return `rgb(${Math.floor(Math.random() * 256)}, ${Math.floor(
    Math.random() * 256
  )}, ${Math.floor(Math.random() * 256)})`;
}

function getRandomNumber(min, max) {
  return Math.random() * (max - min) + min;
}

export { getRandomColour, getRandomNumber };
