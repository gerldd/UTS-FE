class Device {
  Device(this.name, this.watt, this.hours, {this.count = 1});
  String name;
  double watt; 
  double hours; 
  int count;
  
  double get kwhPerMonth => watt * count * hours * 30 / 1000;
}

const Map<String, double> tariffs = {
  'R-1/TR 1.300 VA - Rp 1.444,70/kWh': 1444.70,
  'R-1/TR 900 VA-RTM - Rp 1.352/kWh': 1352,
  'R-2/TR 3.500 VA - Rp 1.699,53/kWh': 1699.53,
};

class Tip {
  const Tip({
    required this.category,
    required this.emoji,
    required this.title,
    required this.summary,
    required this.minutes,
    required this.points,
  });

  final String category;
  final String emoji;
  final String title;
  final String summary;
  final int minutes;
  final List<String> points;
}

const List<Tip> tips = [
  Tip(
    category: 'AC & Pendingin',
    emoji: '❄️',
    title: '5 Trik Pakai AC Tetap Dingin Tanpa Tagihan Membengkak',
    summary: 'Suhu 24°C adalah kunci efisiensi energi yang optimal.',
    minutes: 3,
    points: [
      'Atur suhu 24°C-25°C. Jangan langsung ke 16°C karena kompresor bekerja ekstra keras.',
      'Gunakan fitur timer untuk mematikan AC 1 jam sebelum bangun tidur.',
      'Bersihkan filter rutin agar AC tidak bekerja lebih berat.',
    ],
  ),
  Tip(
    category: 'Anak Kost',
    emoji: '🏠',
    title: 'Hemat Listrik Kost 900 VA Tanpa Kena Trip',
    summary: 'Atur kapan alat dinyalakan agar listrik tidak turun.',
    minutes: 4,
    points: [
      'Hindari menyalakan rice cooker, setrika, dan kipas bersamaan.',
      'Cabut charger yang tidak dipakai.',
    ],
  ),
  Tip(
    category: 'Dapur',
    emoji: '🍳',
    title: 'Kulkas Hemat Energi: Cara Mengatur dan Merawat',
    summary: 'Pintu sering dibuka dan karet longgar menambah beban.',
    minutes: 3,
    points: [
      'Jangan isi kulkas terlalu penuh agar udara dingin bersirkulasi.',
      'Periksa karet pintu agar udara dingin tidak bocor.',
    ],
  ),
  Tip(
    category: 'Lampu',
    emoji: '💡',
    title: 'Ganti ke Lampu LED: Berapa Rupiah yang Dihemat?',
    summary: 'LED memakai daya jauh lebih kecil dari lampu pijar.',
    minutes: 2,
    points: [
      'Pilih watt sesuai kebutuhan ruangan.',
      'Matikan lampu saat keluar ruangan.',
    ],
  ),
  Tip(
    category: 'Anak Kost',
    emoji: '💻',
    title: 'Laptop dan Router: Alat Kecil yang Menyala 24 Jam',
    summary: 'Perangkat standby terlihat kecil tetapi menumpuk dalam sebulan.',
    minutes: 3,
    points: [
      'Gunakan colokan bersaklar untuk mematikan semua alat standby.',
      'Matikan router saat tidur jika tidak diperlukan.',
    ],
  ),
  Tip(
    category: 'Dapur',
    emoji: '🍚',
    title: 'Rice Cooker: Jangan Biarkan Mode Warm Menyala Seharian',
    summary: 'Mode warm terus menarik daya walau nasi sudah matang.',
    minutes: 3,
    points: [
      'Cabut rice cooker setelah nasi matang.',
      'Masak sesuai porsi agar waktu menyala lebih singkat.',
    ],
  ),
];