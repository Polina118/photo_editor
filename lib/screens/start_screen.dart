import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/helper/app_image_picker.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatefulWidget{
  const StartScreen({Key? key}) : super (key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  late AppImageProvider imageProvider;

  void callImageProvider(File? image) {
    imageProvider.changeImageFile(image!);
    imageProvider.path = image.path;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void initState(){
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack (
        children: [
          Center(
              child: SizedBox(
                width: double.infinity,
                child: Image.asset('assets/images/wallpaper.png',
                  fit: BoxFit.cover,
                )
              )
          ),

          Column(
            children: [
              const Expanded(
                child: Center(child: Text(
                  'Photo Editor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold
                  )),
              )
              ),
              Expanded(
                child: Container(),
                ),
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          AppImagePicker(source: ImageSource.gallery)
                          .pick(onPick: callImageProvider);
                        },
                        child: const Text("Гелерея")
                      ),
                      ElevatedButton(
                        onPressed: () {
                          AppImagePicker(source: ImageSource.camera)
                          .pick(onPick: callImageProvider);
                        },
                        child: const Text("Камера")
                      ),
                       ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/generate');
                        },
                        child: const Text("Сгенерировать")
                      )
                    ],
                  ))
                )
            ],
          )
        ],
        )
    );
  }
}