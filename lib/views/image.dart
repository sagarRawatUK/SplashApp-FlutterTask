import 'package:SplashApp/constants/widgets.dart';
import 'package:flutter/material.dart';

class ImagePage extends StatefulWidget {
  String imgPath;
  ImagePage(this.imgPath);
  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
      ),
      body: SizedBox.expand(
        child: Container(
          color: mainColor,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Hero(
                    tag: widget.imgPath, child: Image.network(widget.imgPath)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
