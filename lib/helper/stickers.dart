class Stickers{

  List<List<String>> list(){
    return[
      molang(),
      emoji(),
      pengo()
    ];
  }

  List<String> molang(){
    List<String> list = [];
    for(int i = 1; i <= 5; i++){
      list.add('assets/stickers/molang_$i.png');
    }
    return list;
  }

    List<String> emoji(){
    List<String> list = [];
    for(int i = 1; i <= 5; i++){
      list.add('assets/stickers/emoji_$i.png');
    }
    return list;
  }

    List<String> pengo(){
    List<String> list = [];
    for(int i = 1; i <= 5; i++){
      list.add('assets/stickers/pengo_$i.png');
    }
    return list;
  }
}