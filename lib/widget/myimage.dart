import 'package:flutter/material.dart';

class MyImage extends StatelessWidget {
  double height;
  double width;
  String? imagePath;
  String? imageUrl;
  // ignore: prefer_typing_uninitialized_variables
  var fit;
  // var alignment;

  MyImage(
      {Key? key,
      required this.width,
      required this.height,
       this.imagePath,
        this.imageUrl,
      // this.alignment,
      this.fit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imagePath!=null?Image.asset(
      imagePath!,
      height: height,
      width: width,
      fit: fit,
      // alignment: alignment,
    ): Image(image: NetworkImage(imageUrl!) , width: width , height: height,);


    CircleAvatar(
      backgroundImage: NetworkImage(imageUrl!),
      radius: 60,
    );
  }
}
