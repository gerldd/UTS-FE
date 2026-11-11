import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../main.dart'; // Menghubungkan ke AppShell utama

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingItem> _items = [
    const OnboardingItem(
      emoji: '⚡',
      title: 'Hitung Tagihan Sekejap',
      description: 'Simulasikan pemakaian perangkat elektronik harianmu dan ketahui estimasi biaya tagihan listrik secara akurat.',
    ),
    const OnboardingItem(
      emoji: '💡',
      title: 'Tips Hemat Energi Pintar',
      description: 'Temukan berbagai tips praktis sehari-hari untuk memangkas pengeluaran listrik tanpa mengurangi kenyamanan.',
    ),
    const OnboardingItem(
      emoji: '🌱',
      title: 'Mendukung SDG 7',
      description: 'Bersama WattWise, wujudkan kesadaran energi bersih dan terbarukan untuk masa depan bumi yang lebih baik.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Tombol Lewati (Skip) di atas
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => _finishOnboarding(context),
                  child: Text('Lewati', style: TextStyle(color: scheme.onSurfaceVariant)),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _items.length,
                  onPageChanged: (index) => setState(() => _currentIndex = index),
                  itemBuilder: (context, i) {
                    final item = _items[i];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 140,
                          width: 140,
                          decoration: BoxDecoration(
                            color: scheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(item.emoji, style: const TextStyle(fontSize: 64)),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          item.title,
                          style: text.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          item.description,
                          style: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
              // Indikator Titik (Dots) & Tombol Navigasi Bawah
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indikator Dots
                  Row(
                    children: List.generate(
                      _items.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 6),
                        height: 8,
                        width: _currentIndex == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index ? scheme.primary : scheme.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Tombol Lanjut / Mulai
                  FilledButton(
                    onPressed: () {
                      if (_currentIndex < _items.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _finishOnboarding(context);
                      }
                    },
                    child: Text(_currentIndex == _items.length - 1 ? 'Mulai Sekarang' : 'Lanjut'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _finishOnboarding(BuildContext context) {
    // Navigasi ke halaman utama aplikasi (AppShell)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AppShell()),
    );
  }
}

class OnboardingItem {
  const OnboardingItem({
    required this.emoji,
    required this.title,
    required this.description,
  });

  final String emoji;
  final String title;
  final String description;
}