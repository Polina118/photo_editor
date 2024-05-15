import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
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

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  List<ImageLabel> _imageLabels = [];

  Future<void> _processImageLabels(AppImageProvider appImageProvider) async {
    final inputImage = InputImage.fromFilePath(appImageProvider.path!);
    ImageLabeler imageLabeler =
        ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.45));
    List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    try{
    setState(() {
      _imageLabels = labels;
    });
    }
    catch (e){
      print('Exception details:\n $e');
    }
    await imageLabeler.close();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(color: Colors.white),
        title: const Text('Маркировка', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (context, appImageProvider, Widget? child) {
            if (appImageProvider.currentImage != null) {
              _processImageLabels(appImageProvider);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.memory(appImageProvider.currentImage!),
                  const SizedBox(height: 10),
                  const Text('Объекты:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 5),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _imageLabels.length,
                      itemBuilder: (context, index) {
                        final label = _imageLabels[index];
                        return ListTile(
                          title: Text(label.label, style: const TextStyle(color: Colors.white)),
                          subtitle: Text('Confidence: ${label.confidence.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
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
}