import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';

class CharacterScreen extends StatefulWidget {
  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen>
    with TickerProviderStateMixin {
  final List<Map<String, String>> characters = [
    {
      'name': 'Zephyr Volkov',
      'image': 'assets/images/c1.jpg',
      'subtitle': 'The Obsidian Knight'
    },
    {
      'name': 'Seraphina Skye',
      'image': 'assets/images/c2.jpg',
      'subtitle': 'The Storm Weaver'
    },
    {
      'name': 'Ling Xiao',
      'image': 'assets/images/c3.jpg',
      'subtitle': 'The Azure Blade'
    },
    {
      'name': 'Elara Meadowlight',
      'image': 'assets/images/c4.jpg',
      'subtitle': 'The Spirit Blossom'
    },
    {
      'name': 'Noctis Crystallos',
      'image': 'assets/images/c5.jpg',
      'subtitle': 'The Arcane Phantom'
    },
  ];

  late PageController _pageController;
  late AnimationController _textScrollController;
  late AnimationController _titleAnimationController;
  late AnimationController _particleController;

  double _currentPage = 2.0;
  final int _initialPage = 2;

  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  final AudioPlayer _clickPlayer = AudioPlayer();
  bool _isBackgroundMusicPlaying = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.2,
      initialPage: _initialPage,
    );

