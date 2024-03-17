import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:painter/painter.dart';
import 'package:photo_editor/helper/app_color_picker.dart';
import 'package:photo_editor/helper/pixel_color_image.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {

  late AppImageProvider imageProvider;
  ScreenshotController screenShotController = ScreenshotController();
  final PainterController painterController = PainterController();

  Uint8List? currentImage;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    painterController.thickness = 5.0;
    painterController.backgroundColor = Colors.transparent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(color: Colors.white,),
        title: const Text('Draw'),
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
                  currentImage = value.currentImage;
                  return Screenshot(
                    controller: screenShotController,
                    child: Stack(
                      children: [
                        Image.memory(value.currentImage!,),
                        Positioned.fill(
                          child: Painter(painterController)
                        )
                      ],
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
                        Container(
                          width: 20,
                          child: Icon(Icons.circle, color: Colors.white, size: painterController.thickness + 3)
                        ),
                        Expanded(
                          child: slider(
                            value: painterController.thickness,
                            onChanged: (value){
                              setState(() {
                                painterController.thickness = value;
                              });
                            }
                          ),
                        ),
                      ],
                    ),
                  ]
                ),
              ),
            ),
          ]
      ),
      bottomNavigationBar: Container(
          width: double.infinity,
          height: 60,
          color: Colors.black,
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RotatedBox(
                    quarterTurns: painterController.eraseMode ? 2 : 0,
                    child: _bottomBarItem(
                      Icons.create,
                      onPress: (){
                        setState(() {
                          painterController.eraseMode = !painterController.eraseMode;
                        });
                      }
                    ),
                  ),
                ),
            
                Expanded(
                  child: _bottomBarItem(
                    Icons.color_lens_outlined,
                    onPress: (){
                      AppColorPicker().show(
                        context,
                        backgroundColor: painterController.drawColor,
                        onPick: (color){
                          setState(() {
                            painterController.drawColor = color;
                          });
                        }
                      );
                    }
                  ),
                ),

                Expanded(
                  child: _bottomBarItem(
                    Icons.colorize,
                    onPress: (){
                     PixelColorImage().show(
                      context,
                      backgroundColor: painterController.drawColor,
                      image: currentImage,
                      onPick: (color){
                        setState(() {
                          painterController.drawColor = color;
                        });
                      }
                    );
                    }
                  ),
                ),

                Expanded(
                  child: _bottomBarItem(
                    Icons.undo,
                    onPress: (){
                      if (!painterController.isEmpty){
                        painterController.undo();
                      }
                    }
                  ),
                ),
            
                Expanded(
                  child: _bottomBarItem(
                    Icons.delete,
                    onPress: (){
                      painterController.clear();
                    }
                  ),
                ),
              ]
            ),
          ),
        ),
    );
  }

  Widget _bottomBarItem(IconData icon, {required onPress}){
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white,),
          ],
        )
      ),
    );
  }

  Widget slider({value, onChanged}){
  return Slider(
    label: '${value.toStringAsFixed(2)}',
    value: value,
    max: 20,
    min: 0.5, 
    onChanged: onChanged
    );
  }
}