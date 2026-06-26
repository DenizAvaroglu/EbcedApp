import 'package:flutter/material.dart';
import '../models/isim_turu.dart';
import '../utils/ebced_calculator.dart';
import '../widgets/isim_turu_dropdown.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _ayetController = TextEditingController();
  final TextEditingController _dosyaAdiController = TextEditingController();
  IsimTuru _seciliTur = IsimTuru.sahis;
  bool _otomatikIsim = true;
  String _ebcedSonuc = '';
  String _isimSonuc = '';
  int _toplam = 0;
  List<int> _ebcedDegerleri = [];

  void _hesapla() {
    String metin = _ayetController.text;
    if (metin.trim().isEmpty) return;

    var satirlar = metin.split(RegExp(r'[\r\n]+'))
        .where((s) => s.trim().isNotEmpty)
        .toList();

    int cikarilacak = _seciliTur.cikarilacakDeger;
    String ek = _seciliTur.ek;

    StringBuffer ebcedBuf = StringBuffer();
    _ebcedDegerleri = [];
    _toplam = 0;

    for (int i = 0; i < satirlar.length; i++) {
      String temiz = EbcedCalculator.temizle(satirlar[i].trim());
      int seddesiz = EbcedCalculator.ebcedHesapla(temiz);
      if (seddesiz <= 0) continue;

      _ebcedDegerleri.add(seddesiz);
      _toplam += seddesiz;

      var kelimeler = temiz.split(RegExp(r'\s+'))
          .where((k) => k.isNotEmpty)
          .toList();

      // Bu ayet icinde 361 gerekli mi
      bool ayetEkle361 = false;
      if (cikarilacak > 0) {
        if (seddesiz - cikarilacak <= 0) ayetEkle361 = true;
        if (!ayetEkle361) {
          for (var k in kelimeler) {
            int kd = EbcedCalculator.ebcedHesapla(k);
            if (kd > 0 && kd - cikarilacak <= 0) {
              ayetEkle361 = true;
              break;
            }
          }
        }
      }

      int ayetHesap = seddesiz;
      if (cikarilacak > 0) {
        if (ayetEkle361) ayetHesap += 361;
        ayetHesap -= cikarilacak;
      }
      String ayetIsmi = EbcedCalculator.degeriIsmeGevir(ayetHesap, ek);

      ebcedBuf.writeln('═══════════════════════════');
      ebcedBuf.writeln('● ${i + 1}. AYET ●');
      ebcedBuf.writeln('Değer: $seddesiz');
      if (cikarilacak > 0 && ayetEkle361) {
        ebcedBuf.writeln('İsim: $seddesiz + 361 - $cikarilacak = $ayetHesap → $ayetIsmi [+361]');
      } else if (cikarilacak > 0) {
        ebcedBuf.writeln('İsim: $seddesiz - $cikarilacak = $ayetHesap → $ayetIsmi');
      } else {
        ebcedBuf.writeln('İsim: $ayetIsmi');
      }

      ebcedBuf.writeln('───────────────────────────');
      int ki = 1;
      for (var k in kelimeler) {
        int kd = EbcedCalculator.ebcedHesapla(k);
        if (kd > 0) {
          int kHesap = kd;
          if (cikarilacak > 0) {
            if (ayetEkle361) kHesap += 361;
            kHesap -= cikarilacak;
          }
          String kIsim = EbcedCalculator.degeriIsmeGevir(kHesap, ek);
          ebcedBuf.writeln('  $ki. $k = $kd → $kIsim');
          ki++;
        }
      }
      ebcedBuf.writeln('');
    }

    ebcedBuf.writeln('═══════════════════════════');
    ebcedBuf.writeln('TOPLAM: $_toplam');
    var (toplamHesap, toplamEkle361) =
        EbcedCalculator.hesaplaDeger(_toplam, cikarilacak);
    String toplamIsim = EbcedCalculator.degeriIsmeGevir(toplamHesap, ek);
    if (cikarilacak > 0 && toplamEkle361) {
      ebcedBuf.writeln(
          'TOPLAM İSİM: $_toplam + 361 - $cikarilacak = $toplamHesap → $toplamIsim [+361]');
    } else if (cikarilacak > 0) {
      ebcedBuf.writeln(
          'TOPLAM İSİM: $_toplam - $cikarilacak = $toplamHesap → $toplamIsim');
    } else {
      ebcedBuf.writeln('TOPLAM İSİM: $toplamIsim');
    }

    setState(() {
      _ebcedSonuc = ebcedBuf.toString();
      if (_otomatikIsim) _hesaplaIsim();
    });
  }

  void _hesaplaIsim() {
    int cikarilacak = _seciliTur.cikarilacakDeger;
    String ek = _seciliTur.ek;

    StringBuffer buf = StringBuffer();
    buf.writeln('● AYET İSİMLERİ (${_seciliTur.gorunenAd}) ●');
    buf.writeln('═══════════════════════════');

    for (int i = 0; i < _ebcedDegerleri.length; i++) {
      int deger = _ebcedDegerleri[i];
      var (hesap, ekle361) = EbcedCalculator.hesaplaDeger(deger, cikarilacak);
      String isim = EbcedCalculator.degeriIsmeGevir(hesap, ek);

      if (cikarilacak > 0 && ekle361) {
        buf.writeln('${i + 1}. $deger + 361 - $cikarilacak = $hesap → $isim [+361]');
      } else if (cikarilacak > 0) {
        buf.writeln('${i + 1}. $deger - $cikarilacak = $hesap → $isim');
      } else {
        buf.writeln('${i + 1}. İsim: $isim (Değer: $deger)');
      }
    }

    buf.writeln('═══════════════════════════');
    var (toplamHesap, toplamEkle361) =
        EbcedCalculator.hesaplaDeger(_toplam, cikarilacak);
    String toplamIsim = EbcedCalculator.degeriIsmeGevir(toplamHesap, ek);
    if (cikarilacak > 0 && toplamEkle361) {
      buf.writeln(
          'TOPLAM: $_toplam + 361 - $cikarilacak = $toplamHesap → $toplamIsim [+361]');
    } else if (cikarilacak > 0) {
      buf.writeln('TOPLAM: $_toplam - $cikarilacak = $toplamHesap → $toplamIsim');
    } else {
      buf.writeln('TOPLAM İSİM: $toplamIsim (Değer: $_toplam)');
    }

    setState(() {
      _isimSonuc = buf.toString();
    });
  }

  void _temizle() {
    setState(() {
      _ayetController.clear();
      _dosyaAdiController.clear();
      _ebcedSonuc = '';
      _isimSonuc = '';
      _toplam = 0;
      _ebcedDegerleri = [];
      _seciliTur = IsimTuru.sahis;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ebced Hesaplama')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IsimTuruDropdown(
              secili: _seciliTur,
              onChanged: (v) => setState(() => _seciliTur = v!),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _ayetController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Ayet(ler) girin',
                border: OutlineInputBorder(),
                hintText: 'Her satıra bir ayet yazın...',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                    title: const Text('Otomatik İsim', style: TextStyle(fontSize: 13)),
                    value: _otomatikIsim,
                    onChanged: (v) => setState(() => _otomatikIsim = v),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _hesapla,
                    child: const Text('Ebced Hesapla'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _ebcedDegerleri.isNotEmpty ? _hesaplaIsim : null,
                    child: const Text('İsim'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _temizle,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red[300]),
                  child: const Text('Temizle'),
                ),
              ],
            ),
            if (_ebcedSonuc.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SelectableText(
                  _ebcedSonuc,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ],
            if (_isimSonuc.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: SelectableText(
                  _isimSonuc,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ayetController.dispose();
    _dosyaAdiController.dispose();
    super.dispose();
  }
}
