import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'dart:ui' as ui;

// === EXPANDED DATA REPOSITORY ===
final Map<String, Map<String, dynamic>> characterDetails = {
  'Zephyr Volkov': {
    'art': 'assets/images/c1.jpg',
    'lore': {
      'title': 'The Obsidian Knight',
      'text':
          'Once a noble knight, Zephyr made a pact with a shadow entity to gain immense power. Now bound to the darkness, his armor is both a prison and his greatest strength.'
    },
    'abilities': [
      {
        'name': 'Void Slash',
        'desc': 'Tears a temporary rift in reality, dealing shadow damage.'
      },
      {
        'name': 'Soul Siphon',
        'desc':
            'Impales a target, healing Zephyr for a portion of the damage dealt.'
      },
    ],
    'stats': {'Power': 90.0, 'Defense': 80.0, 'Speed': 50.0},
    'hotspots': {
      'lore': const Rect.fromLTWH(0.35, 0.1, 0.3, 0.25),
      'abilities': const Rect.fromLTWH(0.45, 0.4, 0.35, 0.3),
      'stats': const Rect.fromLTWH(0.35, 0.3, 0.3, 0.25),
    }
  },
  'Seraphina Skye': {
    'art': 'assets/images/c2.jpg',
    'lore': {
      'title': 'The Storm Weaver',
      'text':
          'Born atop Mount Caelus, Seraphina is a living conduit for the storm. She commands the sky, moving with the speed of lightning and striking with the fury of a hurricane.'
    },
    'abilities': [
      {
        'name': 'Lightning Dash',
        'desc': 'Teleports in a bolt of lightning, striking all in her path.'
      },
      {
        'name': 'Eye of the Storm',
        'desc':
            'Creates a swirling vortex of energy that damages and pulls in foes.'
      },
    ],
    'stats': {'Power': 85.0, 'Defense': 60.0, 'Speed': 100.0},
    'hotspots': {
      'lore': const Rect.fromLTWH(0.35, 0.1, 0.3, 0.25),
      'abilities': const Rect.fromLTWH(0.5, 0.4, 0.35, 0.3),
      'stats': const Rect.fromLTWH(0.35, 0.35, 0.3, 0.2),
    }
  },
  'Ling Xiao': {
    'art': 'assets/images/c3.jpg',
    'lore': {
      'title': 'The Azure Blade',
      'text':
          'A wandering swordsman from the Mist-Valley. His movements are like a dance, flowing and unpredictable. He seeks the perfect duel for the clarity it brings to his restless soul.'
    },
    'abilities': [
      {
        'name': 'Gale Strike',
        'desc': 'A rapid flurry of seven strikes, each faster than the last.'
      },
      {
        'name': 'Azure Tempest',
        'desc': 'A spinning blade dance that creates a razor-sharp whirlwind.'
      },
    ],
    'stats': {'Power': 95.0, 'Defense': 40.0, 'Speed': 95.0},
    'hotspots': {
      'lore': const Rect.fromLTWH(0.35, 0.15, 0.3, 0.25),
      'abilities': const Rect.fromLTWH(0.5, 0.4, 0.35, 0.3),
      'stats': const Rect.fromLTWH(0.3, 0.4, 0.3, 0.25),
    }
  },
  'Elara Meadowlight': {
    'art': 'assets/images/c4.jpg',
    'lore': {
      'title': 'The Spirit Blossom',
      'text':
          'A guardian of the ancient Lumina Grove, attuned to the life force of nature itself. Her power is beautiful, nurturing, and devastatingly wild when provoked.'
    },
    'abilities': [
      {
        'name': 'Petal Dance',
        'desc':
            'Unleashes a storm of razor-sharp petals that slice through armor.'
      },
      {
        'name': 'Sunpetal Ward',
        'desc':
            'Summons a blossom that heals allies and shields them from harm.'
      },
    ],
    'stats': {'Power': 70.0, 'Defense': 75.0, 'Speed': 60.0},
    'hotspots': {
      'lore': const Rect.fromLTWH(0.35, 0.1, 0.3, 0.25),
      'abilities': const Rect.fromLTWH(0.1, 0.3, 0.35, 0.3),
      'stats': const Rect.fromLTWH(0.35, 0.4, 0.3, 0.2),
    }
  },
  'Noctis Crystallos': {
    'art': 'assets/images/c5.jpg',
    'lore': {
      'title': 'The Arcane Phantom',
      'text':
          'A being of pure magic given form by the sentient crystals of a fallen star. His armor of solidified mana refracts light into deadly beams of arcane energy.'
    },
    'abilities': [
      {
        'name': 'Crystal Shards',
        'desc': 'Launches a volley of homing crystalline projectiles.'
      },
      {
        'name': 'Prismatic Beam',
        'desc':
            'Channels a devastating beam of pure energy that grows over time.'
      },
    ],
    'stats': {'Power': 100.0, 'Defense': 50.0, 'Speed': 70.0},
    'hotspots': {
      'lore': const Rect.fromLTWH(0.35, 0.15, 0.3, 0.2),
      'abilities': const Rect.fromLTWH(0.5, 0.3, 0.3, 0.3),
      'stats': const Rect.fromLTWH(0.35, 0.4, 0.3, 0.2),
    }
  },
};

