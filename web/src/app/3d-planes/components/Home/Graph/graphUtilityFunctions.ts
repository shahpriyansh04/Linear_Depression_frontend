import * as math from "mathjs";

function calculateCrossProduct(vector1, vector2) {
  return [
    vector1[1] * vector2[2] - vector1[2] * vector2[1],
    vector1[2] * vector2[0] - vector1[0] * vector2[2],
    vector1[0] * vector2[1] - vector1[1] * vector2[0],
  ];
}

const createUnitNormalVector = (a, b, c) => {
  const magnitude = Math.sqrt(a * a + b * b + c * c);
  return [a / magnitude, b / magnitude, c / magnitude];
};

function calculateZArbitary(a, b, c, d, x_arb, y_arb, referncePoints) {
  return (
    referncePoints[2] +
    (-a * (x_arb - referncePoints[0]) - b * (y_arb + referncePoints[1]) + d) / c
  );
}

function calculatePlaneIntersection(plane1, plane2) {
  const { a: a1, b: b1, c: c1, d: d1 } = plane1.coordinates;
  const { a: a2, b: b2, c: c2, d: d2 } = plane2.coordinates;

  const crossProduct = calculateCrossProduct([a1, b1, c1], [a2, b2, c2]);

  //If planes are parallel ther is no intersection point
  if (math.norm(crossProduct) === 0) return null;

  const coefficients = [[a1, b1, c1], [a2, b2, c2], crossProduct];

  const constants = [[d1], [d2], [0]];

  const intersectionPoint = math.multiply(math.inv(coefficients), constants);

  return intersectionPoint.map((row) => row[0]);
}

function calculateAngle(plane1, plane2) {
  const plane1Coordinates = plane1.coordinates;
  const plane2Coordinates = plane2.coordinates;

  const normal1 = [
    plane1Coordinates.a,
    plane1Coordinates.b,
    plane1Coordinates.c,
  ];
  const normal2 = [
    plane2Coordinates.a,
    plane2Coordinates.b,
    plane2Coordinates.c,
  ];

  const dotProduct = math.dot(normal1, normal2);

  const magnitudes = math.norm(normal1) * math.norm(normal2);

  // Calculate the angle between the two planes
  const angleRad = math.acos(dotProduct / magnitudes);

  return angleRad;
}

function calculateAllAngles(planes) {
  const angles = [];
  for (let i = 0; i < planes.length; i++) {
    for (let j = i + 1; j < planes.length; j++) {
      const angle = calculateAngle(planes[i], planes[j]);
      const angleInfo = {
        angle,
        plane1: `Plane ${i + 1}`,
        plane2: `Plane ${j + 1}`,
      };
      angles.push(angleInfo);
    }
  }
  return angles;
}

export {
  calculateCrossProduct,
  createUnitNormalVector,
  calculateZArbitary,
  calculatePlaneIntersection,
  calculateAngle,
  calculateAllAngles,
};
