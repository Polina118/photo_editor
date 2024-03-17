import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AppColorPicker{

  show(BuildContext context, {Color? backgroundColor, Uint8List? image, onPick}){
    return showDialog(
      context: context,
      builder: (BuildContext context){
        Color tempColor = backgroundColor!;
        return StatefulBuilder(builder: (context, setState){
          return AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                enableAlpha: false,
                hexInputBar: true,
                paletteType: PaletteType.hueWheel,
                pickerColor: backgroundColor,
                onColorChanged: (color){
                  tempColor = color;
                },
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: (){
                  onPick(tempColor);
                  Navigator.of(context).pop();
                  }, 
                child: const Text('Got it')
              )
            ],
            );
         },
        );
      },
    );
  }
}