import 'package:flutter/material.dart';

class ImageBanner extends StatelessWidget {
  final String _imagepath;

  ImageBanner(this._imagepath);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height: 150.0, width: 150.0),
      decoration: BoxDecoration(color: Colors.white),
      child: Image.asset(
        _imagepath,
        fit: BoxFit.fill,
      ),
    );
  }
}
