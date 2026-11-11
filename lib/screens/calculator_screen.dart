import 'package:flutter/material.dart';
import '../models/data.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../utils/responsive.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _tariffKey = tariffs.keys.first;
  final List<Device> _devices = [
    Device('AC 1/2 PK', 350, 8, count: 1),
    Device('Kulkas', 80, 6, count: 1),
    Device('Lampu LED', 9, 8, count: 4), // Contoh: 4 buah lampu
    Device('TV', 45, 1.5, count: 1),
  ];

  double get _tariff => tariffs[_tariffKey]!;
  double get _kwh => _devices.fold(0.0, (sum, d) => sum + d.kwhPerMonth);
  double get _bill => _kwh * _tariff;

  Future<void> _addDevice() async {
    final nameCtrl = TextEditingController();
    final wattCtrl = TextEditingController();
    final countCtrl = TextEditingController(text: '1'); // Default jumlah 1

    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tambah Perangkat'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama perangkat'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: wattCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Daya per satuan (Watt)'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: countCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jumlah perangkat (unit)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    final watt = double.tryParse(wattCtrl.text.trim());
    final count = int.tryParse(countCtrl.text.trim()) ?? 1;

    if (nameCtrl.text.trim().isEmpty || watt == null || watt <= 0 || count <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi nama, daya, dan jumlah dengan benar.')),
      );
      return;
    }
    setState(() => _devices.add(Device(nameCtrl.text.trim(), watt, 2, count: count)));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: ResponsiveBody(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 800;
            final form = _buildForm(context);
            final result = _buildResult(context);
            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: form),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(flex: 2, child: result),
                ],
              );
            }
            return Column(
              children: [
                result,
                const SizedBox(height: AppSpacing.md),
                form,
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kalkulator Simulasi Listrik', style: text.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _tariffKey,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Golongan tarif PLN'),
            items: tariffs.keys
                .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                .toList(),
            onChanged: (v) => setState(() => _tariffKey = v ?? _tariffKey),
          ),
          const SizedBox(height: AppSpacing.md),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _devices.length,
            itemBuilder: (context, i) => _deviceCard(context, i),
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: _addDevice,
              icon: const Icon(Icons.add),
              label: const Text('Tambah Perangkat Lain'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deviceCard(BuildContext context, int i) {
    final d = _devices[i];
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final totalWatt = d.watt * d.count;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withAlpha(90),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.name, style: text.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        '${d.count} unit • ${d.watt.toStringAsFixed(0)}W/unit (Total: ${totalWatt.toStringAsFixed(0)}W)',
                        style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Hapus perangkat',
                  onPressed: _devices.length > 1
                      ? () => setState(() => _devices.removeAt(i))
                      : null,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Text('Durasi'),
                Expanded(
                  child: Slider(
                    value: d.hours,
                    min: 0.5,
                    max: 24,
                    divisions: 47,
                    label: '${decimalId(d.hours)} jam',
                    onChanged: (v) => setState(() => d.hours = v),
                  ),
                ),
                SizedBox(
                  width: 64,
                  child: Text(
                    '${decimalId(d.hours)} jam',
                    textAlign: TextAlign.end,
                    style: text.labelLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    final String status;
    if (_kwh < 60) {
      status = '🟢 Pemakaian Hemat';
    } else if (_kwh < 100) {
      status = '🟡 Pemakaian Wajar';
    } else {
      status = '🔴 Pemakaian Sedikit Boros';
    }

    final top = _devices.reduce((a, b) => a.kwhPerMonth >= b.kwhPerMonth ? a : b);
    final cutHours = top.hours < 2 ? top.hours : 2.0;
    final saving = cutHours * top.watt * top.count / 1000 * 30 * _tariff;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total estimasi tagihan',
              style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(rupiah(_bill), style: text.headlineMedium),
            Text('/ bulan', style: text.bodyMedium),
            const Divider(height: AppSpacing.lg),
            _statRow('Total pemakaian', '${decimalId(_kwh)} kWh / bulan'),
            _statRow('Estimasi harian', '${rupiah(_bill / 30)} / hari'),
            const SizedBox(height: AppSpacing.sm),
            Chip(label: Text(status)),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Tips: Kurangi pemakaian ${top.name} (${top.count} unit) ${decimalId(cutHours)} jam sehari '
                'untuk menghemat sekitar ${rupiah(saving)} setiap bulannya!',
                style: text.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label)),
          const SizedBox(width: AppSpacing.sm),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}