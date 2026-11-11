import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/stat_card.dart';
import 'profile_screen.dart'; // Import untuk mengakses authNotifier dan userNameNotifier

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onStartCalc});

  final VoidCallback onStartCalc;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final stats = [
      const StatCard(icon: Icons.bolt, label: 'Estimasi bulan ini', value: 'Rp 148.205'),
      const StatCard(icon: Icons.speed, label: 'Total pemakaian', value: '102,6 kWh'),
    ];

    return ResponsiveBody(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Sinkronisasi Sapaan dan Avatar Berdasarkan Status Login Akun
          ValueListenableBuilder<bool>(
            valueListenable: authNotifier,
            builder: (context, isLoggedIn, _) {
              return ValueListenableBuilder<String>(
                valueListenable: userNameNotifier,
                builder: (context, currentName, _) {
                  final greetingName = isLoggedIn ? currentName : 'Tamu / Pengguna';
                  final initial = isLoggedIn && currentName.isNotEmpty ? currentName[0].toUpperCase() : 'G';

                  return Row(
                    children: [
                      CircleAvatar(radius: 24, child: Text(initial)),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo, $greetingName',
                              style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                            Text('Hitung & pangkas tagihanmu', style: text.titleLarge),
                          ],
                        ),
                      ),
                      const Icon(Icons.notifications_outlined),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Chip(label: Text('🌱 Solusi Cerdas Energi')),
                const SizedBox(height: AppSpacing.md),
                RichText(
                  text: TextSpan(
                    style: text.headlineSmall?.copyWith(color: scheme.onSurface),
                    children: [
                      const TextSpan(text: 'Hitung & Pangkas '),
                      TextSpan(
                        text: 'Tagihan Listrik',
                        style: TextStyle(color: scheme.primary),
                      ),
                      const TextSpan(text: ' Rumahmu Hari Ini'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Simulasikan penggunaan elektronik harian dan temukan cara menghemat pengeluaran bulananmu.',
                  style: text.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton.icon(
                  onPressed: onStartCalc,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Coba Kalkulator Sekarang'),
                ),
                const SizedBox(height: AppSpacing.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://picsum.photos/seed/wattwise/800/360',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      height: 150,
                      width: double.infinity,
                      color: scheme.surface,
                      alignment: Alignment.center,
                      child: Icon(Icons.home_work_outlined, size: 56, color: scheme.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          Text('Ringkasan', style: text.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          
          // Ringkasan selalu horizontal (sejajar)
          Row(
            children: [
              Expanded(child: stats[0]),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: stats[1]),
            ],
          ),
        ],
      ),
    );
  }
}