import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

// Ensure file paths are correct
import 'screens/home_screen.dart';
import 'screens/character_screen.dart';
import 'screens/character_detail_screen.dart';

void main() {
  // Initialize Flutter bindings for plugins
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RootApp());
}

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> with WidgetsBindingObserver {
  late final AudioPlayer _backgroundMusicPlayer;

  @override
  void initState() {
    super.initState();
    _backgroundMusicPlayer = AudioPlayer();
    _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
    _backgroundMusicPlayer.setVolume(0.4);

    // Play background music on app start
    _playMusic();

    // Add lifecycle observer
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _playMusic() async {
    try {
      await _backgroundMusicPlayer.play(AssetSource('audio/background_music.mp3'));
    } catch (e) {
      // Log error for debugging (instead of silently failing)
      debugPrint('Error playing background music: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _backgroundMusicPlayer.pause();
    } else if (state == AppLifecycleState.resumed) {
      _backgroundMusicPlayer.resume();
    }
  }

  @override
  void dispose() {
    _backgroundMusicPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orbital Nexus',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/characters': (context) => CharacterScreen(), // Made const for consistency
        '/characterDetail': (context) => const CharacterDetailScreen(),
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.orbitron(fontWeight: FontWeight.bold),
          bodyMedium: GoogleFonts.exo(fontSize: 16),
        ),
      ),
    );
  }
}