// === GLOBAL STATE NOTIFIERS ===
final mousePositionNotifier = ValueNotifier<Offset>(Offset.zero);
final hoveredSectionNotifier = ValueNotifier<String>('lore');
final targetWidgetKeyNotifier = ValueNotifier<GlobalKey?>(null);
final parallaxIntensityNotifier = ValueNotifier<double>(0.0);

// === MAIN SCREEN WITH CINEMATIC EFFECTS ===
class CharacterDetailScreen extends StatefulWidget {
  const CharacterDetailScreen({Key? key}) : super(key: key);
  @override
  _CharacterDetailScreenState createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _scanlineController;
  late AnimationController _kenBurnsController;
  late AnimationController _pulseController;
  late AnimationController _matrixController;
  late AnimationController _particleController;
  late AnimationController _hologramController;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _scanlineController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat();
    _kenBurnsController =
        AnimationController(vsync: this, duration: const Duration(seconds: 25))
          ..repeat(reverse: true);
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);
    _matrixController =
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..repeat();
    _particleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 15))
          ..repeat();
    _hologramController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000))
      ..repeat(reverse: true);

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _scanlineController.dispose();
    _kenBurnsController.dispose();
    _pulseController.dispose();
    _matrixController.dispose();
    _particleController.dispose();
    _hologramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final characterData =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final details = characterDetails[characterData['name']]!;

    return Scaffold(
      backgroundColor: const Color(0xff000000),
      body: Listener(
        onPointerMove: (event) {
          mousePositionNotifier.value = event.localPosition;
          final screenSize = MediaQuery.of(context).size;
          final normalizedX =
              (event.localPosition.dx / screenSize.width - 0.5) * 2;
          final normalizedY =
              (event.localPosition.dy / screenSize.height - 0.5) * 2;
          parallaxIntensityNotifier.value =
              sqrt(normalizedX * normalizedX + normalizedY * normalizedY);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // === CINEMATIC BACKGROUND LAYERS ===
            CinematicBackground(
              characterArt: details['art'],
              kenBurnsAnimation: _kenBurnsController,
            ),

            // Matrix Digital Rain
            CustomPaint(
                painter: MatrixRainPainter(animation: _matrixController)),

            // Floating Particles
            CustomPaint(
                painter:
                    FloatingParticlesPainter(animation: _particleController)),

            // Advanced Grid System
            CustomPaint(
                painter: AdvancedGridPainter(pulseAnimation: _pulseController)),

            // Multiple Scanlines
            CustomPaint(
                painter:
                    MultipleScanlinesPainter(animation: _scanlineController)),

            // === INTERACTIVE CHARACTER ===
            Transform3DCharacterView(
              details: details,
              entryAnimation: _entryController,
              hologramAnimation: _hologramController,
            ),

            // === DATA STREAMS ===
            CinematicDataStream(
              details: details,
              entryAnimation: _entryController,
              pulseAnimation: _pulseController,
            ),

            // === UI OVERLAYS ===
            // Floating Title with 3D Effect
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedBuilder(
                  animation: _entryController,
                  builder: (context, child) {
                    final slideOffset = Tween<Offset>(
                      begin: const Offset(0, -1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _entryController,
                      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
                    ));

                    return SlideTransition(
                      position: slideOffset,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.002)
                          ..rotateX(0.1 * _pulseController.value)
                          ..rotateY(
                              0.05 * sin(_pulseController.value * 2 * pi)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                Colors.cyan.withOpacity(0.2),
                                Colors.blue.withOpacity(0.1),
                                Colors.purple.withOpacity(0.2),
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ),
                            border: Border.all(
                                color: Colors.cyan.withOpacity(0.5), width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyan.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Text(
                            "◊ NEURAL INTERFACE ◊",
                            style: GoogleFonts.orbitron(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 6,
                              shadows: [
                                Shadow(
                                    color: Colors.cyan,
                                    blurRadius: 8,
                                    offset: Offset(0, 0)),
                                Shadow(
                                    color: Colors.blue,
                                    blurRadius: 16,
                                    offset: Offset(2, 2)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Enhanced Back Button
            Positioned(
              top: 50,
              right: 50,
              child: AnimatedBuilder(
                animation: _entryController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _entryController,
                      curve: const Interval(0.8, 1.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.cyan.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                        border: Border.all(color: Colors.cyan.withOpacity(0.5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close,
                            color: Colors.white, size: 24),
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Status Indicators
            Positioned(
              top: 50,
              left: 50,
              child: AnimatedBuilder(
                animation: _entryController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _entryController,
                      curve: const Interval(0.7, 1.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StatusIndicator(
                            "NEURAL LINK", Colors.green, _pulseController),
                        const SizedBox(height: 8),
                        _StatusIndicator(
                            "SCANNING", Colors.cyan, _pulseController),
                        const SizedBox(height: 8),
                        _StatusIndicator(
                            "ANALYZING", Colors.orange, _pulseController),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// === ENHANCED BACKGROUND WITH DEPTH ===
class CinematicBackground extends StatelessWidget {
  final String characterArt;
  final Animation<double> kenBurnsAnimation;

  const CinematicBackground({
    Key? key,
    required this.characterArt,
    required this.kenBurnsAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Offset>(
      valueListenable: mousePositionNotifier,
      builder: (context, mousePos, child) {
        final screenSize = MediaQuery.of(context).size;
        final parallaxX = (0.5 - mousePos.dx / screenSize.width) * 60;
        final parallaxY = (0.5 - mousePos.dy / screenSize.height) * 40;

        return AnimatedBuilder(
          animation: kenBurnsAnimation,
          builder: (context, child) {
            final scale = 1.3 + 0.1 * kenBurnsAnimation.value;
            final rotation = 0.02 * sin(kenBurnsAnimation.value * pi);

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateZ(rotation)
                ..scale(scale),
              child: Transform.translate(
                offset: Offset(parallaxX, parallaxY),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Main background image
                    Image.asset(
                      characterArt,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),

                    // Multiple blur and color overlay layers for depth
                    BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.blue.withOpacity(0.3),
                              Colors.purple.withOpacity(0.4),
                              Colors.black.withOpacity(0.8),
                            ],
                            stops: [0.0, 0.3, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Vignette effect
                    Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 1.2,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.8),
                          ],
                          stops: [0.0, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// === ADVANCED 3D CHARACTER VIEW ===
class Transform3DCharacterView extends StatelessWidget {
  final Map<String, dynamic> details;
  final Animation<double> entryAnimation;
  final Animation<double> hologramAnimation;

  const Transform3DCharacterView({
    Key? key,
    required this.details,
    required this.entryAnimation,
    required this.hologramAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Center the character image with better proportions
        final imageWidth = constraints.maxWidth * 0.4;
        final imageHeight = constraints.maxHeight * 0.8;
        final imageOffset =
            Offset(constraints.maxWidth * 0.55, constraints.maxHeight * 0.1);

        final scaledHotspots = (details['hotspots'] as Map<String, Rect>)
            .map((key, rect) => MapEntry(
                key,
                Rect.fromLTWH(
                  imageOffset.dx + rect.left * imageWidth,
                  imageOffset.dy + rect.top * imageHeight,
                  rect.width * imageWidth,
                  rect.height * imageHeight,
                )));

        return Stack(
          children: [
            // Advanced Data Weave System
            CustomPaint(
              painter: AdvancedDataWeavePainter(
                mousePosition: mousePositionNotifier,
                hoveredSection: hoveredSectionNotifier,
                targetKey: targetWidgetKeyNotifier,
                hotspots: scaledHotspots,
                pulseAnimation: hologramAnimation,
              ),
              size: Size.infinite,
            ),

            // 3D Character Image with Hologram Effect
            Positioned(
              left: imageOffset.dx,
              top: imageOffset.dy,
              width: imageWidth,
              height: imageHeight,
              child: ValueListenableBuilder<Offset>(
                valueListenable: mousePositionNotifier,
                builder: (context, mousePos, child) {
                  final screenSize = MediaQuery.of(context).size;
                  final tiltX = (mousePos.dy / screenSize.height - 0.5) * 0.3;
                  final tiltY = (0.5 - mousePos.dx / screenSize.width) * 0.3;

                  return AnimatedBuilder(
                    animation: entryAnimation,
                    builder: (context, child) {
                      final slideOffset = Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: entryAnimation,
                        curve:
                            const Interval(0.4, 1.0, curve: Curves.elasticOut),
                      ));

                      return SlideTransition(
                        position: slideOffset,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.003)
                            ..rotateX(tiltX)
                            ..rotateY(tiltY)
                            ..scale(1.0 + 0.05 * hologramAnimation.value),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Character image with hologram effect
                              Hero(
                                tag: details['art'],
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.cyan.withOpacity(0.5),
                                        blurRadius: 30,
                                        spreadRadius: 5,
                                      ),
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.3),
                                        blurRadius: 60,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.asset(
                                          details['art'],
                                          fit: BoxFit.cover,
                                          alignment: Alignment.topCenter,
                                        ),
                                        // Hologram scanline effect
                                        AnimatedBuilder(
                                          animation: hologramAnimation,
                                          builder: (context, child) {
                                            return CustomPaint(
                                              painter: HologramScanPainter(
                                                progress:
                                                    hologramAnimation.value,
                                              ),
                                              size: Size.infinite,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Glitch effect border
                              AnimatedBuilder(
                                animation: hologramAnimation,
                                builder: (context, child) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.cyan.withOpacity(0.3 +
                                            0.4 * hologramAnimation.value),
                                        width: 2,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Enhanced Hotspot Overlays
            ...scaledHotspots.entries.map((entry) {
              return Positioned.fromRect(
                rect: entry.value,
                child: MouseRegion(
                  onEnter: (_) => hoveredSectionNotifier.value = entry.key,
                  onExit: (_) => hoveredSectionNotifier.value = 'lore',
                  cursor: SystemMouseCursors.none,
                  child: ValueListenableBuilder<String>(
                    valueListenable: hoveredSectionNotifier,
                    builder: (context, section, child) {
                      final isActive = section == entry.key;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isActive
                                ? Colors.cyan.withOpacity(0.8)
                                : Colors.cyan.withOpacity(0.3),
                            width: isActive ? 2 : 1,
                          ),
                          gradient: isActive
                              ? RadialGradient(
                                  colors: [
                                    Colors.cyan.withOpacity(0.2),
                                    Colors.transparent,
                                  ],
                                )
                              : null,
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: Colors.cyan.withOpacity(0.4),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  ),
                                ]
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

// === CINEMATIC DATA STREAM ===
class CinematicDataStream extends StatefulWidget {
  final Map<String, dynamic> details;
  final Animation<double> entryAnimation;
  final Animation<double> pulseAnimation;

  const CinematicDataStream({
    Key? key,
    required this.details,
    required this.entryAnimation,
    required this.pulseAnimation,
  }) : super(key: key);

  @override
  State<CinematicDataStream> createState() => _CinematicDataStreamState();
}

class _CinematicDataStreamState extends State<CinematicDataStream> {
  final GlobalKey _loreKey = GlobalKey();
  final GlobalKey _abilitiesKey = GlobalKey();
  final GlobalKey _statsKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 140,
      left: 60,
      child: ValueListenableBuilder<String>(
        valueListenable: hoveredSectionNotifier,
        builder: (context, section, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            switch (section) {
              case 'abilities':
                targetWidgetKeyNotifier.value = _abilitiesKey;
                break;
              case 'stats':
                targetWidgetKeyNotifier.value = _statsKey;
                break;
              case 'lore':
              default:
                targetWidgetKeyNotifier.value = _loreKey;
                break;
            }
          });

          return Container(
            constraints: const BoxConstraints(maxWidth: 450),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-0.5, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.elasticOut,
                    )),
                    child: child,
                  ),
                );
              },
              child: Column(
                key: ValueKey(section),
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (section == 'lore')
                    _CinematicInfoCard(
                      key: _loreKey,
                      animation: widget.entryAnimation,
                      pulseAnimation: widget.pulseAnimation,
                      intervalStart: 0.3,
                      glowColor: Colors.cyan,
                      child: _EnhancedLoreContent(lore: widget.details['lore']),
                    ),
                  if (section == 'abilities')
                    _CinematicInfoCard(
                      key: _abilitiesKey,
                      animation: widget.entryAnimation,
                      pulseAnimation: widget.pulseAnimation,
                      intervalStart: 0.4,
                      glowColor: Colors.purple,
                      child: _EnhancedAbilityContent(
                          abilities: widget.details['abilities']),
                    ),
                  if (section == 'stats')
                    _CinematicInfoCard(
                      key: _statsKey,
                      animation: widget.entryAnimation,
                      pulseAnimation: widget.pulseAnimation,
                      intervalStart: 0.5,
                      glowColor: Colors.orange,
                      child:
                          _EnhancedStatContent(stats: widget.details['stats']),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// === ENHANCED UI COMPONENTS ===

class _CinematicInfoCard extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> pulseAnimation;
  final double intervalStart;
  final Color glowColor;
  final Widget child;

  const _CinematicInfoCard({
    Key? key,
    required this.animation,
    required this.pulseAnimation,
    required this.intervalStart,
    required this.glowColor,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([animation, pulseAnimation]),
      builder: (context, _) {
        final slideOffset = Tween<Offset>(
          begin: const Offset(-1, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Interval(intervalStart, 1.0, curve: Curves.elasticOut),
        ));

        final glowIntensity = 0.3 + 0.4 * pulseAnimation.value;

        return SlideTransition(
          position: slideOffset,
          child: Transform(
            alignment: Alignment.centerLeft,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateY(0.05)
              ..scale(1.0 + 0.02 * pulseAnimation.value),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    glowColor.withOpacity(0.1),
                    Colors.black.withOpacity(0.8),
                    glowColor.withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                  color: glowColor.withOpacity(glowIntensity),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withOpacity(glowIntensity * 0.5),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                  BoxShadow(
                    color: glowColor.withOpacity(glowIntensity * 0.3),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _EnhancedLoreContent extends StatelessWidget {
  final Map<String, String> lore;
  const _EnhancedLoreContent({required this.lore});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.cyan, Colors.blue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                lore['title']!,
                style: GoogleFonts.orbitron(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1,
                  shadows: [
                    Shadow(color: Colors.cyan, blurRadius: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black.withOpacity(0.3),
            border: Border(
              left: BorderSide(color: Colors.cyan.withOpacity(0.5), width: 2),
            ),
          ),
          child: Text(
            lore['text']!,
            style: GoogleFonts.exo(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              height: 1.6,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _EnhancedAbilityContent extends StatelessWidget {
  final List<Map<String, String>> abilities;
  const _EnhancedAbilityContent({required this.abilities});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.pink],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              "COMBAT ABILITIES",
              style: GoogleFonts.orbitron(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1,
                shadows: [
                  Shadow(color: Colors.purple, blurRadius: 8),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...abilities.asMap().entries.map((entry) {
          final index = entry.key;
          final ability = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.1),
                  Colors.black.withOpacity(0.5),
                ],
              ),
              border: Border.all(
                color: Colors.purple.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                        border:
                            Border.all(color: Colors.purple.withOpacity(0.5)),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.orbitron(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        ability['name']!,
                        style: GoogleFonts.orbitron(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  ability['desc']!,
                  style: GoogleFonts.exo(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}

class _EnhancedStatContent extends StatelessWidget {
  final Map<String, double> stats;
  const _EnhancedStatContent({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.red],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              "CORE STATISTICS",
              style: GoogleFonts.orbitron(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1,
                shadows: [
                  Shadow(color: Colors.orange, blurRadius: 8),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...stats.entries
            .map((entry) => _AdvancedStatBar(
                  name: entry.key,
                  value: entry.value,
                ))
            .toList(),
      ],
    );
  }
}

class _AdvancedStatBar extends StatefulWidget {
  final String name;
  final double value;
  const _AdvancedStatBar({required this.name, required this.value});

  @override
  _AdvancedStatBarState createState() => _AdvancedStatBarState();
}

class _AdvancedStatBarState extends State<_AdvancedStatBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _glowController;
  late Animation<double> _animation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(milliseconds: widget.name.hashCode % 300 + 100),
        () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color getStatColor(String name) {
      switch (name.toLowerCase()) {
        case 'power':
          return Colors.red;
        case 'defense':
          return Colors.blue;
        case 'speed':
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    final statColor = getStatColor(widget.name);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.name.toUpperCase(),
                style: GoogleFonts.orbitron(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 2,
                ),
              ),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Text(
                    '${_animation.value.toInt()}',
                    style: GoogleFonts.orbitron(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: statColor,
                      shadows: [
                        Shadow(color: statColor, blurRadius: 4),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.black.withOpacity(0.5),
              border: Border.all(
                color: statColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: AnimatedBuilder(
              animation: Listenable.merge([_animation, _glowAnimation]),
              builder: (context, child) {
                return Stack(
                  children: [
                    // Main progress bar
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                          colors: [
                            statColor.withOpacity(0.1),
                            statColor.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                    // Filled portion
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _animation.value / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          gradient: LinearGradient(
                            colors: [
                              statColor.withOpacity(0.7),
                              statColor,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: statColor
                                  .withOpacity(_glowAnimation.value * 0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Animated highlight
                    if (_animation.value > 0)
                      Positioned(
                        left: (_animation.value / 100) *
                                (MediaQuery.of(context).size.width * 0.35) -
                            20,
                        child: Container(
                          width: 20,
                          height: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.0),
                                Colors.white
                                    .withOpacity(_glowAnimation.value * 0.6),
                                Colors.white.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final String label;
  final Color color;
  final Animation<double> pulseAnimation;

  const _StatusIndicator(this.label, this.color, this.pulseAnimation);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        final intensity = 0.5 + 0.5 * pulseAnimation.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(intensity),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.orbitron(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.8),
                letterSpacing: 1,
              ),
            ),
          ],
        );
      },
    );
  }
}

// === ADVANCED CUSTOM PAINTERS ===

class AdvancedDataWeavePainter extends CustomPainter {
  final ValueNotifier<Offset> mousePosition;
  final ValueNotifier<String> hoveredSection;
  final ValueNotifier<GlobalKey?> targetKey;
  final Map<String, Rect> hotspots;
  final Animation<double> pulseAnimation;

  Offset _previousHotspotCenter = Offset.zero;
  Offset _previousTargetPoint = Offset.zero;
  double _lerpFactor = 0.0;

  AdvancedDataWeavePainter({
    required this.mousePosition,
    required this.hoveredSection,
    required this.targetKey,
    required this.hotspots,
    required this.pulseAnimation,
  }) : super(
            repaint: Listenable.merge(
                [mousePosition, hoveredSection, targetKey, pulseAnimation]));

  @override
  void paint(Canvas canvas, Size size) {
    final mousePos = mousePosition.value;
    final section = hoveredSection.value;
    final hotspotRect = hotspots[section];
    final pulseValue = pulseAnimation.value;

    if (hotspotRect == null) return;

    final hotspotCenter = hotspotRect.center;
    final reticlePos = ui.Offset.lerp(mousePos, hotspotCenter, 0.3)!;

    // === ENHANCED SCANNER RETICLE ===
    final reticlePaint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final reticleGlow = Paint()
      ..color = Colors.cyan.withOpacity(0.5 + 0.3 * pulseValue)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Animated reticle size
    final reticleSize = 20 + 5 * pulseValue;

    // Draw multiple reticle rings
    for (int i = 0; i < 3; i++) {
      final ringSize = reticleSize + i * 8;
      final opacity = 0.8 - i * 0.2;
      canvas.drawCircle(
        reticlePos,
        ringSize,
        reticleGlow
          ..color = Colors.cyan.withOpacity(opacity * (0.5 + 0.3 * pulseValue)),
      );
      canvas.drawCircle(
        reticlePos,
        ringSize,
        reticlePaint..color = Colors.cyanAccent.withOpacity(opacity),
      );
    }

    // Crosshairs
    final crossSize = reticleSize + 15;
    canvas.drawLine(
      Offset(reticlePos.dx, reticlePos.dy - crossSize),
      Offset(reticlePos.dx, reticlePos.dy + crossSize),
      reticlePaint,
    );
    canvas.drawLine(
      Offset(reticlePos.dx - crossSize, reticlePos.dy),
      Offset(reticlePos.dx + crossSize, reticlePos.dy),
      reticlePaint,
    );

    // === ADVANCED DATA WEAVE CONNECTOR ===
    final RenderBox? targetBox =
        targetKey.value?.currentContext?.findRenderObject() as RenderBox?;
    if (targetBox == null) return;

    final targetSize = targetBox.size;
    final targetPosition = targetBox.localToGlobal(Offset.zero);
    final targetPoint =
        Offset(targetPosition.dx, targetPosition.dy + targetSize.height / 2);

    // Smooth animation when target changes
    if (_previousTargetPoint != targetPoint) {
      _lerpFactor = 0.0;
      _previousHotspotCenter = hotspotCenter;
      _previousTargetPoint = targetPoint;
    }
    _lerpFactor = min(1.0, _lerpFactor + 0.12);

    final animatedHotspot =
        ui.Offset.lerp(_previousHotspotCenter, hotspotCenter, _lerpFactor)!;
    final animatedTarget =
        ui.Offset.lerp(_previousTargetPoint, targetPoint, _lerpFactor)!;

    // === MULTI-STRAND DATA WEAVE ===
    final baseIntensity = 0.6 + 0.4 * pulseValue;

    for (int strand = 0; strand < 5; strand++) {
      final strandOffset = (strand - 2) * 8.0;
      final strandIntensity =
          baseIntensity * (0.3 + 0.7 * (1 - (strand / 4.0).abs()));

      final path = Path()..moveTo(animatedHotspot.dx, animatedHotspot.dy);

      // Complex curve with multiple control points
      final distance = (animatedTarget - animatedHotspot).distance;
      final cp1 = Offset(
        animatedHotspot.dx - distance * 0.3,
        animatedHotspot.dy + strandOffset,
      );
      final cp2 = Offset(
        animatedTarget.dx - distance * 0.2,
        animatedTarget.dy + strandOffset * 0.5,
      );

      path.cubicTo(
        cp1.dx,
        cp1.dy,
        cp2.dx,
        cp2.dy,
        animatedTarget.dx,
        animatedTarget.dy + strandOffset,
      );

      // Glow effect for center strands
      if (strand == 2) {
        final glowPaint = Paint()
          ..color = Colors.cyan.withOpacity(strandIntensity * 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15.0)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8.0;
        canvas.drawPath(path, glowPaint);
      }

      // Main strand
      final strandPaint = Paint()
        ..color = Colors.cyanAccent.withOpacity(strandIntensity)
        ..strokeWidth = strand == 2 ? 2.0 : 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, strandPaint);

      // Animated particles along the strand
      if (strand == 2) {
        final particleProgress = (pulseValue + strand * 0.2) % 1.0;
        final particlePos = _getPointOnPath(path, particleProgress);

        canvas.drawCircle(
          particlePos,
          3,
          Paint()..color = Colors.white.withOpacity(strandIntensity),
        );
        canvas.drawCircle(
          particlePos,
          6,
          Paint()
            ..color = Colors.cyan.withOpacity(strandIntensity * 0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0),
        );
      }
    }
  }

  Offset _getPointOnPath(Path path, double t) {
    final pathMetrics = path.computeMetrics();
    if (pathMetrics.isEmpty) return Offset.zero;

    final pathMetric = pathMetrics.first;
    final length = pathMetric.length;
    final tangent = pathMetric.getTangentForOffset(length * t);
    return tangent?.position ?? Offset.zero;
  }

  @override
  bool shouldRepaint(covariant AdvancedDataWeavePainter oldDelegate) => true;
}

class MatrixRainPainter extends CustomPainter {
  final Animation<double> animation;
  static final List<_MatrixColumn> _columns = [];

  MatrixRainPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // Initialize columns if needed
    if (_columns.isEmpty) {
      for (int i = 0; i < 20; i++) {
        _columns.add(_MatrixColumn(
          x: i * (size.width / 20),
          speed: 0.5 + Random().nextDouble() * 1.5,
          characters: _generateRandomChars(),
        ));
      }
    }

    final paint = Paint()..style = PaintingStyle.fill;

    for (final column in _columns) {
      column.update(animation.value, size.height);
      column.draw(canvas, paint, size);
    }
  }

  String _generateRandomChars() {
    const chars =
        'アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    return List.generate(20, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  @override
  bool shouldRepaint(covariant MatrixRainPainter oldDelegate) => true;
}

class _MatrixColumn {
  double x;
  double y = 0;
  double speed;
  String characters;

  _MatrixColumn(
      {required this.x, required this.speed, required this.characters});

  void update(double animationValue, double maxHeight) {
    y = (animationValue * speed * maxHeight * 2) % (maxHeight + 200) - 200;
  }

  void draw(Canvas canvas, Paint paint, Size size) {
    for (int i = 0; i < characters.length; i++) {
      final charY = y + i * 20;
      if (charY < -20 || charY > size.height + 20) continue;

      final opacity = 1.0 - (i / characters.length) * 0.8;
      final color = i == 0 ? Colors.white : Colors.green;

      paint.color = color.withOpacity(opacity * 0.3);

      final textPainter = TextPainter(
        text: TextSpan(
          text: characters[i],
          style: TextStyle(
            color: paint.color,
            fontSize: 14,
            fontFamily: 'monospace',
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(x, charY));
    }
  }
}

class FloatingParticlesPainter extends CustomPainter {
  final Animation<double> animation;
  static final List<_Particle> _particles = [];

  FloatingParticlesPainter({required this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // Initialize particles
    if (_particles.isEmpty) {
      for (int i = 0; i < 30; i++) {
        _particles.add(_Particle(
          x: Random().nextDouble() * size.width,
          y: Random().nextDouble() * size.height,
          size: Random().nextDouble() * 3 + 1,
          speed: Random().nextDouble() * 0.5 + 0.2,
          color: [Colors.cyan, Colors.blue, Colors.purple][Random().nextInt(3)],
        ));
      }
    }

    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in _particles) {
      particle.update(animation.value, size);
      particle.draw(canvas, paint);
    }
  }

  @override
  bool shouldRepaint(covariant FloatingParticlesPainter oldDelegate) => true;
}

class _Particle {
  double x, y, size, speed;
  Color color;
  double phase;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
  }) : phase = Random().nextDouble() * 2 * pi;

  void update(double animationValue, Size size) {
    y -= speed;
    x += sin(animationValue * 2 * pi + phase) * 0.5;

    if (y < -10) {
      y = size.height + 10;
      x = Random().nextDouble() * size.width;
    }
    if (x < -10) x = size.width + 10;
    if (x > size.width + 10) x = -10;
  }

  void draw(Canvas canvas, Paint paint) {
    paint.color = color.withOpacity(0.6);
    canvas.drawCircle(Offset(x, y), size, paint);

    // Glow effect
    paint.color = color.withOpacity(0.2);
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawCircle(Offset(x, y), size * 2, paint);
    paint.maskFilter = null;
  }
}

class AdvancedGridPainter extends CustomPainter {
  final Animation<double> pulseAnimation;

  AdvancedGridPainter({required this.pulseAnimation})
      : super(repaint: pulseAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final intensity = 0.05 + 0.1 * pulseAnimation.value;

    // Vertical lines
    for (double i = 0; i < size.width; i += 40) {
      paint.color = Colors.cyan.withOpacity(intensity);
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Horizontal lines
    for (double i = 0; i < size.height; i += 40) {
      paint.color = Colors.cyan.withOpacity(intensity);
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Highlight intersections
    paint.color = Colors.cyan.withOpacity(intensity * 2);
    paint.style = PaintingStyle.fill;
    for (double x = 0; x < size.width; x += 120) {
      for (double y = 0; y < size.height; y += 120) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant AdvancedGridPainter oldDelegate) => true;
}

class MultipleScanlinesPainter extends CustomPainter {
  final Animation<double> animation;

  MultipleScanlinesPainter({required this.animation})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // Primary scanline
    final position1 = size.height * animation.value;
    final paint1 = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, position1 - 30),
        Offset(0, position1 + 30),
        [
          Colors.transparent,
          Colors.cyan.withOpacity(0.4),
          Colors.cyan.withOpacity(0.8),
          Colors.cyan.withOpacity(0.4),
          Colors.transparent,
        ],
        [0.0, 0.2, 0.5, 0.8, 1.0],
      );
    canvas.drawRect(Rect.fromLTWH(0, position1 - 30, size.width, 60), paint1);

    // Secondary scanline (offset)
    final position2 = size.height * ((animation.value + 0.3) % 1.0);
    final paint2 = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, position2 - 20),
        Offset(0, position2 + 20),
        [
          Colors.transparent,
          Colors.blue.withOpacity(0.2),
          Colors.blue.withOpacity(0.5),
          Colors.blue.withOpacity(0.2),
          Colors.transparent,
        ],
        [0.0, 0.2, 0.5, 0.8, 1.0],
      );
    canvas.drawRect(Rect.fromLTWH(0, position2 - 20, size.width, 40), paint2);

    // Tertiary scanline (faster)
    final position3 = size.height * ((animation.value * 2) % 1.0);
    final paint3 = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, position3 - 10),
        Offset(0, position3 + 10),
        [
          Colors.transparent,
          Colors.purple.withOpacity(0.3),
          Colors.transparent,
        ],
      );
    canvas.drawRect(Rect.fromLTWH(0, position3 - 10, size.width, 20), paint3);
  }

  @override
  bool shouldRepaint(covariant MultipleScanlinesPainter oldDelegate) => true;
}

class HologramScanPainter extends CustomPainter {
  final double progress;

  HologramScanPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Hologram interference lines
    final paint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Moving scan effect
    final scanY = size.height * progress;

    // Main scan beam
    paint.shader = ui.Gradient.linear(
      Offset(0, scanY - 20),
      Offset(0, scanY + 20),
      [
        Colors.transparent,
        Colors.cyan.withOpacity(0.6),
        Colors.white.withOpacity(0.8),
        Colors.cyan.withOpacity(0.6),
        Colors.transparent,
      ],
    );
    canvas.drawRect(Rect.fromLTWH(0, scanY - 20, size.width, 40), paint);

    // Interference patterns
    for (int i = 0; i < 10; i++) {
      final y = (scanY + i * 15) % size.height;
      final opacity = 0.1 * sin(progress * 2 * pi + i);
      if (opacity > 0) {
        paint.color = Colors.cyan.withOpacity(opacity);
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
    }

    // Digital noise effect
    final random = Random((progress * 1000).toInt());
    paint.style = PaintingStyle.fill;
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final opacity = random.nextDouble() * 0.3;
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawRect(Rect.fromLTWH(x, y, 2, 1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant HologramScanPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
