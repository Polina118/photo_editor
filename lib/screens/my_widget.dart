// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
// import 'package:photo_editor/providers/app_image_provider.dart';
// import 'package:provider/provider.dart';

// class MyWidget extends StatefulWidget {
//   @override
//   _MyWidgetState createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<MyWidget> {
//   final ImageLabeler _imageLabeler = GoogleMlKit.instance.imageLabeler();

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Consumer<AppImageProvider>(
//         builder: (context, value, Widget? child) {
//           if (value.currentImage != null) {
//             return FutureBuilder<List<ImageLabel>>(
//               future: _getImageLabels(value.currentImage!),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else {
//                   final labels = snapshot.data!;
//                   return Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.memory(value.currentImage!),
//                       SizedBox(height: 10),
//                       Text('Labels:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                       SizedBox(height: 5),
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: labels.length,
//                           itemBuilder: (context, index) {
//                             final label = labels[index];
//                             return ListTile(
//                               title: Text(label.label),
//                               subtitle: Text('Confidence: ${label.confidence.toStringAsFixed(2)}'),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//               },
//             );
//           }
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }

//   Future<List<ImageLabel>> _getImageLabels(Uint8List imageBytes) async {
//     final inputImage = InputImage.fromBytes(imageBytes, inputImageData: InputImageData(imageRotation: InputImageRotation.Rotation_0deg));
//     return _imageLabeler.processImage(inputImage);
//   }

//   @override
//   void dispose() {
//     _imageLabeler.close();
//     super.dispose();
//   }
// }
