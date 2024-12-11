import { calculateZArbitary, calculateAngle } from "./graphUtilityFunctions";

//                      x  y  z  reference points
const referncePoints = [0, 0, 0];

const offset = [0, 0, 0]; // Adjust the normal intersection offset as needed

// Creates the plotting data and angles between each normals from the array of Plane objects
function createData(planes) {
  const data = [];
  const angles = [];

  planes.forEach((plane1, index1) => {
    const { a, b, c, d } = plane1.coordinates;
    const { colour: planeColour } = plane1.visibility.plane
      ? plane1.colour
      : { colour: "transparent" };
    const { colour: normalColour } = plane1.visibility.normal
      ? plane1.colour
      : { colour: "transparent" };

    // creating plane
    const x_arb = [
      [-1, -1],
      [1, 1],
    ];
    const y_arb = [
      [-1, 1],
      [-1, 1],
    ];

    let z_arb;
    if (c !== 0) {
      z_arb = [
        [
          calculateZArbitary(
            a,
            b,
            c,
            d,
            x_arb[0][0],
            y_arb[0][0],
            referncePoints
          ),
          calculateZArbitary(
            a,
            b,
            c,
            d,
            x_arb[0][1],
            y_arb[0][1],
            referncePoints
          ),
        ],
        [
          calculateZArbitary(
            a,
            b,
            c,
            d,
            x_arb[1][0],
            y_arb[1][0],
            referncePoints
          ),
          calculateZArbitary(
            a,
            b,
            c,
            d,
            x_arb[1][1],
            y_arb[1][1],
            referncePoints
          ),
        ],
      ];
    } else {
      z_arb = [];
    }

    const normalVector1 = plane1.getNormalVector(x_arb, y_arb);

    const sidePoint1 = [
      offset[0] - normalVector1[0],
      offset[1] - normalVector1[1],
      offset[2] - normalVector1[2],
    ];
    const sidePoint2 = [
      offset[0] + normalVector1[0],
      offset[1] + normalVector1[1],
      offset[2] + normalVector1[2],
    ];

    let arcData = {};

    planes.forEach((plane2, index2) => {
      if (index1 >= index2) return;

      const angleRadians = calculateAngle(plane1, plane2);
      angles.push({
        angle: angleRadians,
        plane1: `Plane ${index1 + 1}`,
        plane2: `Plane ${index2 + 1}`,
      });
    });

    // creating angle arc
    // if (index1 > 0) {
    //     const previousPlane = planes[index1 - 1];
    //     const angleRadians = calculateAngle(previousPlane, plane);

    //     angles.push({
    //         angle: angleRadians,
    //         plane1: `Plane ${index1}`,
    //         plane2: `Plane ${index1 + 1}`,
    //     });

    //     // Use midpoint for the arc
    //     const midpointX = (sidePoint1[0] + sidePoint2[0]) / 2;
    //     const midpointY = (sidePoint1[1] + sidePoint2[1]) / 2;
    //     const midpointZ = (sidePoint1[2] + sidePoint2[2]) / 2;

    //     // Generate points for the angle arc
    //     const numPoints = 100;
    //     const arcRadius = 0.5;

    //     const arcThetaValues = Array.from({ length: numPoints }, (_, i) => (i / (numPoints - 1)) * angleRadians);
    //     const arcXValues = arcThetaValues.map((theta) => arcRadius * Math.cos(theta) + midpointX);
    //     const arcYValues = arcThetaValues.map((theta) => arcRadius * Math.sin(theta) + midpointY);
    //     const arcZValues = Array(numPoints).fill(midpointZ); // Assuming the arc is in the XY plane

    //     arcData = {
    //         type: 'scatter3d',
    //         mode: 'lines',
    //         x: arcXValues,
    //         y: arcYValues,
    //         z: arcZValues,
    //         line: { color: 'red' },
    //     };
    // }

    // appending data
    data.push(
      {
        name: `Plane ${index1 + 1}`,
        type: "surface",

        x: x_arb,
        y: y_arb,
        z: z_arb,

        colorscale: [
          [0, planeColour],
          [1, planeColour],
        ],
        showscale: false,
      },
      {
        name: `Normal ${index1 + 1}`,
        type: "scatter3d",

        x: [sidePoint1[0], sidePoint2[0]],
        y: [sidePoint1[1], sidePoint2[1]],
        z: [sidePoint1[2], sidePoint2[2]],

        mode: "lines",
        line: { color: normalColour, width: 5 },
      },
      arcData
    );
  });

  function crossProduct(v1, v2) {
    return [
      v1[1] * v2[2] - v1[2] * v2[1],
      v1[2] * v1[0] - v1[0] * v2[2],
      v1[0] * v2[1] - v1[1] * v2[0],
    ];
  }

  function getPlaneFromNormals(normal1, normal2) {
    const planeNormal = crossProduct(normal1, normal2);

    const pointOnPlane = [0, 0, 0];
    const [a, b, c] = planeNormal;

    const d = -(
      a * pointOnPlane[0] +
      b * pointOnPlane[1] +
      c * pointOnPlane[2]
    );

    return { a, b, c, d };
  }

  // Put plane 1 and plane 2 normals here (sidePoint ig):
  const normal1 = [1, 1, 1];
  const normal2 = [1, 0.3333, 0.3333];

  const planeEquation = getPlaneFromNormals(normal1, normal2);
  console.log(
    `The plane by the two normals is: ${planeEquation.a}x + ${planeEquation.b}y + ${planeEquation.c}z = -${planeEquation.d}`
  );

  return { data, angles };
}

export default createData;
