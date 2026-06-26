import 'ebced_calculator.dart';

enum TeksirYontem {
  birSondanBirBastan,
  sutunlu,
  simetrik,
}

/// Bir sondan bir baştan — kaynak harf sırası (0 = baş, n-1 = son).
List<int> _kaynakIndeksleri(int n) {
  final indices = <int>[];
  var left = 0;
  var right = n - 1;
  var fromEnd = true;
  while (left <= right) {
    if (fromEnd) {
      indices.add(right--);
    } else {
      indices.add(left++);
    }
    fromEnd = !fromEnd;
  }
  return indices;
}

/// Yöntem 1: Bir sondan bir baştan harf dizilimi.
List<String> teksir1Adim(List<String> harfler) {
  final kaynak = _kaynakIndeksleri(harfler.length);
  return [for (final i in kaynak) harfler[i]];
}

/// Yöntem 2: Sütunlu (20 adımlı kuralın ilk n adımı — 5 harfte 5 adım).
/// Kaynak seçimi yöntem 1 ile aynı; harfler sütun sırasına yerleştirilir.
List<String> teksir2Adim(List<String> harfler) {
  return teksir1Adim(harfler);
}

/// Yöntem 3: Simetrik döndürme.
/// [sonBasa]: son harf başa (abcde → eabcd)
/// değilse: baş harf sona (abcde → bcdea)
List<String> teksir3Adim(List<String> harfler, {required bool sonBasa}) {
  if (harfler.length <= 1) return List.from(harfler);
  if (sonBasa) {
    return [harfler.last, ...harfler.sublist(0, harfler.length - 1)];
  }
  return [...harfler.sublist(1), harfler.first];
}

List<String> _satirAnahtar(List<String> harfler) => List.from(harfler);

bool _ayniSatir(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Girdi metnini harf listesine çevirir (boşluklar atılır).
List<String> metindenHarfler(String metin) {
  final temiz = EbcedCalculator.temizle(metin.trim());
  return temiz
      .replaceAll(RegExp(r'\s+'), '')
      .split('')
      .where((c) => c.trim().isNotEmpty)
      .toList();
}

/// Teksir satırlarını üretir. Son satır ilk ile aynı olduğunda durur;
/// o satır çıktıya dahil edilmez.
List<List<String>> teksirSatirlari(
  List<String> harfler, {
  required TeksirYontem yontem,
  bool simetrikSonBasa = true,
  int? maxHarf,
}) {
  if (harfler.isEmpty) return [];

  final limit = maxHarf ?? (yontem == TeksirYontem.sutunlu ? 20 : harfler.length);
  if (harfler.length > limit) {
    throw ArgumentError('En fazla $limit harf girilebilir.');
  }

  List<String> sonraki(List<String> mevcut) {
    switch (yontem) {
      case TeksirYontem.birSondanBirBastan:
        return teksir1Adim(mevcut);
      case TeksirYontem.sutunlu:
        return teksir2Adim(mevcut);
      case TeksirYontem.simetrik:
        return teksir3Adim(mevcut, sonBasa: simetrikSonBasa);
    }
  }

  final ilk = _satirAnahtar(harfler);
  final satirlar = <List<String>>[ilk];
  var mevcut = ilk;

  while (true) {
    final yeni = sonraki(mevcut);
    if (_ayniSatir(yeni, ilk)) break;
    satirlar.add(yeni);
    mevcut = yeni;
    if (satirlar.length > 100) break; // güvenlik
  }

  return satirlar;
}

String satirMetni(List<String> harfler) => harfler.join(' ');
