import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:radioapp/screens/home_screen.dart';

void main() {
  runApp(const MaterialApp(home: InitializingScreen()));
}

class InitializingScreen extends StatefulWidget {
  const InitializingScreen({super.key});

  @override
  State<InitializingScreen> createState() => _InitializingScreenState();
}

class _InitializingScreenState extends State<InitializingScreen> {
  AudioPlayer player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(player: player);
  }
}
