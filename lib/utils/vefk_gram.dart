import 'package:flutter/material.dart';

/// Hexagram (12,3,9) — ilk 6 hane sıralı, son 3 hane kalan kadar kaydırılır.
/// Septagram (30,4,16) ve Octagram (60,5,25) — kalan kadar baştan dolar,
/// bir hane atlanır, geri kalanı sıralı devam eder.

List<int> _hexagramValues(int anaSayi) {
  final b = (anaSayi - 12) ~/ 3;
  final k = (anaSayi - 12) % 3;
  return [
    for (var i = 0; i < 6; i++) b + i,
    for (var i = 0; i < 3; i++) b + 6 + k + i,
  ];
}

List<int> _skipPatternValues(int anaSayi, int cikan, int bolen, int count) {
  final b = (anaSayi - cikan) ~/ bolen;
  final k = (anaSayi - cikan) % bolen;
  final firstCount = count - bolen * k;
  return [
    for (var i = 0; i < firstCount; i++) b + i,
    for (var i = 0; i < bolen * k; i++) b + firstCount + 1 + i,
  ];
}

class GramCell {
  const GramCell(this.relX, this.relY, this.value);
  final double relX;
  final double relY;
  final int value;
}

/// label → (relX, relY) — orijinal WinForms koordinatlarından (px / boyut)
/// hexagram pictureBox: 454 x 454
const _hexagramCoords = <int, (double, double)>{
  1: (0.7026, 0.6189),
  2: (0.4736, 0.1850),
  3: (0.2247, 0.6189),
  4: (0.1564, 0.4868),
  5: (0.4736, 0.4868),
  6: (0.7819, 0.4868),
  7: (0.7291, 0.3326),
  8: (0.4736, 0.7731),
  9: (0.2247, 0.3326),
};

/// septagram pictureBox: 804 x 506
const _septagramCoords = <int, (double, double)>{
  1: (0.7450, 0.2846),
  2: (0.3197, 0.4625),
  3: (0.1169, 0.6166),
  4: (0.6331, 0.8439),
  5: (0.3197, 0.8439),
  6: (0.8346, 0.6166),
  7: (0.6754, 0.4625),
  8: (0.1629, 0.2846),
  9: (0.6754, 0.6166),
  10: (0.1082, 0.8439),
  11: (0.3197, 0.3439),
  12: (0.8346, 0.4209),
  13: (0.1082, 0.4209),
  14: (0.6667, 0.3439),
  15: (0.8259, 0.8439),
  16: (0.3197, 0.6166),
};

/// octagram pictureBox: 1070 x 554
const _octagramCoords = <int, (double, double)>{
  1: (0.7075, 0.2202),
  2: (0.6467, 0.4928),
  3: (0.5000, 0.8574),
  4: (0.3682, 0.3466),
  5: (0.1458, 0.6534),
  6: (0.1458, 0.4928),
  7: (0.7075, 0.7744),
  8: (0.6402, 0.3466),
  9: (0.5000, 0.6534),
  10: (0.3682, 0.1408),
  11: (0.3682, 0.8845),
  12: (0.1458, 0.3466),
  13: (0.8308, 0.6534),
  14: (0.6402, 0.1408),
  15: (0.4935, 0.4928),
  16: (0.4935, 0.3466),
  17: (0.3682, 0.6715),
  18: (0.2430, 0.2202),
  19: (0.8308, 0.4928),
  20: (0.6402, 0.8574),
  21: (0.6467, 0.6534),
  22: (0.4935, 0.1408),
  23: (0.3682, 0.4928),
  24: (0.2430, 0.7564),
  25: (0.8308, 0.3466),
};

List<GramCell> _cells(
  Map<int, (double, double)> coords,
  List<int> values,
) {
  return [
    for (final e in coords.entries)
      GramCell(e.value.$1, e.value.$2, values[e.key - 1]),
  ];
}

List<GramCell> hexagramCells(int anaSayi) =>
    _cells(_hexagramCoords, _hexagramValues(anaSayi));

List<GramCell> septagramCells(int anaSayi) =>
    _cells(_septagramCoords, _skipPatternValues(anaSayi, 30, 4, 16));

List<GramCell> octagramCells(int anaSayi) =>
    _cells(_octagramCoords, _skipPatternValues(anaSayi, 60, 5, 25));

/// Yıldız görseli üzerine sayıları tam konumuna yerleştirir.
Widget buildGramDiagram({
  required List<GramCell> cells,
  required String imageAsset,
  required double aspectRatio,
  required double width,
}) {
  final height = width / aspectRatio;
  final cellSize = (width * 0.11).clamp(28.0, 52.0);
  return SizedBox(
    width: width,
    height: height,
    child: Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            imageAsset,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
        for (final c in cells)
          Positioned(
            left: c.relX * width - cellSize / 2,
            top: c.relY * height - cellSize / 2,
            width: cellSize,
            height: cellSize,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                border: Border.all(color: Colors.grey.shade700, width: 1.2),
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  c.value.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
