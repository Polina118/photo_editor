import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class LabelScreen extends StatefulWidget {
  const LabelScreen({super.key});

  @override
  State<LabelScreen> createState() => _LabelScreenState();
}

class _LabelScreenState extends State<LabelScreen> {

  late AppImageProvider imageProvider;
  ScreenshotController screenShotController = ScreenshotController();

  Uint8List? currentImage;
  bool imageLabelChecking = false;
  // String imageLabel = "";
  XFile? image;

    @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    // image = XFile.fromData(currentImage!);
    super.initState();
  }

  List<ImageLabel> _imageLabels = [];

  Future<void> _processImageLabels(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    ImageLabeler imageLabeler =
        ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.0));
    List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    setState(() {
      _imageLabels = labels;
    });
    await imageLabeler.close();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(color: Colors.white,),
        title: const Text('Label'),
        // actions: [
        //   IconButton(color: Colors.white,
        //     onPressed: () async {
        //       Uint8List? bytes = await screenShotController.capture();
        //       imageProvider.changeImage(bytes!);
        //       if(!mounted) return;
        //       Navigator.of(context).pop();
        //   }, 
        //   icon: const Icon(Icons.done)
        //   )
        // ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (context, value, Widget? child){
          if (value.currentImage != null) {
            image = XFile.fromData(value.currentImage!);
            // final inputImage = InputImage.fromFilePath(image.path);
            // inputImage = FirebaseVisionImage.fromBytes(value.currentImage!);
            _processImageLabels(image!); // Обработка меток после загрузки нового изображения
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.memory(value.currentImage!),
                const SizedBox(height: 10),
                const Text('Labels:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Expanded(
                  child: ListView.builder(
                    itemCount: _imageLabels.length,
                    itemBuilder: (context, index) {
                      final label = _imageLabels[index];
                      return ListTile(
                        title: Text(label.label),
                        subtitle: Text('Confidence: ${label.confidence.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    )
    );
  }









    //     child: SingleChildScrollView(
    //     child: Container(
    //         margin: const EdgeInsets.all(20),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               Consumer<AppImageProvider>(
    //                 builder: (context, value, Widget? child){
    //                   if(value.currentImage != null){
    //                     return Screenshot(
    //                       controller: screenShotController,
    //                       child: Image.memory(value.currentImage!)
    //                     );
    //                   }
    //                   return
    //                   const Center(
    //                     child: CircularProgressIndicator(),
    //                   );
    //                 }
    //               ),
    //             // Container(
    //             //   margin: const EdgeInsets.symmetric(
    //             //       vertical: 5, horizontal: 5),
    //             //   child: const Column(
    //             //     mainAxisSize: MainAxisSize.min,
    //             //     children: [
    //             //       Text(
    //             //         "Labels",
    //             //           style: TextStyle(
    //             //             fontSize: 13,
    //             //             color: Colors.green,
    //             //             fontWeight: FontWeight.bold),
    //             //       )
    //             //     ]
    //             //     ),
    //             // )
    //               Container(
    //                 margin: const EdgeInsets.symmetric(horizontal: 5),
    //                 padding: const EdgeInsets.symmetric(vertical: 20),
    //                 child: ElevatedButton(
    //                   style: ElevatedButton.styleFrom(
    //                     shadowColor: Colors.grey[400],
    //                     elevation: 10,
    //                     shape: RoundedRectangleBorder(
    //                       borderRadius: BorderRadius.circular(8.0)),
    //                   ),
    //                   onPressed: () {
    //                     getImageLabels(currentImage!);
    //                   },
    //                   child: Container(
    //                         margin: const EdgeInsets.symmetric(
    //                             vertical: 5, horizontal: 5),
    //                         child: const Column(
    //                           mainAxisSize: MainAxisSize.min,
    //                           children: [
    //                             Text(
    //                               "Camera",
    //                               style: TextStyle(
    //                                   fontSize: 13,
    //                                   color: Colors.green,
    //                                   fontWeight: FontWeight.bold),
    //                             )
    //                           ],
    //                         ),
    //                     )
    //                   )
    //               )
    //         ]
    //           )
    //     )
    //   )
    // )
    // );

  }

  // void getImageLabels (Uint8List bytes) async {
  //   XFile image = XFile.fromData(bytes);
  //   final inputImage = InputImage.fromFilePath(image.path);
  //   ImageLabeler imageLabeler =
  //       ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.75));
  //   List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
  //   StringBuffer sb = StringBuffer();
  //   for (ImageLabel imgLabel in labels) {
  //     String lblText = imgLabel.label;
  //     double confidence = imgLabel.confidence;
  //     sb.write(lblText);
  //     sb.write(" : ");
  //     sb.write((confidence * 100).toStringAsFixed(2));
  //     sb.write("%\n");
  //   }
  //   imageLabeler.close();
  //   imageLabel = sb.toString();
  //   imageLabelChecking = false;
  //   setState(() {});
  // }