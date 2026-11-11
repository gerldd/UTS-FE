import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

class NotificationItemModel {
  const NotificationItemModel({
    required this.title,
    required this.desc,
    required this.time,
  });

  final String title;
  final String desc;
  final String time;
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static final List<NotificationItemModel> _notifications = [
    NotificationItemModel(
      title: 'Tips Mingguan Tersedia! 💡',
      desc: 'Pelajari cara mengoptimalkan suhu AC agar tagihan tetap aman.',
      time: 'Kemarin, 19:00',
    ),
    NotificationItemModel(
      title: 'Simulasi Berhasil Disimpan ⚡',
      desc: 'Simulasi tagihan rumah bulan September telah dicatat ke riwayat.',
      time: '05 Sep 2026',
    ),
    NotificationItemModel(
      title: 'Selamat Datang di WattWise! 🌱',
      desc: 'Mulai hitung perangkat elektronikmu dan dukung gerakan SDG 7.',
      time: '01 Sep 2026',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi')),
      body: ResponsiveBody(
        maxWidth: 800,
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: _notifications.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, i) {
            final notif = _notifications[i];
            return Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: scheme.primaryContainer,
                    child: Icon(Icons.notifications_active, color: scheme.primary),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notif.title, style: text.titleMedium),
                        const SizedBox(height: 4),
                        Text(notif.desc, style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                        const SizedBox(height: 8),
                        Text(notif.time, style: text.labelLarge?.copyWith(color: scheme.primary, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}