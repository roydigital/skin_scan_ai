import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:skin_scan_ai/state/scan_provider.dart';
import 'package:skin_scan_ai/theme.dart';
import 'dart:io';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _showHeatmap = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScanProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor.withOpacity(0.1),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Theme.of(context).textTheme.bodyLarge?.color),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  Text(
                    'Scan Results',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor.withOpacity(0.1),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.share, color: Theme.of(context).textTheme.bodyLarge?.color),
                      onPressed: () {
                        // TODO: Implement share functionality
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: provider.analysisResults != null
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        // Hero Image Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: AspectRatio(
                            aspectRatio: 4 / 5,
                            child: Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Stack(
                                  children: [
                                    // Base Image
                                    Positioned.fill(
                                      child: provider.capturedImagePath != null
                                        ? Image.file(
                                            File(provider.capturedImagePath!),
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/images/camera_placeholder.png',
                                            fit: BoxFit.cover,
                                          ),
                                    ),
                                    // Analysis Complete Badge
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: AppTheme.primaryGreen,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Analysis Complete',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Heatmap Overlay
                                    if (_showHeatmap)
                                      Positioned.fill(
                                        child: ShaderMask(
                                          shaderCallback: (bounds) => RadialGradient(
                                            center: Alignment(0.2, -0.3),
                                            radius: 0.8,
                                            colors: [
                                              Colors.red.withOpacity(0.4),
                                              Colors.orange.withOpacity(0.3),
                                              Colors.transparent,
                                            ],
                                            stops: [0.0, 0.5, 1.0],
                                          ).createShader(bounds),
                                          blendMode: BlendMode.overlay,
                                          child: Container(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Heatmap Toggle Card
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryGreen.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.heat_pump, // Using heat_pump as heatmap icon
                                      color: AppTheme.primaryGreen,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Heatmap Overlay',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context).textTheme.bodyLarge?.color,
                                          ),
                                        ),
                                        Text(
                                          'Identify problem areas',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: _showHeatmap,
                                    onChanged: (value) {
                                      setState(() {
                                        _showHeatmap = value;
                                      });
                                    },
                                    activeColor: AppTheme.primaryGreen,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Score Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                children: [
                                  CircularPercentIndicator(
                                    radius: 80.0,
                                    lineWidth: 12.0,
                                    percent: (provider.analysisResults!['overallScore'] as int) / 100,
                                    center: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${provider.analysisResults!['overallScore']}',
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.bodyLarge?.color,
                                          ),
                                        ),
                                        Text(
                                          'out of 100',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                    progressColor: AppTheme.primaryGreen,
                                    backgroundColor: Colors.grey.shade200,
                                    circularStrokeCap: CircularStrokeCap.round,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    provider.analysisResults!['condition'] as String,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Your skin barrier is strong. Minor attention needed for hydration.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Concern Breakdown List
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Concern Breakdown',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // TODO: Navigate to history screen
                                    },
                                    child: Text(
                                      'View History',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.primaryGreen,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ...List<Map<String, dynamic>>.from(provider.analysisResults!['concerns'] ?? []).map((concern) {
                                // Get icon based on concern name
                                IconData getIcon(String name) {
                                  switch (name) {
                                    case 'Acne & Blemishes':
                                      return Icons.healing;
                                    case 'Fine Lines & Wrinkles':
                                      return Icons.face;
                                    case 'Dryness & Flaking':
                                      return Icons.water_drop;
                                    case 'Oily Skin':
                                      return Icons.wb_sunny;
                                    case 'Redness & Irritation':
                                      return Icons.local_fire_department;
                                    case 'Large Pores':
                                    case 'Texture':
                                      return Icons.texture;
                                    default:
                                      return Icons.help_outline;
                                  }
                                }

                                // Get severity color
                                Color getSeverityColor(String level) {
                                  switch (level.toLowerCase()) {
                                    case 'low':
                                    case 'good':
                                      return AppTheme.primaryGreen;
                                    case 'moderate':
                                      return Colors.orange;
                                    case 'high':
                                      return Colors.red;
                                    default:
                                      return Colors.grey;
                                  }
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                getIcon(concern['name'] as String),
                                                size: 24,
                                                color: Theme.of(context).textTheme.bodyLarge?.color,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  concern['name'] as String,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: getSeverityColor(concern['level'] as String).withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  concern['level'] as String,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: getSeverityColor(concern['level'] as String),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: LinearProgressIndicator(
                                                  value: (concern['percentage'] as int) / 100,
                                                  backgroundColor: Colors.grey.shade200,
                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                    getSeverityColor(concern['level'] as String),
                                                  ),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                '${concern['percentage']}%',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                        const SizedBox(height: 100), // Space for sticky footer
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No results found',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Please complete the quiz to get your skin analysis.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () => context.push('/quiz'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Take Quiz',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          ],
        ),
      ),

      // Footer
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Container(
          height: 80, // Space for gradient fade
          child: Stack(
            children: [
              // Gradient fade background
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                        Theme.of(context).scaffoldBackgroundColor,
                      ],
                    ),
                  ),
                ),
              ),
              // Button
              Positioned(
                bottom: 16,
                left: 20,
                right: 20,
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => context.push('/routine'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16), // rounded-2xl
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Build My Routine',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
