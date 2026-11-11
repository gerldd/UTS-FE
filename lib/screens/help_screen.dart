import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Bantuan & FAQ')),
      body: ResponsiveBody(
        maxWidth: 800,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Butuh Bantuan?', style: text.titleLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Temukan jawaban cepat seputar cara menghitung tagihan listrik dan penggunaan aplikasi WattWise.',
                    style: text.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Pertanyaan Umum (FAQ)', style: text.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            const ExpansionTile(
              title: Text('Bagaimana cara menghitung kWh perangkat?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Text(
                    'Konsumsi kWh dihitung berdasarkan rumus: (Daya Watt × Jumlah Unit × Durasi Jam per Hari × 30 Hari) / 1000.',
                  ),
                ),
              ],
            ),
            const ExpansionTile(
              title: Text('Apakah golongan tarif PLN bisa diubah?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Text(
                    'Ya! Anda dapat mengubah golongan tarif melalui menu Pengaturan Tarif di halaman profil.',
                  ),
                ),
              ],
            ),
            const ExpansionTile(
              title: Text('Apa itu inisiatif SDG 7 di WattWise?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Text(
                    'SDG 7 adalah tujuan pembangunan berkelanjutan PBB untuk memastikan akses energi yang terjangkau, andal, berkelanjutan, dan modern bagi semua.',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}