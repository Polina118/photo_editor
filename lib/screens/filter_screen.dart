import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_editor/helper/filters.dart';
import 'package:photo_editor/model/filter.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {

  late Filter currentFilter;
  late List<Filter> filters;

  late AppImageProvider imageProvider;
  ScreenshotController screenShotController = ScreenshotController();

  @override
  void initState() {
    filters = Filters().list();
    currentFilter = filters[0];
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(color: Colors.white,),
        title: const Text('Filters'),
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
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (context, value, Widget? child){
            if(value.currentImage != null){
              return Screenshot(
                controller: screenShotController,
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(currentFilter.matrix),
                  child: Image.memory(value.currentImage!)
                ),
              );
            }
            return
            const Center(
              child: CircularProgressIndicator(),
            );
          }
        )
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 60,
          color: Colors.black,
          child: SafeArea(
            child: Consumer<AppImageProvider>(
              builder: (context, value, Widget? child){
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filters.length,
                    itemBuilder: (context, int index){
                      Filter filter = filters[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 80,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: InkWell(
                                  onTap: (){
                                    setState(() {
                                      currentFilter = filter;
                                    });
                                  },
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.matrix(filter.matrix),
                                    child: Image.memory(value.currentImage!),
                                     )
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Text(filter.filterName, style: const TextStyle(color: Colors.white),)
                              ],
                            ),
                      );
                        },
                      );
                    }
                  )
                )
              ),
            );
          }
  }

//   Widget _bottomBatItem({required child, required onPress}){
//     return Consumer<AppImageProvider>(
//           builder: (context, value, Widget? child){
//             return InkWell(
//               onTap: onPress,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: Column(
//                   children: [
//                      Expanded(
//                          child: ColorFiltered(
//                             colorFilter: ColorFilter.matrix(currentFilter.matrix),
//                             child: Image.memory(value.currentImage!,
//                             fit: BoxFit.fill,
//                             width: 40,
//                             height: 40),
//                           ),
//                        ),
//                       const Text("jjj", style: TextStyle(color: Colors.white),)
//                   ]
//                 )
//               ),
//             );
//         }
//     );
//   }
// }