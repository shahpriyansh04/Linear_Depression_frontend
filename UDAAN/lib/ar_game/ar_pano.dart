// import 'package:flutter/material.dart';
// import 'package:arkit_plugin/arkit_plugin.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;

// class ARPanoramaView extends StatefulWidget {
//   @override
//   _ARPanoramaViewState createState() => _ARPanoramaViewState();
// }

// class _ARPanoramaViewState extends State<ARPanoramaView> {
//   late ARKitController arkitController;

//   @override 
//   void dispose() {
//     arkitController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AR Panorama View'),
//       ),
//       body: ARKitSceneView(
//         onARKitViewCreated: onARKitViewCreated,
//       ),
//     );
//   }

//   void onARKitViewCreated(ARKitController controller) {
//     arkitController = controller;

//     // Add panorama texture as the background
//     _addPanorama();
//   }

//   void _addPanorama() {
//     // Define the material with the panorama image
//     final material = ARKitMaterial(
//       diffuse: ARKitMaterialProperty.image('assets/image/panorama.jpg'),
//       doubleSided: true, // Ensure the texture is visible from inside
//     );

//     // Create a sphere to act as the skybox
//     final sphere = ARKitSphere(
//       radius: 10, // Adjust radius as needed
//       materials: [material],
//     );

//     // Create a node with negative scale to invert the sphere
//     final node = ARKitNode(
//       geometry: sphere,
//       position: vector.Vector3(0, 0, 0),
//       scale: vector.Vector3(-1, -1, -1), // Invert the sphere to view from inside
//     );

//     // Add the panorama node to the ARKit scene
//     arkitController.add(node);
//   }
// }