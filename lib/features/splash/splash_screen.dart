import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to onboarding after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // background-dark
      body: Stack(
        children: [
          // Background glow
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.7,
                  colors: [
                    Color.fromRGBO(52, 211, 153, 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
              .fadeIn(duration: const Duration(seconds: 2)),
          ),
          // Floating particles
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: MediaQuery.of(context).size.width * 0.25,
            child: Container(
              width: 2,
              height: 2,
              decoration: BoxDecoration(
                color: const Color(0xFF34D399).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ).animate(onPlay: (controller) => controller.loop())
              .moveY(begin: 0, end: -10, duration: const Duration(seconds: 6))
              .fadeIn(duration: const Duration(seconds: 1)),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.75,
            right: MediaQuery.of(context).size.width * 0.25,
            child: Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFF34D399).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ).animate(onPlay: (controller) => controller.loop())
              .moveY(begin: 0, end: -10, duration: const Duration(seconds: 6), delay: const Duration(seconds: 1))
              .fadeIn(duration: const Duration(seconds: 1)),
          ),
          Positioned(
            bottom: 80,
            left: 40,
            child: Container(
              width: 1,
              height: 1,
              decoration: BoxDecoration(
                color: const Color(0xFF34D399).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ).animate(onPlay: (controller) => controller.loop())
              .moveY(begin: 0, end: -10, duration: const Duration(seconds: 6), delay: const Duration(seconds: 2))
              .fadeIn(duration: const Duration(seconds: 1)),
          ),
          // Grid pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: CustomPaint(
                painter: GridPainter(),
              ),
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with spinning borders
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer spinning border
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF34D399).withOpacity(0.2), width: 1),
                          shape: BoxShape.circle,
                        ),
                      ).animate(onPlay: (controller) => controller.loop())
                        .rotate(duration: const Duration(seconds: 12)),
                      // Inner spinning border
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF34D399).withOpacity(0.1), width: 1),
                          shape: BoxShape.circle,
                        ),
                      ).animate(onPlay: (controller) => controller.loop())
                        .rotate(duration: const Duration(seconds: 15), begin: 1.0),
                      // Glow effect
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF34D399).withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                      // Logo image
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: AssetImage('assets/images/splash_screen_girl.png'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF34D399).withOpacity(0.5),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ).animate()
                        .scale(duration: const Duration(seconds: 1), begin: const Offset(0.8, 0.8)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Title
                Text(
                  'Skin Scan AI',
                  style: GoogleFonts.montserrat(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: const Color(0xFF34D399).withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ).animate()
                  .fadeIn(duration: const Duration(seconds: 1), delay: const Duration(milliseconds: 500)),
                const SizedBox(height: 8),
                // Subtitle
                Text(
                  'Your Personal Skincare Analyst',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                    letterSpacing: 2,
                  ),
                ).animate()
                  .fadeIn(duration: const Duration(seconds: 1), delay: const Duration(milliseconds: 700)),
              ],
            ).animate()
              .fadeIn(duration: const Duration(seconds: 1)),
          ),
          // Bottom content
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Loading indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF34D399)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Calibrating sensors...',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                    ],
                  ),
                ).animate()
                  .fadeIn(duration: const Duration(seconds: 1), delay: const Duration(seconds: 1)),
                const SizedBox(height: 24),
                // Version
                Text(
                  'v2.0.4 • Powered by AI',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ).animate()
                  .fadeIn(duration: const Duration(seconds: 1), delay: const Duration(seconds: 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 0.5;

    const spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
