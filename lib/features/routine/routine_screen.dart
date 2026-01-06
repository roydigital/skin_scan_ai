import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skin_scan_ai/state/scan_provider.dart';
import 'package:skin_scan_ai/theme.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  bool _isMorning = true;
  final Map<String, List<bool>> _checkedStates = {
    'AM': [false, false, false],
    'PM': [false, false, false],
  };

  // Mock data for routines
  final _amRoutine = const [
    {
      'title': 'Cleanse',
      'brand': 'CETAPHIL',
      'product': 'DermaControl Oil Control',
      'image': 'assets/images/product_cleanser.png',
      'badge': 'Matches dry skin profile',
    },
    {
      'title': 'Treat',
      'brand': 'THE ORDINARY',
      'product': 'Vitamin C Suspension',
      'image': 'assets/images/product_vitamin_c.png',
      'badge': 'Matches dry skin profile',
    },
    {
      'title': 'Protect',
      'brand': 'LA ROCHE-POSAY',
      'product': 'Anthelios Melt-In Milk',
      'image': 'assets/images/product_spf.png',
      'badge': 'Matches dry skin profile',
    },
  ];

  final _pmRoutine = const [
    {
      'title': 'Cleanse',
      'brand': 'CETAPHIL',
      'product': 'DermaControl Oil Control',
      'image': 'assets/images/product_cleanser.png',
      'badge': 'Matches dry skin profile',
    },
    {
      'title': 'Treat',
      'brand': 'THE ORDINARY',
      'product': 'Retinol 0.5%',
      'image': 'assets/images/product_retinol.png',
      'badge': 'Matches dry skin profile',
    },
    {
      'title': 'Moisturize',
      'brand': 'CERAVE',
      'product': 'Moisturizing Cream',
      'image': 'assets/images/product_moisturizer.png',
      'badge': 'Matches dry skin profile',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentDate = DateFormat('EEEE, MMMM d').format(DateTime.now());
    final currentRoutine = _isMorning ? _amRoutine : _pmRoutine;
    final routineKey = _isMorning ? 'AM' : 'PM';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Date Scroller
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MMM d').format(DateTime.now()),
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your Daily Regimen',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Date Scroller
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          final dayOffset = index - 2; // -2, -1, 0, 1, 2
                          final date = DateTime.now().add(Duration(days: dayOffset));
                          final isToday = dayOffset == 0;
                          final dayLabel = DateFormat('E').format(date)[0]; // M, T, W, etc.
                          final dayNumber = DateFormat('d').format(date);

                          return Container(
                            width: 50,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: isToday ? AppTheme.primaryGreen : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dayLabel,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isToday ? Colors.white : Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  dayNumber,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isToday ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // AM/PM Toggle with Sliding Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final containerWidth = constraints.maxWidth;
                  return Container(
                    height: 50,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Stack(
                      children: [
                        // Sliding Indicator
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 200),
                          left: _isMorning ? 4 : containerWidth / 2 + 4,
                          top: 4,
                          bottom: 4,
                          right: _isMorning ? containerWidth / 2 - 4 : 4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen,
                              borderRadius: BorderRadius.circular(21),
                            ),
                          ),
                        ),
                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _isMorning = true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.wb_sunny,
                                        color: _isMorning ? Colors.white : Colors.grey,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Morning',
                                        style: GoogleFonts.spaceGrotesk(
                                          color: _isMorning ? Colors.white : Colors.grey,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _isMorning = false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.nightlight_round,
                                        color: !_isMorning ? Colors.white : Colors.grey,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Evening',
                                        style: GoogleFonts.spaceGrotesk(
                                          color: !_isMorning ? Colors.white : Colors.grey,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // Routine Timeline
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Stack(
                    children: [
                      // Continuous Timeline Line
                      Positioned(
                        left: 20, // Center of the 40px circle
                        top: 20,
                        bottom: 20,
                        child: Container(
                          width: 2,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      // Routine Steps
                      Column(
                        children: List.generate(currentRoutine.length, (index) {
                          final step = currentRoutine[index];
                          final isChecked = _checkedStates[routineKey]![index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Timeline Circle
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isChecked ? AppTheme.primaryGreen : Colors.grey.shade200,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: isChecked ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // Step Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Step Title
                                      Text(
                                        step['title'] as String,
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      // Product Card
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            children: [
                                              // Product Details (Left)
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    // Brand
                                                    Text(
                                                      (step['brand'] as String).toUpperCase(),
                                                      style: GoogleFonts.spaceGrotesk(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.w500,
                                                        letterSpacing: 1,
                                                      ),
                                                    ),

                                                    const SizedBox(height: 4),

                                                    // Product Name
                                                    Text(
                                                      step['product'] as String,
                                                      style: GoogleFonts.spaceGrotesk(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),

                                                    const SizedBox(height: 8),

                                                    // AI Match Badge
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: AppTheme.primaryGreen.withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.auto_awesome,
                                                            size: 14,
                                                            color: AppTheme.primaryGreen,
                                                          ),
                                                          const SizedBox(width: 4),
                                                          Flexible(
                                                            child: Text(
                                                              step['badge'] as String,
                                                              style: GoogleFonts.spaceGrotesk(
                                                                fontSize: 12,
                                                                color: AppTheme.primaryGreen,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    const SizedBox(height: 12),

                                                    // Check Off Button
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _checkedStates[routineKey]![index] = !isChecked;
                                                          });
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.grey.shade200,
                                                          foregroundColor: Colors.black,
                                                          elevation: 0,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(
                                                              isChecked ? Icons.check_circle : Icons.check_circle_outline,
                                                              color: isChecked ? AppTheme.primaryGreen : Colors.grey,
                                                              size: 20,
                                                            ),
                                                            const SizedBox(width: 8),
                                                            Text(
                                                              'Check off',
                                                              style: GoogleFonts.spaceGrotesk(
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(width: 16),

                                              // Product Image (Right, Large)
                                              Container(
                                                width: 100,
                                                height: 120,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade100,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.image,
                                                  color: Colors.grey,
                                                  size: 50,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 16.0,
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.face, 'Scan', () => context.push('/camera')),
              _buildNavItem(Icons.spa, 'Routine', null, isActive: true),
              _buildNavItem(Icons.person, 'Profile', () => _showDevModeSheet(context)),
            ],
          ),
        ),
      ),
    );
  }

  void _showDevModeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Consumer<ScanProvider>(
          builder: (context, provider, child) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Dev Mode',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    title: const Text('Simulate Premium Subscription'),
                    value: provider.isPremiumMode,
                    onChanged: (value) {
                      provider.togglePremiumMode();
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Current AI Model: ${provider.isPremiumMode ? 'Gemini 2.5 Pro' : 'Gemini 2.0 Flash'}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNavItem(IconData icon, String label, VoidCallback? onTap, {bool isActive = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppTheme.primaryGreen : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppTheme.primaryGreen : Colors.grey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
