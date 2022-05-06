import 'package:flutter/material.dart';

class ImageRond extends StatefulWidget{
  String? image;
  double? size;
  ImageRond({required this.image, this.size});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ImageRondState();
  }

}

class ImageRondState extends State<ImageRond>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return bodyPage();
  }

  Widget bodyPage(){
    return Container(
      height: widget.size ?? 40,
      width: widget.size ?? 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: (widget.image == null)?const NetworkImage("https://firebasestorage.googleapis.com/v0/b/ms-haine.appspot.com/o/anonyme-300x189.jpg?alt=media&token=78c6f6b7-e16a-4f63-bcf1-8b3a63ad9bfd"):NetworkImage(widget.image!),
          fit: BoxFit.fill
        )
      ),
    );
  }


}