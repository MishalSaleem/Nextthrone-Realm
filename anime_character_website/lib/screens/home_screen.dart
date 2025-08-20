import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
// This import now works correctly

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _coreController;
  late AnimationController _panController;
  Offset _mousePosition = Offset.zero;
  bool _isButtonHovered = false;

  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  final AudioPlayer _clickPlayer = AudioPlayer();
  bool _isBackgroundMusicPlaying = false;

  @override
  void initState() {
    super.initState();
    _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
    _backgroundMusicPlayer.setVolume(0.4);
    // Removed _attemptImmediatePlay() to comply with autoplay restrictions

    _entryController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2500));
    _coreController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..repeat();
    _panController =
        AnimationController(vsync: this, duration: const Duration(seconds: 40))
          ..repeat(reverse: true);
    _entryController.forward();
  }

  Future<void> _ensureBackgroundMusicStarts() async {
    if (_isBackgroundMusicPlaying) return;
    try {
      await _backgroundMusicPlayer
          .play(AssetSource('audio/background_music.mp3'));
      _isBackgroundMusicPlaying = true;
    } catch (e) {
      // Optionally add a debug print or UI feedback here
      debugPrint('Failed to play background music: $e');
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
    _backgroundMusicPlayer.dispose();
    _clickPlayer.dispose();
    _entryController.dispose();
    _coreController.dispose();
    _panController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final parallaxX = (_mousePosition.dx / screenSize.width - 0.5) * 2;
    final parallaxY = (_mousePosition.dy / screenSize.height - 0.5) * 2;

    return Scaffold(
      backgroundColor: const Color(0xFF010409),
      body: MouseRegion(
        onHover: (event) =>
            setState(() => _mousePosition = event.localPosition),
        child: GestureDetector(
          onTap: () async {
            await _ensureBackgroundMusicStarts(); // Trigger music on first tap
          },
          behavior: HitTestBehavior.opaque,
          child: Stack(
            fit: StackFit.expand,
            children: [
              PulsingGlow(parallax: Offset(parallaxX, parallaxY)),
              AnimatedBuilder(
                animation: _panController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.15,
                    child: Transform.translate(
                      offset:
                          Offset(lerpDouble(-35, 35, _panController.value)!, 0),
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/BG2.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              InteractiveParticleField(mousePosition: _mousePosition),
              const ScanlineEffect(),
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(1.0),
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(60, 40, 60, 20),
                  child: Column(
                    children: [
                      _buildHeader(),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 2),
                            DecodeText('SELECT YOUR HERO',
                                animation: _entryController),
                            const SizedBox(height: 24),
                            FadeSlideTransition(
                              animation: CurvedAnimation(
                                  parent: _entryController,
                                  curve: const Interval(0.4, 1.0)),
                              child: Text(
                                'Each legend holds a unique power. A different story.\nChoose your path to victory.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.exo(
                                  color: Colors.white.withOpacity(
                                      0.7), // Same color as navbar options for consistency and readability
                                  fontSize: 24,
                                  fontWeight: FontWeight
                                      .w600, // Increased from w400 to w600 for better readability
                                  letterSpacing: 1.4,
                                  shadows: const [
                                    Shadow(
                                        color: Colors.black,
                                        blurRadius: 10.0,
                                        offset: Offset(0, 2)),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(flex: 2),
                            SizedBox(
                              width: 300,
                              height: 300,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  NexusCore(
                                      animation: _coreController,
                                      isHovered: _isButtonHovered,
                                      parallax: Offset(parallaxX, parallaxY)),
                                  FadeSlideTransition(
                                    animation: CurvedAnimation(
                                        parent: _entryController,
                                        curve: const Interval(0.6, 1.0)),
                                    child: CyberButton(
                                      text: 'ENTER SELECTION',
                                      onTap: () async {
                                        await _ensureBackgroundMusicStarts();
                                        await _playClickSound();
                                        if (mounted) {
                                          Navigator.pushNamed(
                                              context, '/characters');
                                        }
                                      },
                                      onHover: (isHovered) => setState(
                                          () => _isButtonHovered = isHovered),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(flex: 1),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeSlideTransition(
      animation: CurvedAnimation(
          parent: _entryController, curve: const Interval(0.0, 0.6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _navItem('Home', isHighlighted: true),
          _navItem('Profile'),
          _navItem('Leaderboard'),
          _navItem('Settings'),
        ],
      ),
    );
  }

  Widget _navItem(String text, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Text(
        text,
        style: GoogleFonts.exo(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color:
              isHighlighted ? Colors.cyanAccent : Colors.white.withOpacity(0.7),
          shadows: [
            const Shadow(
                color: Colors.black, blurRadius: 8, offset: Offset(0, 2)),
            if (isHighlighted)
              const Shadow(color: Colors.cyanAccent, blurRadius: 10)
          ],
        ),
      ),
    );
  }
}

class PulsingGlow extends StatefulWidget {
  final Offset parallax;
  const PulsingGlow({super.key, required this.parallax});

  @override
  State<PulsingGlow> createState() => _PulsingGlowState();
}

class _PulsingGlowState extends State<PulsingGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(widget.parallax.dx * 15, widget.parallax.dy * 15),
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return CustomPaint(
            size: Size.infinite,
            painter: GlowPainter(_glowController.value),
          );
        },
      ),
    );
  }
}

class GlowPainter extends CustomPainter {
  final double progress;
  GlowPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.45);
    final radius = size.width * (0.3 + (progress * 0.1));
    final opacity = 0.2 + (progress * 0.3);

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.cyan.withOpacity(opacity),
          Colors.cyan.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant GlowPainter oldDelegate) => true;
}

class InteractiveParticleField extends StatefulWidget {
  final Offset mousePosition;
  const InteractiveParticleField({super.key, required this.mousePosition});

  @override
  State<InteractiveParticleField> createState() =>
      _InteractiveParticleFieldState();
}

class _InteractiveParticleFieldState extends State<InteractiveParticleField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<FollowingParticle> particles;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenSize = MediaQuery.of(context).size;
    particles = List.generate(200, (index) => FollowingParticle(screenSize));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (final particle in particles) {
          particle.update(widget.mousePosition);
        }
        return CustomPaint(
          size: Size.infinite,
          painter: FollowingParticlePainter(particles),
        );
      },
    );
  }
}

class FollowingParticlePainter extends CustomPainter {
  final List<FollowingParticle> particles;
  FollowingParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final particle in particles) {
      paint.color = Colors.white.withOpacity(particle.opacity);
      canvas.drawCircle(particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant FollowingParticlePainter oldDelegate) => true;
}

class FollowingParticle {
  Offset position;
  double size;
  double opacity;
  double speed;
  final Size screenSize;
  final Random _random;

  FollowingParticle(this.screenSize)
      : position = Offset.zero,
        size = 0,
        opacity = 0,
        speed = 0,
        _random = Random() {
    _reset();
  }

  void _reset() {
    position = Offset(_random.nextDouble() * screenSize.width,
        _random.nextDouble() * screenSize.height);
    size = _random.nextDouble() * 1.5 + 0.5;
    opacity = _random.nextDouble() * 0.7 + 0.1;
    speed = _random.nextDouble() * 0.04 + 0.02;
  }

  void update(Offset target) {
    if (target == Offset.zero) {
      position = Offset(
        (position.dx + (_random.nextDouble() - 0.5) * 2) % screenSize.width,
        (position.dy + (_random.nextDouble() - 0.5) * 2) % screenSize.height,
      );
      return;
    }
    position = Offset.lerp(position, target, speed)!;
    final distance = (position - target).distance;
    opacity = (1 - (distance / 300)).clamp(0.0, 1.0) * 0.8;
  }
}

class NexusCore extends StatelessWidget {
  final Animation<double> animation;
  final bool isHovered;
  final Offset parallax;

  const NexusCore(
      {super.key,
      required this.animation,
      required this.isHovered,
      required this.parallax});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(parallax.dy * 0.2)
            ..rotateY(parallax.dx * 0.2),
          alignment: Alignment.center,
          child: CustomPaint(
            size: const Size.square(300),
            painter: NexusCorePainter(animation.value, isHovered),
          ),
        );
      },
    );
  }
}

