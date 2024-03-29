import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class BlurScreen extends StatefulWidget {
  const BlurScreen({super.key});

  @override
  State<BlurScreen> createState() => _BlurScreenState();
}

class _BlurScreenState extends State<BlurScreen> {

  late AppImageProvider imageProvider;
  ScreenshotController screenShotController = ScreenshotController();

  double sigmaX = 0.1;
  double sigmaY = 0.1;
  TileMode tileMode = TileMode.decal;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(color: Colors.white,),
        title: const Text('Blur'),
        actions: [
          IconButton(color: Colors.white,
            onPressed: () async {
              Uint8List? bytes = await screenShotController.capture();
              imageProvider.changeImage(bytes!);
              if(!mounted) return;
              Navigator.of(context).pop();
            }, 
          icon: const Icon(Icons.done)
          )
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Consumer<AppImageProvider>(
              builder: (context, value, Widget? child){
                if(value.currentImage != null){
                  return Screenshot(
                    controller: screenShotController,
                    child: ImageFiltered(imageFilter: ImageFilter.blur(
                      sigmaX: sigmaX, sigmaY: sigmaY, tileMode: tileMode
                      ),
                    child: Image.memory(value.currentImage!,)
                    )
                  );
                }
                return
                const Center(
                  child: CircularProgressIndicator(),
                );
              }
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text('SigmaX', style: TextStyle(color: Colors.white)),
                      Expanded(
                        child: slider(
                          value: sigmaX,
                          onChanged: (value){
                            setState(() {
                              sigmaX = value;
                            });
                          }
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('SigmaY', style: TextStyle(color: Colors.white)),
                      Expanded(
                        child: slider(
                          value: sigmaY,
                          onChanged: (value){
                            setState(() {
                              sigmaY = value;
                            });
                          }
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
          width: double.infinity,
          height: 60,
          color: Colors.black,
          child: SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _bottomBatItem("Decal", color:tileMode == TileMode.decal ? Colors.blue : null,
                    onPress: (){
                      setState(() {
                        tileMode = TileMode.decal;
                      });
                    }
                  ),

                  _bottomBatItem("Clamp", color:tileMode == TileMode.clamp ? Colors.blue : null,
                    onPress: (){
                      setState(() {
                        tileMode = TileMode.clamp;
                      });
                    }
                  ),

                  _bottomBatItem("Mirror", color:tileMode == TileMode.mirror ? Colors.blue : null,
                    onPress: (){
                      setState(() {
                        tileMode = TileMode.mirror;
                      });
                    }
                  ),

                  _bottomBatItem("Repeated", color:tileMode == TileMode.repeated ? Colors.blue : null,
                    onPress: (){
                      setState(() {
                        tileMode = TileMode.repeated;
                      });
                    }
                  ),
                ]
              ),
            ),
          ),
        ),
    );
  }

  Widget _bottomBatItem(String title, {Color? color, required onPress}){
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(title, style: TextStyle(color: color ?? Colors.white),)
      ),
    );
  }

  Widget slider({value, onChanged}){
  return Slider(
    label: '${value.toStringAsFixed(2)}',
    value: value,
    max: 10,
    min: 0.1, 
    onChanged: onChanged
    );
  }
}