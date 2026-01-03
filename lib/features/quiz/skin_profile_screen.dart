import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_scan_ai/theme.dart';

class SkinProfileScreen extends StatefulWidget {
  const SkinProfileScreen({super.key});

  @override
  State<SkinProfileScreen> createState() => _SkinProfileScreenState();
}

class _SkinProfileScreenState extends State<SkinProfileScreen> {
  final List<String> selectedConcerns = [];
  bool noConcerns = false;

  final List<Map<String, dynamic>> concerns = [
    {'title': 'Acne & Blemishes', 'icon': Icons.healing},
    {'title': 'Fine Lines & Wrinkles', 'icon': Icons.face},
    {'title': 'Dryness & Flaking', 'icon': Icons.water_drop},
    {'title': 'Oily Skin', 'icon': Icons.wb_sunny},
    {'title': 'Redness & Irritation', 'icon': Icons.local_fire_department},
    {'title': 'Large Pores', 'icon': Icons.texture},
  ];

  void toggleConcern(String title) {
    setState(() {
      if (selectedConcerns.contains(title)) {
        selectedConcerns.remove(title);
      } else {
        selectedConcerns.add(title);
      }
      if (noConcerns && selectedConcerns.isNotEmpty) {
        noConcerns = false;
      }
    });
  }

  void toggleNoConcerns(bool? value) {
    setState(() {
      noConcerns = value ?? false;
      if (noConcerns) {
        selectedConcerns.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Skin Profile'),
        actions: [
          TextButton(
            onPressed: () => print('Skip pressed'),
            child: const Text('Skip'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: index == 0
                                ? AppTheme.primaryGreen
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  const Text('Step 1 of 5'),
                ],
              ),
            ),
            // Question Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'What is your primary ',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'skin concern?',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select all that apply so our AI can tailor your routine accurately.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Grid of Cards
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: concerns.length,
                  itemBuilder: (context, index) {
                    final concern = concerns[index];
                    final isSelected = selectedConcerns.contains(concern['title']);
                    return GestureDetector(
                      onTap: () => toggleConcern(concern['title']),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryGreen.withOpacity(0.1)
                              : Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryGreen
                                : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  concern['icon'],
                                  size: 32,
                                  color: isSelected
                                      ? AppTheme.primaryGreen
                                      : Colors.grey.shade600,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  concern['title'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? AppTheme.primaryGreen
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            if (isSelected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Bottom Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: noConcerns,
                        onChanged: toggleNoConcerns,
                        activeColor: AppTheme.primaryGreen,
                      ),
                      const Expanded(
                        child: Text("I don't have any specific concerns"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push('/camera'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
