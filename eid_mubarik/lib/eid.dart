
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';



class EidMubarak extends StatefulWidget {
  const EidMubarak({Key? key}) : super(key: key);

  @override
  State<EidMubarak> createState() => _EidMubarakState();
}

class _EidMubarakState extends State<EidMubarak> with TickerProviderStateMixin {
  late AnimationController _moonController;
  late AnimationController _mosqueController;
  late AnimationController _textController;
  late AnimationController _celebrationController;
  late AnimationController _cloudController;

  late Animation<double> _moonAnimation;
  late Animation<double> _mosqueAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _textScaleAnimation;

  final List<Star> _stars = [];
  final List<Particle> _particles = [];
  final List<Cloud> _clouds = [];
  final Random _random = Random();

  bool _showShareButton = false;
  bool _showRestartButton = false;

  @override
  void initState() {
    super.initState();

    // Generate stars
    for (int i = 0; i < 100; i++) {
      _stars.add(Star(
        x: _random.nextDouble() * 1.0,
        y: _random.nextDouble() * 0.7,
        size: _random.nextDouble() * 3 + 1,
        opacity: _random.nextDouble(),
        blinkDuration: _random.nextInt(3) + 1,
      ));
    }

    // Generate clouds
    for (int i = 0; i < 5; i++) {
      _clouds.add(Cloud(
        x: _random.nextDouble() * 1.2 - 0.1,
        y: _random.nextDouble() * 0.4,
        speed: _random.nextDouble() * 0.0003 + 0.0001,
        size: _random.nextDouble() * 0.5 + 0.5,
        opacity: _random.nextDouble() * 0.3 + 0.1,
      ));
    }

    // Moon animation
    _moonController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _moonAnimation = CurvedAnimation(
      parent: _moonController,
      curve: Curves.easeInOut,
    );

    // Mosque animation
    _mosqueController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _mosqueAnimation = CurvedAnimation(
      parent: _mosqueController,
      curve: Curves.easeInOut,
    );

    // Text animation
    _textController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _textOpacityAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );

