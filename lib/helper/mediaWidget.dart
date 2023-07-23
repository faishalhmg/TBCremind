import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaWidget extends StatelessWidget {
  final String mediaUrl;

  MediaWidget({required this.mediaUrl});

  @override
  Widget build(BuildContext context) {
    if (mediaUrl.endsWith('.mp4')) {
      // Jika link berakhir dengan '.mp4', kita anggap itu adalah video
      return Chewie(
        controller: ChewieController(
          videoPlayerController: VideoPlayerController.network(mediaUrl),
          autoPlay: true,
          looping: true,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      );
    } else {
      // Jika bukan video, kita anggap itu adalah gambar
      return CachedNetworkImage(
        imageUrl: mediaUrl,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }
  }
}