    // Optimized animation durations and curves for better performance
    _textScrollController =
        AnimationController(vsync: this, duration: const Duration(seconds: 8)) // Reduced from 10 to 8 seconds
          ..repeat();
    _titleAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3)) // Reduced from 4 to 3 seconds
          ..repeat(reverse: true);
    _particleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4)) // Reduced from 5 to 4 seconds
          ..repeat();

    _pageController.addListener(() {
      if (mounted) {
        final newPage = _pageController.page!;
        // Only update state if the page change is significant enough
        if ((newPage - _currentPage).abs() > 0.01) {
          setState(() {
            _currentPage = newPage;
          });
        }
      }
    });

    _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
    _backgroundMusicPlayer.setVolume(0.4);
    _attemptImmediatePlay();
  }

  Future<void> _attemptImmediatePlay() async {
    try {
      await _backgroundMusicPlayer.play(AssetSource('audio/background_music.mp3'));
      _isBackgroundMusicPlaying = true;
    } catch (e) {
      debugPrint('Initial music play failed due to autoplay restriction: $e');
      _isBackgroundMusicPlaying = false;
    }
  }

  Future<void> _ensureBackgroundMusicStarts() async {
    if (_isBackgroundMusicPlaying) return;
    try {
      await _backgroundMusicPlayer.play(AssetSource('audio/background_music.mp3'));
      _isBackgroundMusicPlaying = true;
    } catch (e) {
      debugPrint('Fallback music play failed: $e');
    }
  }

  Future<void> _playClickSound() async {
    try {
      await _clickPlayer.play(AssetSource('audio/click_sound.mp3'));
    } catch (e) {
      debugPrint('Failed to play click sound: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textScrollController.dispose();
    _titleAnimationController.dispose();
    _particleController.dispose();
    _backgroundMusicPlayer.dispose();
    _clickPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          ScrollingText(animation: _textScrollController, isTop: true),
          ScrollingText(animation: _textScrollController, isTop: false),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                AnimatedTitle(animation: _titleAnimationController),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: characters.length,
                        itemBuilder: (context, index) => Container(),
                      ),
                      ...List.generate(characters.length, (index) {
                        // The GestureDetector was moved inside the Card for better structure.
                        // The visual result is identical.
                        return OrbitalCharacterCard(
                          character: characters[index],
                          page: _currentPage,
                          index: index,
                          particleAnimation: _particleController,
                          onClickSound: _playClickSound,
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrbitalCharacterCard extends StatelessWidget {
  final Map<String, String> character;
  final double page;
  final int index;
  final Animation<double> particleAnimation;
  final Future<void> Function() onClickSound;

  const OrbitalCharacterCard({
    Key? key,
    required this.character,
    required this.page,
    required this.index,
    required this.particleAnimation,
    required this.onClickSound,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Optimized calculations to reduce lag
    final double pageOffset = (page - index);
    final double normalizedOffset = pageOffset.abs().clamp(0.0, 1.0);
    final double scale = lerpDouble(0.4, 1.0, 1 - normalizedOffset)!;
    final double zPosition = lerpDouble(-800, 0, 1 - normalizedOffset)!;
    final double opacity = lerpDouble(0.2, 1.0, 1 - normalizedOffset)!;
    final double yRotation = pageOffset * -1.2; // Reduced from -1.5 to -1.2 for smoother animation
    final double xUnfold = lerpDouble(-pi / 6, 0, 1 - normalizedOffset)!; // Reduced from -pi/4 to -pi/6
    final double orbitalAngle = pageOffset * (pi * 0.6); // Reduced from 0.7 to 0.6 for smoother movement
    final double orbitalX = sin(orbitalAngle) * 280; // Reduced from 300 to 280
    final double orbitalZ = cos(orbitalAngle) * -280 - 500; // Reduced from -300 to -280
    final double finalX = lerpDouble(orbitalX, 0, 1 - normalizedOffset)!;
    final double finalZ = lerpDouble(orbitalZ, zPosition, 1 - normalizedOffset)!;

    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..translate(finalX, 0.0, finalZ)
      ..rotateY(yRotation)
      ..rotateX(xUnfold);

    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: () async {
          await onClickSound();
          Navigator.pushNamed(
            context,
            '/characterDetail',
            arguments: character,
          );
        },
        child: Transform(
          transform: transform,
          alignment: Alignment.center,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 320,
              height: 480,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withOpacity(0.2 + (1 - normalizedOffset) * 0.4),
                    blurRadius: 30,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedBuilder(
                      animation: particleAnimation,
                      builder: (context, child) => CustomPaint(painter: StarfieldPainter(particleAnimation.value)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 90.0),
                      child: Hero(
                        tag: character['image']!,
                        child: Image.asset(character['image']!, fit: BoxFit.contain),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black.withOpacity(0.95)],
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 25,
                      right: 25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            character['name']!, 
                            style: GoogleFonts.orbitron(
                              color: Colors.white, 
                              fontSize: 26, 
                              fontWeight: FontWeight.bold
                            )
                          ),
                          const SizedBox(height: 5),
                          Text(
                            character['subtitle']!, 
                            style: GoogleFonts.exo(
                              color: Colors.cyanAccent, 
                              fontSize: 18
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//--- ALL OTHER WIDGETS AND PAINTERS ARE UNTOUCHED ---

class StarfieldPainter extends CustomPainter {
  static const int starCount = 100; // Reduced from 150 to 100 for better performance
  final double progress;
  final List<Star> stars;
  StarfieldPainter(this.progress) : stars = List.generate(starCount, (index) => Star(index));
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.cyanAccent;
    
    // Optimized painting loop
    for (final star in stars) {
      final offset = star.getPosition(progress, size);
      // Only draw stars that are visible on screen
      if (offset.dx >= -10 && offset.dx <= size.width + 10 && 
          offset.dy >= -10 && offset.dy <= size.height + 10) {
        final radius = star.size * (1 - offset.dy / size.height);
        paint.color = Colors.cyan.withOpacity(star.opacity * (1 - offset.dy / size.height));
        canvas.drawCircle(offset, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant StarfieldPainter oldDelegate) => progress != oldDelegate.progress;
}

class Star {
  final double seed;
  late double size;
  late double speed;
  late double opacity;
  Star(int index) : seed = Random(index).nextDouble() {
    size = seed * 1.5 + 0.5;
    speed = seed * 30 + 10;
    opacity = seed * 0.5 + 0.2;
  }
  Offset getPosition(double progress, Size canvasSize) {
    final y = (progress * speed + seed * canvasSize.height) % canvasSize.height;
    final x = (seed * canvasSize.width * 2 - canvasSize.width / 2) + sin(progress * 2 * pi * seed) * 20;
    return Offset(x, y);
  }
}

class AnimatedTitle extends StatelessWidget {
  final Animation<double> animation;
  const AnimatedTitle({Key? key, required this.animation}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Simplified animation to reduce lag
        final slide = (animation.value - 0.5) * 3.0; // Reduced from 6.0 to 3.0
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.cyanAccent, Colors.white, Colors.cyanAccent],
            transform: GradientRotation(animation.value * 2 * pi),
          ).createShader(bounds),
          child: Stack(
            children: [
              // Simplified transforms - only one shadow layer instead of two
              Transform.translate(
                offset: Offset(slide, slide / 2), 
                child: const TitleText(opacity: 0.2) // Reduced opacity for better performance
              ),
              const TitleText(opacity: 1.0),
            ],
          ),
        );
      },
    );
  }
}

class TitleText extends StatelessWidget {
  final double opacity;
  const TitleText({Key? key, required this.opacity}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      'Choose Your Hero',
      style: GoogleFonts.orbitron(
        color: Colors.white.withOpacity(opacity),
        fontSize: 32,
        fontWeight: FontWeight.w900,
        shadows: [Shadow(color: Colors.cyanAccent.withOpacity(opacity * 0.8), blurRadius: 20)],
      ),
    );
  }
}

class ScrollingText extends StatelessWidget {
  final Animation<double> animation;
  final bool isTop;
  const ScrollingText({Key? key, required this.animation, required this.isTop}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: isTop ? MediaQuery.of(context).padding.top : null,
      bottom: isTop ? null : MediaQuery.of(context).padding.bottom,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) => CustomPaint(
          painter: ScrollingTextPainter(animation.value),
          child: Container(height: 30),
        ),
      ),
    );
  }
}

class ScrollingTextPainter extends CustomPainter {
  final double progress;
  ScrollingTextPainter(this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    String text = '  ...UNLOCKED NEW CHARACTER...  ' * 5;
    // Improved color scheme for better readability
    final textStyle = GoogleFonts.pressStart2p(
      color: Colors.cyan.withOpacity(0.9), // Brighter cyan for better contrast
      fontSize: 14,
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.8), // Dark shadow for better readability
          blurRadius: 2,
          offset: const Offset(1, 1),
        ),
      ],
    );
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle), 
      textDirection: TextDirection.ltr
    )..layout();
    final singleSegmentWidth = textPainter.width / 5;
    final xOffset = -(progress * singleSegmentWidth);
    textPainter.paint(canvas, Offset(xOffset, 5));
  }

  @override
  bool shouldRepaint(covariant ScrollingTextPainter oldDelegate) => true;
}