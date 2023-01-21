import 'package:flutter/material.dart';
import 'package:scanner/screens/attached_images.dart';
import 'package:intl/intl.dart';
class PhotoCell extends StatelessWidget {
  final AttachedImageModel model;
  const PhotoCell({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                          placeholder: "assert/no_image.png",
                          image: model.patnImgPath.toString(),
                          fit: BoxFit.contain,
                          )),
                ),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      // DateFormat.yMMMd().format(DateTime.now()),
                      model.createdDate.toString(),
                        style: const TextStyle(color: Colors.black)))
              ],
            )),
      ),
    );
  }
}
