import 'package:flutter/material.dart';
import 'package:tbc_app/helper/mediaWidget.dart';

class MediaViewer extends StatelessWidget {
  final String mediaUrl =
      'https://www.example.com/media'; // Ganti dengan URL gambar atau video yang valid

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media Viewer'),
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: MediaWidget(mediaUrl: mediaUrl),
        ),
      ),
    );
  }
}
