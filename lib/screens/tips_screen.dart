import 'package:flutter/material.dart';
import '../models/data.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/tip_card.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  static const _categories = ['Semua', 'Anak Kost', 'AC & Pendingin', 'Dapur', 'Lampu'];
  String _category = 'Semua';
  String _query = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Tip> get _filtered {
    return tips.where((t) {
      final inCategory = _category == 'Semua' || t.category == _category;
      final matches = '${t.title} ${t.summary}'.toLowerCase().contains(_query.toLowerCase());
      return inCategory && matches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return ResponsiveBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kotak Pencarian Tips
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Cari tips hemat energi...',
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _query = '';
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),
          
          // Pilihan Kategori Kapsul (ChoiceChip) secara Horizontal
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: _categories.length,
             separatorBuilder: (_, index) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, i) => ChoiceChip(
                label: Text(_categories[i]),
                selected: _category == _categories[i],
                onSelected: (_) => setState(() => _category = _categories[i]),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Daftar Grid Tips atau Tampilan Kosong
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 48, color: Colors.grey),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Tidak ada tips yang cocok.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 340,
                      mainAxisExtent: 250,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, i) => TipCard(
                      tip: items[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TipDetailScreen(tip: items[i]),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class TipDetailScreen extends StatelessWidget {
  const TipDetailScreen({super.key, required this.tip});

  final Tip tip;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(title: Text(tip.category)),
      body: ResponsiveBody(
        maxWidth: 800,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text(tip.title, style: text.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: scheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  '${tip.minutes} min read',
                  style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(tip.emoji, style: const TextStyle(fontSize: 64)),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Langkah-langkah:', style: text.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            for (var i = 0; i < tip.points.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: scheme.primaryContainer,
                    foregroundColor: scheme.primary,
                    child: Text('${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  title: Text(tip.points[i], style: text.bodyLarge),
                ),
              ),
          ],
        ),
      ),
    );
  }
}