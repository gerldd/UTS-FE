import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import 'login_sheet.dart';
import 'register_sheet.dart';
import 'notification_screen.dart';
import 'help_screen.dart';

final ValueNotifier<bool> authNotifier = ValueNotifier<bool>(false);
final ValueNotifier<String> userNameNotifier = ValueNotifier<String>('.'); 
final ValueNotifier<String> userEmailNotifier = ValueNotifier<String>('');

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return ValueListenableBuilder<bool>(
      valueListenable: authNotifier,
      builder: (context, isLoggedIn, _) {
        // ====================================================
        // 1. TAMPILAN JIKA BELUM LOGIN (OPSI LOGIN / REGISTRASI)
        // ====================================================
        if (!isLoggedIn) {
          return ResponsiveBody(
            maxWidth: 500,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer.withAlpha(100),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person_outline, size: 72, color: scheme.primary),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Belum Masuk Akun', style: text.headlineSmall),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Silakan masuk atau buat akun baru untuk menyimpan riwayat simulasi dan menikmati fitur lengkap.',
                      textAlign: TextAlign.center,
                      style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Tombol Buka Form Login
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => showLoginSheet(context),
                        icon: const Icon(Icons.login),
                        label: const Text('Masuk ke Akun'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Tombol Buka Form Registrasi
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => showRegisterSheet(context),
                        icon: const Icon(Icons.person_add_outlined),
                        label: const Text('Daftar Akun Baru'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // ====================================================
        // 2. TAMPILAN PROFIL JIKA SUDAH LOGIN (DINAMIS SESUAI USER)
        // ====================================================
        return ValueListenableBuilder<String>(
          valueListenable: userNameNotifier,
          builder: (context, currentName, _) {
            return ValueListenableBuilder<String>(
              valueListenable: userEmailNotifier,
              builder: (context, currentEmail, _) {
                final initial = currentName.isNotEmpty ? currentName[0].toUpperCase() : '';

                return ResponsiveBody(
                  maxWidth: 800,
                  child: ListView(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [scheme.primary, scheme.tertiary],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -44,
                            child: CircleAvatar(
                              radius: 48,
                              backgroundColor: scheme.surface,
                              child: CircleAvatar(
                                radius: 42,
                                child: Text(initial, style: text.headlineMedium),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 56),
                      Center(child: Text(currentName, style: text.titleLarge)),
                      Center(
                        child: Text(
                          currentEmail,
                          style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Navigasi ke Notifikasi
                      ListTile(
                        leading: const Icon(Icons.notifications_outlined),
                        title: const Text('Notifikasi'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NotificationScreen()),
                        ),
                      ),
                      
                      // Navigasi ke Bantuan
                      ListTile(
                        leading: const Icon(Icons.help_outline),
                        title: const Text('Bantuan'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HelpScreen()),
                        ),
                      ),
                      
                      // Tombol Logout / Keluar
                      ListTile(
                        leading: Icon(Icons.logout, color: scheme.error),
                        title: Text('Keluar Akun', style: TextStyle(color: scheme.error, fontWeight: FontWeight.bold)),
                        onTap: () {
                          authNotifier.value = false;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Berhasil keluar akun.')),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}