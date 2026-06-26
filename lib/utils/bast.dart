/// Bast tablosu ve ebced değerinden isim/kelime üretimi.
class BastCalc {
  static const List<(String harf, int bas4, int bas5)> tablo = [
    ('ا', 1641, 991),
    ('ب', 1046, 921),
    ('ج', 451, 1118),
    ('د', 1995, 2011),
    ('ه', 1783, 2007),
    ('و', 1832, 2482),
    ('ز', 1980, 1364),
    ('ح', 1288, 1889),
    ('ط', 1616, 1683),
    ('ي', 2243, 2616),
    ('ك', 1968, 1843),
    ('ل', 1086, 1239),
    ('م', 2439, 2703),
    ('ن', 1843, 2149),
    ('س', 1748, 1260),
    ('ع', 1997, 1443),
    ('ف', 1843, 2149),
    ('ص', 2513, 3113),
    ('ق', 1309, 1748),
    ('ر', 2447, 1547),
    ('ش', 1591, 1488),
    ('ت', 3313, 3870),
    ('ث', 2793, 2561),
    ('خ', 2088, 1999),
    ('ذ', 1777, 647),
    ('ض', 506, 1231),
    ('ظ', 2627, 2028),
    ('غ', 1391, 1820),
  ];

  static const Map<int, String> _basamakHarf = {
    1: 'ا',
    2: 'ب',
    3: 'ج',
    4: 'د',
    5: 'ه',
    6: 'و',
    7: 'ز',
    8: 'ح',
    9: 'ط',
    10: 'ي',
    20: 'ك',
    30: 'ل',
    40: 'م',
    50: 'ن',
    60: 'س',
    70: 'ع',
    80: 'ف',
    90: 'ص',
    100: 'ق',
    200: 'ر',
    300: 'ش',
    400: 'ت',
    500: 'ث',
    600: 'خ',
    700: 'ذ',
    800: 'ض',
    900: 'ظ',
    1000: 'غ',
  };

  static const Map<String, String> okunus = {
    'ا': 'elif',
    'ب': 'be',
    'ج': 'cim',
    'د': 'dal',
    'ه': 'he',
    'و': 'vav',
    'ز': 'ze',
    'ح': 'ha',
    'ط': 'tı',
    'ي': 'ye',
    'ك': 'kef',
    'ل': 'lam',
    'م': 'mim',
    'ن': 'nun',
    'س': 'sin',
    'ع': 'ayn',
    'ف': 'fe',
    'ص': 'sad',
    'ق': 'kaf',
    'ر': 're',
    'ش': 'şın',
    'ت': 'te',
    'ث': 'se',
    'خ': 'hı',
    'ذ': 'zel',
    'ض': 'dad',
    'ظ': 'zı',
    'غ': 'ğayn',
  };

  static int _tabloDeger(String harf, int basamak) {
    for (final e in tablo) {
      if (e.$1 == harf) return basamak == 5 ? e.$3 : e.$2;
    }
    throw ArgumentError('Tabloda harf yok: $harf');
  }

  /// Rakamı basamak değerlerine ayırır: 2135 → [2000, 100, 30, 5]
  static List<int> basamakDegerleri(int n) {
    if (n <= 0) return [];
    final sonuc = <int>[];
    var place = 1;
    while (n > 0) {
      final digit = n % 10;
      if (digit != 0) {
        sonuc.insert(0, digit * place);
      }
      n ~/= 10;
      place *= 10;
    }
    return sonuc;
  }

  /// Basamak değerini ebced harfine çevirir (900→ظ, 20→ك, 1→ا …).
  static String? _degerdenHarf(int deger) => _basamakHarf[deger];

  /// Girdi rakamındaki basamak hanesi → harf (2→ب, 1→ا …).
  static String _rakamdanHarf(int rakam) {
    final h = _basamakHarf[rakam];
    if (h == null) throw ArgumentError('Geçersiz rakam: $rakam');
    return h;
  }

  /// Bast tablo değerini harf listesine açar.
  /// Son rakam tek ise ve 20 bileşeni varsa 5'li tamamlamak için غ ve ض eklenir.
  static List<String> _tabloDegeriniAc(int deger, int basamak) {
    final harfler = <String>[];
    final parcalar = basamakDegerleri(deger);
    for (final p in parcalar) {
      final h = _degerdenHarf(p);
      if (h != null) harfler.add(h);
    }
    final sonRakam = deger % 10;
    if (sonRakam.isOdd && parcalar.contains(20)) {
      harfler.add('غ');
      harfler.add('ض');
    }
    return harfler;
  }

  /// Ebced girdisinin her basamak hanesi → tablo değeri → harf açılımı.
  static List<String> _girdidenHarfler(int ebced, int basamak) {
    final harfler = <String>[];
    final parcalar = basamakDegerleri(ebced);
    for (final p in parcalar) {
      final rakam = p ~/ _placeOf(p);
      final harf = _rakamdanHarf(rakam);
      final tabloDeger = _tabloDeger(harf, basamak);
      harfler.addAll(_tabloDegeriniAc(tabloDeger, basamak));
    }
    return harfler;
  }

  static int _placeOf(int v) {
    if (v >= 1000) return 1000;
    if (v >= 100) return 100;
    if (v >= 10) return 10;
    return 1;
  }

  /// 4 veya 5'li gruplara ayırır (son rakam tek→5, çift→4).
  static List<List<String>> _kelimelereBol(
    List<String> harfler,
    int grupBoyutu,
  ) {
    if (harfler.isEmpty) return [];
    final kelimeler = <List<String>>[];
    var i = 0;
    while (i < harfler.length) {
      final kalan = harfler.length - i;
      if (kalan > grupBoyutu) {
        kelimeler.add(harfler.sublist(i, i + grupBoyutu));
        i += grupBoyutu;
      } else {
        if (kalan == 1 && kelimeler.isNotEmpty) {
          kelimeler.last.addAll(harfler.sublist(i));
        } else {
          kelimeler.add(harfler.sublist(i));
        }
        break;
      }
    }
    return kelimeler;
  }

  static String _kelimeSatir(List<String> harfler) {
    final arapca = harfler.join(' ');
    final ok = harfler.map((h) => okunus[h] ?? h).join(' ');
    return '$arapca ($ok)';
  }

  /// Ana hesap: ebced → kelime satırları (Arapça + okunuş).
  static BastSonuc hesapla(int ebced) {
    if (ebced <= 0) {
      throw ArgumentError('Geçerli bir ebced değeri girin.');
    }

    final sonRakam = ebced % 10;
    final basamak = sonRakam.isOdd ? 5 : 4;
    final grupBoyutu = basamak;

    final tumHarfler = _girdidenHarfler(ebced, basamak);
    final kelimeler = _kelimelereBol(tumHarfler, grupBoyutu);
    final satirlar = kelimeler.map(_kelimeSatir).toList();

    return BastSonuc(
      ebced: ebced,
      basamak: basamak,
      tumHarfler: tumHarfler,
      kelimeler: kelimeler,
      satirlar: satirlar,
    );
  }
}

class BastSonuc {
  const BastSonuc({
    required this.ebced,
    required this.basamak,
    required this.tumHarfler,
    required this.kelimeler,
    required this.satirlar,
  });

  final int ebced;
  final int basamak;
  final List<String> tumHarfler;
  final List<List<String>> kelimeler;
  final List<String> satirlar;
}
