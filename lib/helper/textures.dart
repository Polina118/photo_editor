import 'package:photo_editor/model/texture.dart';

class Textures{

  List<Texture> list(){
    return <Texture> [
      Texture(
        name: "T1",
        path: "assets/textures/t1.jpg"
      ),

      Texture(
        name: "T2",
        path: "assets/textures/t2.jpg"
      ),

      Texture(
        name: "T3",
        path: "assets/textures/t3.jpg"
      ),

      Texture(
        name: "T4",
        path: "assets/textures/t4.jpg"
      ),

      Texture(
        name: "T5",
        path: "assets/textures/t5.jpg"
      ),
    ];
  }
}