import 'package:flutter/material.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({Key? key}) : super (key: key);

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {

  String generatedText = '';

   @override
  void initState(){
    super.initState();
  }
  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сгенерировать изображение'),
      ),
  body: Center(
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
  Padding(
  padding: EdgeInsets.all(16.0),
  child: TextField(
  onChanged: (text) {
  // Handle text input
  },
  decoration: InputDecoration(
    hintText: 'Enter text here',
    border: OutlineInputBorder(),
    ),
  ),
  ),
  ElevatedButton(
  onPressed: () {
  // Generate text
  },
  child: Text('Generate'),
  ),
  SizedBox(height: 20),
  Text(generatedText),
  ],
  ),
  ),
  );
  }
}