class NexusCorePainter extends CustomPainter {
  final double progress;
  final bool isHovered;

  NexusCorePainter(this.progress, this.isHovered);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect =
        Rect.fromCenter(center: center, width: size.width, height: size.height);

    final hoverProgress = isHovered ? 1.0 : 0.0;
    final pulse = sin(progress * 2 * pi * 4) * 0.02 + 1.0;

    void drawRing(double radius, double stroke, Color color, double rotation) {
      final paint = Paint()
        ..color = color
        ..strokeWidth = stroke * pulse
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect.inflate(-radius), rotation, pi * 1.5, false, paint);
    }

    void drawGlow(double radius, double blur, Color color) {
      final paint = Paint()
        ..color = color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);
      canvas.drawCircle(center, radius, paint);
    }

    drawGlow(140, lerpDouble(15, 40, hoverProgress)!,
        Colors.cyan.withOpacity(lerpDouble(0.1, 0.4, hoverProgress)!));

    drawRing(30, 1.5, Colors.cyan.withOpacity(0.5), progress * 2 * pi);
    drawRing(60, 2.0, Colors.cyanAccent.withOpacity(0.7), -progress * pi * 1.5);
    drawRing(90, 2.5, Colors.white.withOpacity(0.8), progress * pi);
    drawRing(120, 3.0, Colors.cyan.withOpacity(0.6), -progress * pi * 0.5);
  }

  @override
  bool shouldRepaint(covariant NexusCorePainter oldDelegate) =>
      progress != oldDelegate.progress || isHovered != oldDelegate.isHovered;
}

