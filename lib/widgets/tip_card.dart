import 'package:flutter/material.dart';
import '../models/data.dart';
import '../theme/app_theme.dart';

class TipCard extends StatelessWidget {
  const TipCard({super.key, required this.tip, required this.onTap});

  final Tip tip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: double.infinity,
              color: scheme.primaryContainer,
              alignment: Alignment.center,
              child: Text(tip.emoji, style: const TextStyle(fontSize: 36)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip.category,
                      style: text.labelLarge?.copyWith(color: scheme.primary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      tip.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleMedium,
                    ),
                    const Spacer(),
                    Text(
                      '${tip.minutes} min read',
                      style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
