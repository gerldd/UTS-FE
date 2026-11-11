String rupiah(num value) {
  final digits = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final fromEnd = digits.length - i;
    buffer.write(digits[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write('.');
  }
  return 'Rp $buffer';
}

String decimalId(double value, [int digits = 1]) =>
    value.toStringAsFixed(digits).replaceAll('.', ',');