    _textScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.elasticOut,
      ),
    );

    // Cloud animation controller
    _cloudController = AnimationController(
      duration: const Duration(hours: 1),
      vsync: this,
    )..repeat();

    // Celebration animation controller
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _celebrationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _generateParticles();
        });
        _celebrationController.reset();
        _celebrationController.forward();
      }
    });

    // Start animations sequentially
    _startAnimationSequence();

    // Start star twinkling
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          for (var star in _stars) {
            if (_random.nextDouble() < 0.05) {
              star.opacity = _random.nextDouble() * 0.5 + 0.5;
            }
          }
        });
      }
    });

    // Update particle positions
    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (mounted) {
        setState(() {
          // Update particles
          if (_particles.isNotEmpty) {
            for (int i = _particles.length - 1; i >= 0; i--) {
              var particle = _particles[i];

              // Update position
              particle.x += particle.vx;
              particle.y += particle.vy;

              // Apply gravity
              particle.vy += 0.05;

              // Reduce opacity over time
              particle.opacity -= 0.005;

              // Remove particles that are no longer visible
              if (particle.opacity <= 0) {
                _particles.removeAt(i);
              }
            }
          }

          // Update clouds
          for (var cloud in _clouds) {
            cloud.x += cloud.speed;
            if (cloud.x > 1.1) {
              cloud.x = -0.3;
              cloud.y = _random.nextDouble() * 0.4;
            }
          }
        });
      }
    });
  }

  void _startAnimationSequence() {
    _moonController.forward();

    Future.delayed(const Duration(seconds: 2), () {
      _mosqueController.forward();
    });

    Future.delayed(const Duration(seconds: 4), () {
      _textController.forward();
    });

    Future.delayed(const Duration(seconds: 5), () {
      _generateParticles();
      _celebrationController.forward();
    });

    Future.delayed(const Duration(seconds: 7), () {
      setState(() {
        _showShareButton = true;
      });
    });

    Future.delayed(const Duration(seconds: 8), () {
      setState(() {
        _showRestartButton = true;
      });
    });
  }

  void _restartAnimation() {
    setState(() {
      _particles.clear();
      _showShareButton = false;
      _showRestartButton = false;
    });

    _moonController.reset();
    _mosqueController.reset();
    _textController.reset();
    _celebrationController.reset();

    _startAnimationSequence();
  }

  void _generateParticles() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    for (int i = 0; i < 150; i++) {
      final colors = [
        Colors.amber,
        Colors.green,
        Colors.red,
        Colors.blue,
        Colors.purple,
        Colors.orange,
      ];

      _particles.add(Particle(
        x: screenWidth / 2 + _random.nextDouble() * 20 - 10,
        y: screenHeight / 2,
        vx: _random.nextDouble() * 8 - 4,
        vy: _random.nextDouble() * -10 - 2,
        color: colors[_random.nextInt(colors.length)],
        size: _random.nextDouble() * 8 + 2,
        opacity: 1.0,
      ));
    }
  }

  void _shareApp() {
    // Show a message that would typically connect to a share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing your Eid Mubarak wishes!'),
        backgroundColor: Colors.indigo,
        duration: Duration(seconds: 2),
      ),
    );

    // Here you would implement platform-specific sharing functionality
  }

  @override
  void dispose() {
    _moonController.dispose();
    _mosqueController.dispose();
    _textController.dispose();
    _celebrationController.dispose();
    _cloudController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background container
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A1931),
                  Color(0xFF152642),
                  Color(0xFF243B78),
                ],
              ),
            ),
          ),

          // Animation elements
          Stack(
            children: [
              // Stars
              ...buildStars(),

              // Clouds
              ...buildClouds(),

              // Particles (celebration effect)
              ...buildParticles(),

              // Moon
              AnimatedBuilder(
                animation: _moonAnimation,
                builder: (context, child) {
                  return Positioned(
                    top: 50,
                    right: 50,
                    child: Opacity(
                      opacity: _moonAnimation.value,
                      child: CustomPaint(
                        size: const Size(100, 100),
                        painter: MoonPainter(),
                      ),
                    ),
                  );
                },
              ),

              // Mosque with lanterns
              AnimatedBuilder(
                animation: _mosqueAnimation,
                builder: (context, child) {
                  return Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Opacity(
                      opacity: _mosqueAnimation.value,
                      child: CustomPaint(
                        size: Size(size.width, size.height * 0.4),
                        painter: EnhancedMosquePainter(_mosqueAnimation.value),
                      ),
                    ),
                  );
                },
              ),

              // Ramzan Mubarak Text
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Center(
                    child: Opacity(
                      opacity: _textOpacityAnimation.value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Main title with animation
                          Transform.scale(
                            scale: _textScaleAnimation.value,
                            child: ShaderMask(
                              shaderCallback: (bounds) {
                                return const LinearGradient(
                                  colors: [
                                    Color(0xFFFFD700),  // Gold
                                    Color(0xFFFFA500),  // Orange
                                    Color(0xFFFFD700),  // Gold
                                  ],
                                ).createShader(bounds);
                              },
                              child: const Text(
                                'عِيدٌ مُبَارَكٌ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 48,fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                  height: 1.2,
                                  letterSpacing: 2,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black54,
                                      offset: Offset(2, 2),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Subtitle
                          AnimatedOpacity(
                            opacity: _textOpacityAnimation.value,
                            duration: const Duration(seconds: 3),
                            child: const Text(
                              'Eid Mubarak',
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Decorative divider
                          AnimatedOpacity(
                            opacity: _textOpacityAnimation.value,
                            duration: const Duration(seconds: 3),
                            child: Container(
                              width: 100,
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.transparent, Colors.amber, Colors.transparent],
                                ),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Blessing message
                          AnimatedOpacity(
                            opacity: _textOpacityAnimation.value,
                            duration: const Duration(seconds: 3),
                            child: const Text(
                              'May this blessed Eid bring peace,\nhappiness, and prosperity',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.5,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Floating lanterns
              ...buildFloatingLanterns(size),

              // Interactive buttons
              // Share button
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                bottom: _showShareButton ? 30 : -50,
                right: 30,
                child: FloatingActionButton(
                  onPressed: _shareApp,
                  backgroundColor: Colors.indigo.shade800,
                  child: const Icon(Icons.share, color: Colors.white),
                ),
              ),

              // Restart animation button
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                bottom: _showRestartButton ? 30 : -50,
                left: 30,
                child: FloatingActionButton(
                  onPressed: _restartAnimation,
                  backgroundColor: Colors.indigo.shade800,
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> buildStars() {
    return _stars.map((star) {
      return Positioned(
        left: star.x * MediaQuery.of(context).size.width,
        top: star.y * MediaQuery.of(context).size.height,
        child: AnimatedOpacity(
          opacity: star.opacity,
          duration: Duration(seconds: star.blinkDuration),
          child: Container(
            width: star.size,
            height: star.size,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(star.size / 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.7),
                  blurRadius: star.size,
                  spreadRadius: star.size / 4,
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> buildClouds() {
    return _clouds.map((cloud) {
      return Positioned(
        left: cloud.x * MediaQuery.of(context).size.width,
        top: cloud.y * MediaQuery.of(context).size.height,
        child: Opacity(
          opacity: cloud.opacity,
          child: Transform.scale(
            scale: cloud.size,
            child: CustomPaint(
              size: const Size(120, 60),
              painter: CloudPainter(),
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> buildParticles() {
    return _particles.map((particle) {
      return Positioned(
        left: particle.x,
        top: particle.y,
        child: Opacity(
          opacity: particle.opacity,
          child: Container(
            width: particle.size,
            height: particle.size,
            decoration: BoxDecoration(
              color: particle.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: particle.color.withOpacity(0.5),
                  blurRadius: 3,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> buildFloatingLanterns(Size size) {
    final List<Widget> lanterns = [];

    // Define lantern positions and durations (note: some durations are doubles)
    final List<Map<String, dynamic>> lanternData = [
      {'x': 0.2, 'y': 0.35, 'delay': 1, 'duration': 3},
      {'x': 0.8, 'y': 0.3, 'delay': 2, 'duration': 4},
      {'x': 0.3, 'y': 0.25, 'delay': 3, 'duration': 5},
      {'x': 0.7, 'y': 0.2, 'delay': 1.5, 'duration': 4.5},
      {'x': 0.5, 'y': 0.38, 'delay': 2.5, 'duration': 3.5},
    ];

    for (var data in lanternData) {
      lanterns.add(
        AnimatedBuilder(
          animation: _mosqueAnimation,
          builder: (context, child) {
            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              // Convert the duration to milliseconds to handle double values
              duration: Duration(milliseconds: (data['duration'] * 1000).toInt()),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Positioned(
                  left: size.width * data['x'],
                  bottom: size.height * (0.3 + 0.05 * sin(value * 2 * pi)),
                  child: Opacity(
                    opacity: _mosqueAnimation.value,
                    child: GestureDetector(
                      onTap: () {
                        // Lantern interaction effect
                        _generateLanternParticles(size.width * data['x'], size.height * (0.7 - 0.05 * sin(value * 2 * pi)));
                      },
                      child: CustomPaint(
                        size: const Size(20, 30),
                        painter: LanternPainter(
                          glowIntensity: 0.5 + 0.5 * sin(value * 2 * pi),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    }

    return lanterns;
  }

  void _generateLanternParticles(double x, double y) {
    for (int i = 0; i < 20; i++) {
      final colors = [
        Colors.amber,
        Colors.orange,
        Colors.yellow,
      ];

      _particles.add(Particle(
        x: x,
        y: y,
        vx: _random.nextDouble() * 4 - 2,
        vy: _random.nextDouble() * -6 - 1,
        color: colors[_random.nextInt(colors.length)],
        size: _random.nextDouble() * 5 + 1,
        opacity: 1.0,
      ));
    }
  }
}

class Star {
  double x;
  double y;
  double size;
  double opacity;
  int blinkDuration;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.blinkDuration,
  });
}

class Cloud {
  double x;
  double y;
  double speed;
  double size;
  double opacity;

  Cloud({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
  });
}

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  Color color;
  double size;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.opacity,
  });
}

class MoonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint moonPaint = Paint()
      ..color = const Color(0xFFFFF4DB)
      ..style = PaintingStyle.fill;

    final Paint shadowPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw glow
    canvas.drawCircle(center, radius + 10, shadowPaint);

    // Draw crescent
    canvas.drawCircle(center, radius, moonPaint);
    canvas.drawCircle(
      Offset(center.dx + radius * 0.35, center.dy),
      radius * 0.85,
      Paint()..color = const Color(0xFF0A1931)..style = PaintingStyle.fill,
    );

    // Add some subtle details to the moon
    final Paint detailPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Add a few subtle craters
    canvas.drawCircle(
      Offset(center.dx - radius * 0.25, center.dy - radius * 0.3),
      radius * 0.08,
      detailPaint,
    );

    canvas.drawCircle(
      Offset(center.dx - radius * 0.5, center.dy + radius * 0.1),
      radius * 0.05,
      detailPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint cloudPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final double width = size.width;
    final double height = size.height;

    // Draw cloud circles
    canvas.drawCircle(
      Offset(width * 0.3, height * 0.5),
      height * 0.5,
      cloudPaint,
    );

    canvas.drawCircle(
      Offset(width * 0.5, height * 0.4),
      height * 0.6,
      cloudPaint,
    );

    canvas.drawCircle(
      Offset(width * 0.7, height * 0.5),
      height * 0.5,
      cloudPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class EnhancedMosquePainter extends CustomPainter {
  final double animationValue;

  EnhancedMosquePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint mosquePaint = Paint()
      ..color = const Color(0xFF1E262F)
      ..style = PaintingStyle.fill;

    final Paint mosqueBorderPaint = Paint()
      ..color = const Color(0xFF5E4C1C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint lanternPaint = Paint()
      ..color = Colors.orange.withOpacity(animationValue * 0.8)
      ..style = PaintingStyle.fill;

    final Paint lanternGlowPaint = Paint()
      ..color = Colors.orange.withOpacity(animationValue * 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    final Paint detailPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(animationValue * 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint windowPaint = Paint()
      ..color = const Color(0xFFFFF9C4).withOpacity(animationValue * 0.7)
      ..style = PaintingStyle.fill;

    final Paint goldDetailPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    // Enhanced reflection on water with ripple effect
    final double currentTime = DateTime.now().millisecondsSinceEpoch / 1000;
    final Paint reflectionPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF243B78).withOpacity(0.4),
          const Color(0xFF243B78).withOpacity(0.1),
        ],
      ).createShader(Rect.fromLTWH(0, size.height * 0.8, size.width, size.height * 0.2));

    // Draw water with ripple effect
    Path waterPath = Path();
    waterPath.moveTo(0, size.height * 0.8);

    double amplitude = size.height * 0.005;
    double frequency = 0.2;
    double phaseShift = currentTime * 0.5;

    for (double x = 0; x <= size.width; x += size.width / 100) {
      double y = size.height * 0.8 + amplitude * sin((x * frequency) + phaseShift);
      waterPath.lineTo(x, y);
    }

    waterPath.lineTo(size.width, size.height);
    waterPath.lineTo(0, size.height);
    waterPath.close();

    canvas.drawPath(waterPath, reflectionPaint);

    // City silhouette background
    final Path cityPath = Path();
    cityPath.moveTo(0, size.height * 0.8);
    cityPath.lineTo(0, size.height * 0.65);

    // Create a randomized skyline
    double currentX = 0;
    Random random = Random(12345); // Fixed seed for consistent appearance
    while (currentX < size.width) {
      final double buildingWidth = size.width * (0.05 + random.nextDouble() * 0.05);
      final double buildingHeight = size.height * (0.2 + random.nextDouble() * 0.1);

      cityPath.lineTo(currentX, size.height * 0.8 - buildingHeight);

      // Add some windows to buildings
      if (random.nextBool() && buildingWidth > size.width * 0.06) {
        int windowColumns = 2 + random.nextInt(3);
        int windowRows = 3 + random.nextInt(3);
        double windowWidth = buildingWidth / (windowColumns * 2);
        double windowHeight = buildingHeight / (windowRows * 2);

        for (int row = 0; row < windowRows; row++) {
          for (int col = 0; col < windowColumns; col++) {
            // Only draw some windows (random pattern)
            if (random.nextDouble() > 0.3) {
              double windowX = currentX + col * buildingWidth / windowColumns + buildingWidth / (windowColumns * 2);
              double windowY = size.height * 0.8 - buildingHeight + row * buildingHeight / windowRows + buildingHeight / (windowRows * 2);

              canvas.drawRect(
                Rect.fromLTWH(windowX - windowWidth/2, windowY - windowHeight/2, windowWidth, windowHeight),
                Paint()..color = const Color(0xFFFFD54F).withOpacity(0.6 * animationValue),
              );
            }
          }
        }
      }

      cityPath.lineTo(currentX + buildingWidth, size.height * 0.8 - buildingHeight);

      currentX += buildingWidth;
    }

    cityPath.lineTo(size.width, size.height * 0.65);
    cityPath.lineTo(size.width, size.height * 0.8);

    canvas.drawPath(cityPath, Paint()..color = const Color(0xFF101F33));

    // Main mosque path
    final Path mosquePath = Path();

    // Base of the mosque
    mosquePath.moveTo(0, size.height * 0.8);
    mosquePath.lineTo(0, size.height * 0.5);
    mosquePath.lineTo(size.width, size.height * 0.5);
    mosquePath.lineTo(size.width, size.height * 0.8);

    // Main dome
    final double mainDomeWidth = size.width * 0.2;
    final double mainDomeX = size.width * 0.5;

    mosquePath.moveTo(mainDomeX - mainDomeWidth / 2, size.height * 0.5);
    mosquePath.cubicTo(
      mainDomeX - mainDomeWidth / 4, size.height * 0.35,
      mainDomeX + mainDomeWidth / 4, size.height * 0.35,
      mainDomeX + mainDomeWidth / 2, size.height * 0.5,
    );

    // Draw smaller domes
    final domeSpacing = size.width / 5;

    // Left side domes
    for (int i = 1; i <= 2; i++) {
      final double domeX = mainDomeX - domeSpacing * i;
      final double domeWidth = mainDomeWidth * 0.7;

      mosquePath.moveTo(domeX - domeWidth / 2, size.height * 0.5);
      mosquePath.cubicTo(
        domeX - domeWidth / 4, size.height * 0.4,
        domeX + domeWidth / 4, size.height * 0.4,
        domeX + domeWidth / 2, size.height * 0.5,
      );
    }

    // Right side domes
    for (int i = 1; i <= 2; i++) {
      final double domeX = mainDomeX + domeSpacing * i;
      final double domeWidth = mainDomeWidth * 0.7;

      mosquePath.moveTo(domeX - domeWidth / 2, size.height * 0.5);
      mosquePath.cubicTo(
        domeX - domeWidth / 4, size.height * 0.4,
        domeX + domeWidth / 4, size.height * 0.4,
        domeX + domeWidth / 2, size.height * 0.5,
      );
    }

    // Draw minarets
    final double minaretWidth = size.width * 0.03;
    final double minaretHeight = size.height * 0.25;

    // Left minaret
    mosquePath.addRect(Rect.fromLTWH(
      size.width * 0.1 - minaretWidth / 2,
      size.height * 0.5 - minaretHeight,
      minaretWidth,
      minaretHeight,
    ));

    // Add minaret cap
    mosquePath.addOval(Rect.fromLTWH(
      size.width * 0.1 - minaretWidth,
      size.height * 0.5 - minaretHeight - minaretWidth,
      minaretWidth * 2,
      minaretWidth * 2,
    ));

    // Right minaret
    mosquePath.addRect(Rect.fromLTWH(
      size.width * 0.9 - minaretWidth / 2,
      size.height * 0.5 - minaretHeight,
      minaretWidth,
      minaretHeight,
    ));

    // Add minaret cap
    mosquePath.addOval(Rect.fromLTWH(
      size.width * 0.9 - minaretWidth,
      size.height * 0.5 - minaretHeight - minaretWidth,
      minaretWidth * 2,
      minaretWidth * 2,
    ));

    // Draw mosque
    canvas.drawPath(mosquePath, mosquePaint);
    canvas.drawPath(mosquePath, mosqueBorderPaint);

    // Draw decorations and details
    // Main entrance arch
    final Path entrancePath = Path();
    entrancePath.moveTo(mainDomeX - mainDomeWidth / 3, size.height * 0.7);
    entrancePath.cubicTo(
      mainDomeX - mainDomeWidth / 6, size.height * 0.6,
      mainDomeX + mainDomeWidth / 6, size.height * 0.6,
      mainDomeX + mainDomeWidth / 3, size.height * 0.7,
    );
    canvas.drawPath(entrancePath, detailPaint);

    // Add windows with light
    final double windowWidth = size.width * 0.04;
    final double windowHeight = size.height * 0.06;

    // Draw windows with a pattern
    for (int i = 0; i < 9; i++) {
      if (i == 4) continue; // Skip the middle position (door)

      final double windowX = size.width * 0.2 + (i * size.width * 0.075);
      final double windowY = size.height * 0.65;

      // Window arch
      final Path windowPath = Path();
      windowPath.moveTo(windowX - windowWidth / 2, windowY);
      windowPath.lineTo(windowX - windowWidth / 2, windowY - windowHeight * 0.6);
      windowPath.cubicTo(
        windowX - windowWidth / 4, windowY - windowHeight,
        windowX + windowWidth / 4, windowY - windowHeight,
        windowX + windowWidth / 2, windowY - windowHeight * 0.6,
      );
      windowPath.lineTo(windowX + windowWidth / 2, windowY);
      windowPath.close();

      canvas.drawPath(windowPath, windowPaint);
      canvas.drawPath(windowPath, mosqueBorderPaint);
    }

    // Add top decorations to domes
    final decorSize = mainDomeWidth * 0.05;

    // Main dome decoration
    canvas.drawCircle(
      Offset(mainDomeX, size.height * 0.35),
      decorSize,
      goldDetailPaint,
    );

    // Smaller dome decorations
    for (int i = -2; i <= 2; i++) {
      if (i == 0) continue; // Skip the main dome

      final double domeX = mainDomeX + domeSpacing * i;
      canvas.drawCircle(
        Offset(domeX, size.height * 0.4),
        decorSize * 0.7,
        goldDetailPaint,
      );
    }

    // Minaret decorations
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.5 - minaretHeight - minaretWidth),
      decorSize * 0.7,
      goldDetailPaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.5 - minaretHeight - minaretWidth),
      decorSize * 0.7,
      goldDetailPaint,
    );

    // Add lanterns with glow effect based on animation value
    final List<Offset> lanternPositions = [
      Offset(size.width * 0.25, size.height * 0.7),
      Offset(size.width * 0.75, size.height * 0.7),
      Offset(size.width * 0.4, size.height * 0.65),
      Offset(size.width * 0.6, size.height * 0.65),
      Offset(size.width * 0.5, size.height * 0.7),
    ];

    for (final Offset position in lanternPositions) {
      // Draw glow
      canvas.drawCircle(
        position,
        10 * animationValue,
        lanternGlowPaint,
      );

      // Draw lantern
      canvas.drawCircle(
        position,
        5,
        lanternPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LanternPainter extends CustomPainter {
  final double glowIntensity;

  LanternPainter({required this.glowIntensity});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Draw the lantern body
    final Paint bodyPaint = Paint()
      ..color = Color.lerp(
        const Color(0xFFB71C1C),
        const Color(0xFFFFD54F),
        glowIntensity * 0.5,
      )!
      ..style = PaintingStyle.fill;

    // Draw the lantern top
    final Paint topPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    // Draw glow
    final Paint glowPaint = Paint()
      ..color = const Color(0xFFFFD54F).withOpacity(glowIntensity * 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    // Draw the hanging string
    final Paint stringPaint = Paint()
      ..color = const Color(0xFFFFECB3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw the glow effect
    canvas.drawCircle(
      Offset(width / 2, height * 0.6),
      width * 0.8,
      glowPaint,
    );

    // Draw the hanging string
    final Path stringPath = Path();
    stringPath.moveTo(width / 2, 0);
    stringPath.lineTo(width / 2, height * 0.2);
    canvas.drawPath(stringPath, stringPaint);

    // Draw the top cap
    final Path topPath = Path();
    topPath.moveTo(width * 0.3, height * 0.2);
    topPath.lineTo(width * 0.7, height * 0.2);
    topPath.lineTo(width * 0.6, height * 0.3);
    topPath.lineTo(width * 0.4, height * 0.3);
    topPath.close();
    canvas.drawPath(topPath, topPaint);

    // Draw the lantern body
    final Path bodyPath = Path();
    bodyPath.moveTo(width * 0.4, height * 0.3);
    bodyPath.lineTo(width * 0.6, height * 0.3);
    bodyPath.lineTo(width * 0.7, height * 0.8);
    bodyPath.lineTo(width * 0.3, height * 0.8);
    bodyPath.close();
    canvas.drawPath(bodyPath, bodyPaint);

    // Draw details on the lantern
    final Paint detailPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(width * 0.4, height * 0.5),
      Offset(width * 0.6, height * 0.5),
      detailPaint,
    );

    canvas.drawLine(
      Offset(width * 0.35, height * 0.65),
      Offset(width * 0.65, height * 0.65),
      detailPaint,
    );

    // Draw the bottom cap
    final Path bottomPath = Path();
    bottomPath.moveTo(width * 0.3, height * 0.8);
    bottomPath.lineTo(width * 0.7, height * 0.8);
    bottomPath.lineTo(width * 0.6, height * 0.9);
    bottomPath.lineTo(width * 0.4, height * 0.9);
    bottomPath.close();
    canvas.drawPath(bottomPath, topPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}