class DecodeText extends StatelessWidget {
  final String text;
  final Animation<double> animation;
  final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789<>*&^%!@#';

  DecodeText(this.text, {super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        String displayText = '';
        final random = Random(1);
        final progress = (animation.value * text.length).ceil();

        for (int i = 0; i < text.length; i++) {
          if (text[i] == ' ') {
            displayText += ' ';
          } else if (i < progress) {
            displayText += text[i];
          } else {
            displayText += chars[random.nextInt(chars.length)];
          }
        }

        return Text(
          displayText,
          textAlign: TextAlign.center,
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontSize: 76,
            fontWeight: FontWeight.w900,
            letterSpacing: 6,
            shadows: [
              const Shadow(color: Colors.cyanAccent, blurRadius: 25),
              Shadow(
                  color: Colors.cyan.withOpacity(0.8),
                  blurRadius: 45,
                  offset: const Offset(0, 5)),
            ],
          ),
        );
      },
    );
  }
}

class CyberButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Function(bool) onHover;

  const CyberButton(
      {super.key,
      required this.text,
      required this.onTap,
      required this.onHover});

  @override
  State<CyberButton> createState() => _CyberButtonState();
}

class _CyberButtonState extends State<CyberButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        widget.onHover(true);
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        widget.onHover(false);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.cyan.withOpacity(_isHovered ? 0.25 : 0.1),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
                color: Colors.cyanAccent.withOpacity(_isHovered ? 1.0 : 0.5),
                width: 2),
            boxShadow: [
              BoxShadow(
                  color: Colors.cyanAccent.withOpacity(_isHovered ? 0.6 : 0.0),
                  blurRadius: 25,
                  spreadRadius: 2),
            ],
          ),
          child: Text(
            widget.text,
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class ScanlineEffect extends StatefulWidget {
  const ScanlineEffect({super.key});

  @override
  State<ScanlineEffect> createState() => _ScanlineEffectState();
}

class _ScanlineEffectState extends State<ScanlineEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => CustomPaint(
        size: Size.infinite,
        painter: ScanlinePainter(_controller.value),
      ),
    );
  }
}

class ScanlinePainter extends CustomPainter {
  final double progress;
  ScanlinePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (double i = 0; i < size.height; i += 4) {
      paint.color = Colors.black.withOpacity(0.1);
      canvas.drawRect(Rect.fromLTWH(0, i, size.width, 1), paint);
    }

    final glarePaint = Paint()
      ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.0),
          ],
          stops: const [
            0.0,
            0.5,
            1.0
          ]).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.2));

    final y = progress * size.height * 1.5 - (size.height * 0.5);
    canvas.drawRect(
        Rect.fromLTWH(0, y, size.width, size.height * 0.2), glarePaint);
  }

  @override
  bool shouldRepaint(covariant ScanlinePainter oldDelegate) =>
      progress != oldDelegate.progress;
}

class FadeSlideTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const FadeSlideTransition(
      {super.key, required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(0, (1 - animation.value) * 30),
          child: child,
        ),
      ),
    );
  }
}
