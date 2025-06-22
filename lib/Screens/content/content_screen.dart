import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ContentScreen extends StatefulWidget {
  final String videoUrl; // Full YouTube URL

  const ContentScreen({super.key, required this.videoUrl});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
          isLive: false,
          forceHD: true,
        ),
      );
    } else {
      throw Exception("Invalid YouTube URL");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        onReady: () {
          debugPrint("Player is ready.");
        },
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Session Video"),
            backgroundColor: Colors.white,
            elevation: 4,
            centerTitle: true,
          ),
          backgroundColor: Colors.grey[100],
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 15,
                child: player,
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor:  Color(0xFF6E5DE7),
            onPressed: () {
              _controller.toggleFullScreenMode();
            },
            child: const Icon(Icons.fullscreen,color: Colors.white,),
          ),
        );
      },
    );
  }
}
