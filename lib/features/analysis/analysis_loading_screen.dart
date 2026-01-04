import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:skin_scan_ai/state/scan_provider.dart';
import 'package:skin_scan_ai/theme.dart';

class AnalysisLoadingScreen extends StatefulWidget {
  const AnalysisLoadingScreen({super.key});

  @override
  State<AnalysisLoadingScreen> createState() => _AnalysisLoadingScreenState();
}

class _AnalysisLoadingScreenState extends State<AnalysisLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Timer _timer;
  double _progress = 0.0;
  int _currentChipIndex = 0;

  final List<String> _statusChips = [
    'Detecting Wrinkles',
    'Hydration',
    'Mapping Pores'
  ];

  Future<void> _performAnalysis() async {
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    await scanProvider.analyzeSkin(); // Uses real AI, fallback to mock if fails
  }

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _progressController.addListener(() {
      setState(() {
        _progress = _progressController.value;
        // Update chip visibility based on progress
        _currentChipIndex = (_progress * _statusChips.length).floor();
      });
    });

    _progressController.forward();

    // Perform analysis and navigate to results after 4 seconds
    _timer = Timer(const Duration(seconds: 4), () async {
      if (mounted) {
        await _performAnalysis();
        context.push('/results');
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Header
              const Text(
                'Analyzing Your Skin...',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Central Scanner Visual
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            // Background Image with Color Filter
                            Positioned.fill(
                              child: ColorFiltered(
                                colorFilter: const ColorFilter.matrix([
                                  0.2126, 0.7152, 0.0722, 0, 0, // Red channel (grayscale)
                                  0.2126, 0.7152, 0.0722, 0, 0, // Green channel (grayscale)
                                  0.2126, 0.7152, 0.0722, 0, 0, // Blue channel (grayscale)
                                  0, 0, 0, 1, 0, // Alpha
                                ]),
                                child: Image.asset(
                                  'assets/images/camera_placeholder.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Green tint overlay
                            Positioned.fill(
                              child: Container(
                                color: Colors.green.withOpacity(0.3),
                              ),
                            ),
                            // Grid Overlay
                            Positioned.fill(
                              child: CustomPaint(
                                painter: GridPainter(),
                              ),
                            ),
                            // Laser Line Animation
                            Positioned.fill(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return AnimatedBuilder(
                                    animation: _progressController,
                                    builder: (context, child) {
                                      final laserY = constraints.maxHeight * (0.5 + 0.4 * sin(_progress * 2 * pi));
                                      return Positioned(
                                        left: 0,
                                        right: 0,
                                        top: laserY,
                                        child: Container(
                                          height: 3,
                                          color: AppTheme.primaryGreen,
                                        ).animate(
                                          effects: [
                                            const ShimmerEffect(
                                              duration: Duration(milliseconds: 500),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            // Mapping Points
                            Positioned(
                              top: 120,
                              left: 80,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryGreen,
                                  shape: BoxShape.circle,
                                ),
                              ).animate(
                                effects: [
                                  const FadeEffect(
                                    duration: Duration(milliseconds: 300),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 140,
                              right: 90,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryGreen,
                                  shape: BoxShape.circle,
                                ),
                              ).animate(
                                effects: [
                                  const FadeEffect(
                                    duration: Duration(milliseconds: 300),
                                    delay: Duration(milliseconds: 500),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 140,
                              left: 100,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryGreen,
                                  shape: BoxShape.circle,
                                ),
                              ).animate(
                                effects: [
                                  const FadeEffect(
                                    duration: Duration(milliseconds: 300),
                                    delay: Duration(milliseconds: 1000),
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
              const SizedBox(height: 40),
              // Progress Section
              Column(
                children: [
                  Text(
                    'Processing 3D Mesh... ${(100 * _progress).toInt()}%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Progress Bar
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Status Chips
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _statusChips.length,
                          (index) => AnimatedOpacity(
                            opacity: index <= _currentChipIndex ? 1.0 : 0.3,
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: index <= _currentChipIndex
                                    ? AppTheme.primaryGreen.withOpacity(0.1)
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: index <= _currentChipIndex
                                      ? AppTheme.primaryGreen
                                      : Colors.grey[400]!,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _statusChips[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: index <= _currentChipIndex
                                      ? AppTheme.primaryGreen
                                      : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ).animate(
                              effects: index <= _currentChipIndex
                                  ? [
                                      const ScaleEffect(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.elasticOut,
                                      ),
                                    ]
                                  : [],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Fun Fact Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryGreen.withOpacity(0.1),
                        AppTheme.primaryGreen.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: AppTheme.primaryGreen,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Skin Fact #12: Hydrated skin reflects light better, giving you a natural glow!',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1;

    const double gridSize = 20;

    // Vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
