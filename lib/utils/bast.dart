/// Bast tablosu ve ebced değerinden kelime üretimi.
///
/// Mantık (Âyetel Kürsî 14371 örneğine göre):
/// 1. Girilen ebced değeri, ebced harflerine ayrılır (ör. 14371 → ي د غ ش ع ا).
/// 2. Son harfin cinsiyetine bakılır: tek değer = erkek → 5. bast & 5'li grup,
///    çift değer = dişi → 4. bast & 4'lü grup.
/// 3. Her harfin ilgili bast değeri tekrar ebced harflerine açılır (nutku).
/// 4. Tüm harfler sırayla tek satır olarak dizilir, sonra gruplara ayrılıp
///    kelimeler oluşturulur.
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

  /// Basamak değeri → ebced harfi (1→ا, 20→ك, 900→ظ …).
  static const Map<int, String> _placeHarf = {
    1: 'ا', 2: 'ب', 3: 'ج', 4: 'د', 5: 'ه', 6: 'و', 7: 'ز', 8: 'ح', 9: 'ط',
    10: 'ي', 20: 'ك', 30: 'ل', 40: 'م', 50: 'ن', 60: 'س', 70: 'ع', 80: 'ف',
    90: 'ص',
    100: 'ق', 200: 'ر', 300: 'ش', 400: 'ت', 500: 'ث', 600: 'خ', 700: 'ذ',
    800: 'ض', 900: 'ظ',
  };

  /// Harf → ebced değeri (cinsiyet kontrolü için).
  static const Map<String, int> harfDeger = {
    'ا': 1, 'ب': 2, 'ج': 3, 'د': 4, 'ه': 5, 'و': 6, 'ز': 7, 'ح': 8, 'ط': 9,
    'ي': 10, 'ك': 20, 'ل': 30, 'م': 40, 'ن': 50, 'س': 60, 'ع': 70, 'ف': 80,
    'ص': 90, 'ق': 100, 'ر': 200, 'ش': 300, 'ت': 400, 'ث': 500, 'خ': 600,
    'ذ': 700, 'ض': 800, 'ظ': 900, 'غ': 1000,
  };

  /// Harf okunuşları (örnekteki gibi: Ba, Gayın, Hı …).
  static const Map<String, String> okunus = {
    'ا': 'Elif', 'ب': 'Ba', 'ج': 'Cim', 'د': 'Dal', 'ه': 'He', 'و': 'Vav',
    'ز': 'Ze', 'ح': 'Ha', 'ط': 'Tı', 'ي': 'Ye', 'ك': 'Kef', 'ل': 'Lam',
    'م': 'Mim', 'ن': 'Nun', 'س': 'Sin', 'ع': 'Ayın', 'ف': 'Fe', 'ص': 'Sad',
    'ق': 'Kaf', 'ر': 'Ra', 'ش': 'Şın', 'ت': 'Te', 'ث': 'Sa', 'خ': 'Hı',
    'ذ': 'Zel', 'ض': 'Dad', 'ظ': 'Zı', 'غ': 'Gayın',
  };

  static int _tabloDeger(String harf, int basamak) {
    for (final e in tablo) {
      if (e.$1 == harf) return basamak == 5 ? e.$3 : e.$2;
    }
    throw ArgumentError('Tabloda harf yok: $harf');
  }

  static void _ekleSub1000(int d, List<String> out) {
    final yuz = (d ~/ 100) * 100;
    final on = ((d % 100) ~/ 10) * 10;
    final bir = d % 10;
    if (yuz > 0) out.add(_placeHarf[yuz]!);
    if (on > 0) out.add(_placeHarf[on]!);
    if (bir > 0) out.add(_placeHarf[bir]!);
  }

  /// Bir sayıyı ebced harflerine ayırır (yüksekten düşüğe, ١٠٠٠ = غ işareti).
  /// 1000-1999 → غ + kalan (baştaki "1" yazılmaz),
  /// 2000+ → binler basamağı + غ + kalan.
  static List<String> harflereAyir(int deger) {
    if (deger <= 0) return [];
    final out = <String>[];
    if (deger < 1000) {
      _ekleSub1000(deger, out);
    } else if (deger < 2000) {
      out.add('غ');
      _ekleSub1000(deger % 1000, out);
    } else {
      final binler = deger ~/ 1000;
      final rem = deger % 1000;
      _ekleSub1000(binler, out);
      out.add('غ');
      _ekleSub1000(rem, out);
    }
    return out;
  }

  /// Harfleri 4 veya 5'li gruplara ayırır. Sonda yalnızca 1 harf kalırsa
  /// önceki kelimeye eklenir; 2-3 harf kalırsa kendi başına kelime olur.
  static List<List<String>> _kelimelereBol(List<String> harfler, int grup) {
    if (harfler.isEmpty) return [];
    final kelimeler = <List<String>>[];
    var i = 0;
    while (i < harfler.length) {
      final kalan = harfler.length - i;
      if (kalan > grup) {
        kelimeler.add(harfler.sublist(i, i + grup));
        i += grup;
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

  static String kelimeSatir(List<String> harfler) {
    final arapca = harfler.join(' ');
    final ad = harfler.map((h) => okunus[h] ?? h).join(', ');
    return '$arapca  ($ad)';
  }

  static BastSonuc hesapla(int ebced) {
    if (ebced <= 0) {
      throw ArgumentError('Geçerli bir ebced değeri girin.');
    }

    final girdiHarfler = harflereAyir(ebced);
    if (girdiHarfler.isEmpty) {
      throw ArgumentError('Değer harflere ayrılamadı.');
    }

    final sonHarf = girdiHarfler.last;
    final sonDeger = harfDeger[sonHarf] ?? 1;
    final erkek = sonDeger.isOdd;
    final basamak = erkek ? 5 : 4;
    final grup = erkek ? 5 : 4;

    final tumHarfler = <String>[];
    final adimlar = <BastAdim>[];
    for (final h in girdiHarfler) {
      final deg = _tabloDeger(h, basamak);
      final acilim = harflereAyir(deg);
      adimlar.add(BastAdim(harf: h, deger: deg, acilim: acilim));
      tumHarfler.addAll(acilim);
    }

    final kelimeler = _kelimelereBol(tumHarfler, grup);
    final satirlar = kelimeler.map(kelimeSatir).toList();

    return BastSonuc(
      ebced: ebced,
      girdiHarfler: girdiHarfler,
      erkek: erkek,
      basamak: basamak,
      adimlar: adimlar,
      tumHarfler: tumHarfler,
      kelimeler: kelimeler,
      satirlar: satirlar,
    );
  }
}

class BastAdim {
  const BastAdim({
    required this.harf,
    required this.deger,
    required this.acilim,
  });

  final String harf;
  final int deger;
  final List<String> acilim;
}

class BastSonuc {
  const BastSonuc({
    required this.ebced,
    required this.girdiHarfler,
    required this.erkek,
    required this.basamak,
    required this.adimlar,
    required this.tumHarfler,
    required this.kelimeler,
    required this.satirlar,
  });

  final int ebced;
  final List<String> girdiHarfler;
  final bool erkek;
  final int basamak;
  final List<BastAdim> adimlar;
  final List<String> tumHarfler;
  final List<List<String>> kelimeler;
  final List<String> satirlar;
}
