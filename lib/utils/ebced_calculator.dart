import '../models/ebced_table.dart';

class EbcedCalculator {
  static const List<String> _harekeler = [
    '\u064E', '\u064F', '\u0650', '\u0651', '\u0652', '\u0670',
    '\u06DA', '\u06DB', '\u06EA', '\u06DC', '\u0653', '\u064C',
    '\u064D', '\u064B', '\u06EC', '\u06DF', '\u06D6', '\u06D9'
  ];

  static String temizle(String metin) {
    StringBuffer sonuc = StringBuffer();
    for (int i = 0; i < metin.length; i++) {
      String c = metin[i];
      if (_harekeler.contains(c)) continue;
      if (c == '\u0624' || c == '\u0626') continue; // ؤ ئ
      sonuc.write(c);
    }
    return sonuc.toString();
  }

  static int ebcedHesapla(String metin) {
    String temiz = temizle(metin);
    int toplam = 0;
    for (int i = 0; i < temiz.length; i++) {
      String c = temiz[i];
      if (ebcedTable.containsKey(c)) {
        toplam += ebcedTable[c]!;
      }
    }
    return toplam;
  }

  static (int hesaplanan, bool ekle361) hesaplaDeger(int deger, int cikarilacak) {
    if (cikarilacak == 0) return (deger, false);
    if (deger - cikarilacak <= 0) {
      return (deger + 361 - cikarilacak, true);
    }
    return (deger - cikarilacak, false);
  }

  static String ebcedHarfAdi(int rakam) {
    switch (rakam) {
      case 1: return 'â';
      case 2: return 'Be';
      case 3: return 'Cim';
      case 4: return 'Dal';
      case 5: return 'He';
      case 6: return 'Vav';
      case 7: return 'Ze';
      case 8: return 'Ha';
      case 9: return 'Tı';
      case 10: return 'Ye';
      case 20: return 'Kef';
      case 30: return 'Lam';
      case 40: return 'Mim';
      case 50: return 'Nun';
      case 60: return 'Sin';
      case 70: return 'Ayn';
      case 80: return 'Fe';
      case 90: return 'Sad';
      case 100: return 'Kaf';
      case 200: return 'Re';
      case 300: return 'Şin';
      case 400: return 'Te';
      case 500: return 'Se';
      case 600: return 'Hı';
      case 700: return 'Zel';
      case 800: return 'Dad';
      case 900: return 'Zı';
      case 1000: return 'Ğayın';
      default: return '';
    }
  }

  static String ucbasamak(String input, bool ikiHarf) {
    if (input.isEmpty) return '';
    if (ikiHarf && input.length >= 2) return input.substring(0, 2);
    return input.substring(0, 1);
  }

  static String degeriIsmeGevir(int deger, String ek) {
    int birler, onlar, yuzler, binler, onbinler, yuzbinler, milyonlar;
    String sonuc = '';
    const int bin = 1000;

    if (deger < 100) {
      birler = deger % 10;
      onlar = (deger % 100) - birler;
      sonuc = '${ucbasamak(ebcedHarfAdi(onlar), true)}${ucbasamak(ebcedHarfAdi(birler), false)}$ek';
    } else if (deger < 1000) {
      birler = deger % 10;
      onlar = (deger % 100) - birler;
      yuzler = (deger % 1000) - (birler + onlar);
      sonuc = '${ucbasamak(ebcedHarfAdi(yuzler), true)}${ucbasamak(ebcedHarfAdi(onlar), true)}${ucbasamak(ebcedHarfAdi(birler), false)}$ek';
    } else if (deger > 1000 && deger < 2000) {
      birler = deger % 10;
      onlar = (deger % 100) - birler;
      yuzler = (deger % 1000) - (birler + onlar);
      sonuc = '${ucbasamak(ebcedHarfAdi(bin), true)}${ucbasamak(ebcedHarfAdi(yuzler), true)}${ucbasamak(ebcedHarfAdi(onlar), true)}${ucbasamak(ebcedHarfAdi(birler), false)}$ek';
    } else if (deger > 2000 && deger < 10000) {
      birler = deger % 10;
      onlar = (deger % 100) - birler;
      yuzler = (deger % 1000) - (birler + onlar);
      binler = ((deger % 10000) - (yuzler + onlar + birler)) ~/ 1000;
      sonuc = '${ucbasamak(ebcedHarfAdi(binler), true)}${ucbasamak(ebcedHarfAdi(bin), true)}${ucbasamak(ebcedHarfAdi(yuzler), true)}${ucbasamak(ebcedHarfAdi(onlar), true)}${ucbasamak(ebcedHarfAdi(birler), false)}$ek';
    } else if (deger > 10000 && deger < 100000) {
      birler = deger % 10;
      onlar = (deger % 100) - birler;
      yuzler = (deger % 1000) - (birler + onlar);
      binler = ((deger % 10000) - (yuzler + onlar + birler)) ~/ 1000;
      onbinler = ((deger % 100000) - (deger % 10000)) ~/ 1000;
      sonuc = '${ucbasamak(ebcedHarfAdi(onbinler), true)}${ucbasamak(ebcedHarfAdi(binler), false)}${ucbasamak(ebcedHarfAdi(bin), true)}${ucbasamak(ebcedHarfAdi(yuzler), true)}${ucbasamak(ebcedHarfAdi(onlar), true)}${ucbasamak(ebcedHarfAdi(birler), false)}$ek';
    } else if (deger > 100000 && deger < 1000000) {
      birler = deger % 10;
      onlar = (deger % 100) - birler;
      yuzler = (deger % 1000) - (birler + onlar);
      binler = ((deger % 10000) - (yuzler + onlar + birler)) ~/ 1000;
      onbinler = ((deger % 100000) - (deger % 10000)) ~/ 1000;
      yuzbinler = ((deger % 1000000) - (deger % 100000)) ~/ 1000;
      sonuc = '${ucbasamak(ebcedHarfAdi(yuzbinler), true)}${ucbasamak(ebcedHarfAdi(onbinler), true)}${ucbasamak(ebcedHarfAdi(binler), false)}${ucbasamak(ebcedHarfAdi(bin), true)}${ucbasamak(ebcedHarfAdi(yuzler), true)}${ucbasamak(ebcedHarfAdi(onlar), true)}${ucbasamak(ebcedHarfAdi(birler), false)}$ek';
    } else {
      birler = deger % 10;
      onlar = (deger % 100) - birler;
      yuzler = (deger % 1000) - (birler + onlar);
      binler = ((deger % 10000) - (yuzler + onlar + birler)) ~/ 1000;
      onbinler = ((deger % 100000) - (deger % 10000)) ~/ 1000;
      yuzbinler = ((deger % 1000000) - (deger % 100000)) ~/ 1000;
      milyonlar = ((deger % 10000000) - (deger % 1000000)) ~/ 1000000;
      sonuc = '${ucbasamak(ebcedHarfAdi(milyonlar), true)}${ucbasamak(ebcedHarfAdi(bin), true)}${ucbasamak(ebcedHarfAdi(bin), false)}${ucbasamak(ebcedHarfAdi(yuzbinler), true)}${ucbasamak(ebcedHarfAdi(onbinler), true)}${ucbasamak(ebcedHarfAdi(binler), false)}${ucbasamak(ebcedHarfAdi(bin), true)}${ucbasamak(ebcedHarfAdi(yuzler), true)}${ucbasamak(ebcedHarfAdi(onlar), true)}${ucbasamak(ebcedHarfAdi(birler), false)}$ek';
    }
    return sonuc;
  }
}
