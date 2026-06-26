import 'dart:math' as math;

import 'ebced_calculator.dart';

/// Yıldızname cifir hesaplamaları — orijinal web (script.js) mantığının
/// birebir Dart portu.
class YildiznameCalc {
  /// Gezegen sırası (index 0-6) — orijinal planetInterpretations ile aynı.
  static const List<String> gezegenler = [
    'Güneş',
    'Ay',
    'Mars',
    'Merkür',
    'Jüpiter',
    'Venüs',
    'Satürn',
  ];

  // ── Element tablosu (harf → element + sıra 1-7) ──
  static const Map<String, (String, int)> _elementTable = {
    // Ateş: ا ه ط م ف ش ذ
    'ا': ('Ateş', 1), 'أ': ('Ateş', 1), 'إ': ('Ateş', 1), 'آ': ('Ateş', 1),
    'ء': ('Ateş', 1), 'ؤ': ('Ateş', 1), 'ئ': ('Ateş', 1),
    'ه': ('Ateş', 2), 'ة': ('Toprak', 6),
    'ط': ('Ateş', 3),
    'م': ('Ateş', 4),
    'ف': ('Ateş', 5),
    'ش': ('Ateş', 6),
    'ذ': ('Ateş', 7),
    // Toprak: ب و ي ن ص ت ض
    'ب': ('Toprak', 1), 'پ': ('Toprak', 1),
    'و': ('Toprak', 2),
    'ي': ('Toprak', 3), 'ى': ('Toprak', 3),
    'ن': ('Toprak', 4),
    'ص': ('Toprak', 5),
    'ت': ('Toprak', 6),
    'ض': ('Toprak', 7),
    // Hava: ج ز ك س ق ث ظ
    'ج': ('Hava', 1), 'چ': ('Hava', 1),
    'ز': ('Hava', 2), 'ژ': ('Hava', 2),
    'ك': ('Hava', 3), 'گ': ('Hava', 3), 'ڭ': ('Hava', 3), 'ک': ('Hava', 3),
    'ڪ': ('Hava', 3),
    'س': ('Hava', 4),
    'ق': ('Hava', 5),
    'ث': ('Hava', 6),
    'ظ': ('Hava', 7),
    // Su: د ح ل ع ر خ غ
    'د': ('Su', 1),
    'ح': ('Su', 2),
    'ل': ('Su', 3),
    'ع': ('Su', 4),
    'ر': ('Su', 5),
    'خ': ('Su', 6),
    'غ': ('Su', 7),
  };

  /// İsmin element dağılımı — her harfin sırası (1-7) toplanır (orijinal mantık).
  static Map<String, int> elementAnaliz(String isim) {
    final totals = {'Ateş': 0, 'Hava': 0, 'Su': 0, 'Toprak': 0};
    final temiz = EbcedCalculator.temizle(isim);
    for (var i = 0; i < temiz.length; i++) {
      final c = temiz[i];
      final entry = _elementTable[c];
      if (entry != null) {
        totals[entry.$1] = totals[entry.$1]! + entry.$2;
      }
    }
    return totals;
  }

  // ── Hicri takvim (Julian Day tabanlı — script.js birebir) ──

  static double miladiToJD(int year, int month, int day) {
    if (month <= 2) {
      year -= 1;
      month += 12;
    }
    final a = (year / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() +
        day +
        b -
        1524.5;
  }

  static int _hicriToJD(int year, int month, int day) {
    return ((11 * year + 3) / 30).floor() +
        354 * year +
        30 * month -
        ((month - 1) / 2).floor() +
        day +
        1948440 -
        385;
  }

  /// JD → Hicri {year, month, day} — günlük sapma düzeltmesi (+1) dahil.
  static Map<String, int> jdToHicri(double jd) {
    final jd1 = (jd + 1).floor() + 0.5;
    final year = ((30 * (jd1 - 1948439.5) + 10646) / 10631).floor();
    final month = math.min(
      12,
      ((jd1 - 29 - _hicriToJD(year, 1, 1)) / 29.5).ceil() + 1,
    );
    final day = (jd1 - _hicriToJD(year, month, 1)).floor() + 1;
    return {'year': year, 'month': month, 'day': day};
  }

  static Map<String, int> miladiToHicri(int year, int month, int day) {
    return jdToHicri(miladiToJD(year, month, day));
  }

  static int mod7(int v) {
    final r = v % 7;
    return r < 0 ? r + 7 : r;
  }
}
