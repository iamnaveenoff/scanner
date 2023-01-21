import 'package:flutter/material.dart';
import 'package:scanner/screens/attached_images.dart';

class GridDetails extends StatefulWidget {
  final AttachedImageModel curAlbum;
  GridDetails({Key? key, required this.curAlbum}) : super(key: key);

  @override
  State<GridDetails> createState() => _GridDetailsState();
}

class _GridDetailsState extends State<GridDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeInImage.assetNetwork(
              placeholder: "assert/no_image.png",
              image: widget.curAlbum.patnImgPath.toString(),
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              child: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
