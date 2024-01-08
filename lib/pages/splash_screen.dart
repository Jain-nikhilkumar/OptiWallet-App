import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(
      'assets/OptiWallet.mp4', // Replace with your video asset path
    )..initialize().then((_) {
      setState(() {
        _videoController.play();
      });
    });
    // Use Future.delayed to navigate to the login page after a specified duration
    Future.delayed(const Duration(seconds: 6), () {
      // Replace '/login' with the actual route for your login page
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _videoController.value.isInitialized
            ? AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: VideoPlayer(_videoController),
        )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
