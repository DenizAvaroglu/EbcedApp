import 'package:flutter/material.dart';
import '../models/isim_turu.dart';
import '../utils/ebced_calculator.dart';
import '../widgets/isim_turu_dropdown.dart';

class OzelHesaplamaScreen extends StatefulWidget {
  const OzelHesaplamaScreen({super.key});

  @override
  State<OzelHesaplamaScreen> createState() => _OzelHesaplamaScreenState();
}

class _OzelHesaplamaScreenState extends State<OzelHesaplamaScreen> {
  final TextEditingController _rakamController = TextEditingController();
  final TextEditingController _isimEbcedController = TextEditingController(text: '0');
  IsimTuru _seciliTur = IsimTuru.sahis;
  bool _kombineAktif = false;
  List<int> _rakamListesi = [];
  String _sonuc = '';
  String _rakamlarGosterim = '';

  void _rakamEkle() {
    int? rakam = int.tryParse(_rakamController.text);
    if (rakam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçerli bir rakam girin!')),
      );
      return;
    }
    setState(() {
      _rakamListesi.add(rakam);
      _rakamlarGosterim += '$rakam\n';
      _rakamController.clear();
    });
  }

  void _hesapla() {
    if (_rakamListesi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Önce rakam ekleyin!')),
      );
      return;
    }

    int cikarilacak = _seciliTur.cikarilacakDeger;
    String ek = _seciliTur.ek;
    int isimEbced = int.tryParse(_isimEbcedController.text) ?? 0;

    List<int> tumDegerler = List.from(_rakamListesi);
    List<String> aciklamalar = _rakamListesi.map((r) => '$r').toList();

    if (isimEbced > 0) {
      tumDegerler.add(isimEbced);
      aciklamalar.add('$isimEbced (İsim Ebced)');
      for (int r in _rakamListesi) {
        tumDegerler.add(r + isimEbced);
        aciklamalar.add('$r+$isimEbced');
      }
    }

    // 361 kontrolu
    bool ekle361 = false;
    if (cikarilacak > 0) {
      for (int r in tumDegerler) {
        if (r - cikarilacak <= 0) {
          ekle361 = true;
          break;
        }
      }
    }

    StringBuffer buf = StringBuffer();
    buf.writeln('═══════════════════════════');
    buf.writeln('● ${_seciliTur.gorunenAd.split(' ')[0].toUpperCase()} HESAPLAMASI ●');
    buf.writeln('═══════════════════════════\n');

    if (ekle361) {
      buf.writeln('⚠ Tüm rakamlara 361 eklendi.\n');
    }

    int toplamDeger = 0;
    for (int i = 0; i < tumDegerler.length; i++) {
      int rakam = tumDegerler[i];
      int deger = rakam;
      if (ekle361) deger += 361;
      deger -= cikarilacak;
      toplamDeger += deger;

      String isim = EbcedCalculator.degeriIsmeGevir(deger, ek);

      if (ekle361) {
        buf.writeln('${i + 1}. ${aciklamalar[i]} → $rakam + 361 - $cikarilacak = $deger → $isim');
      } else if (cikarilacak > 0) {
        buf.writeln('${i + 1}. ${aciklamalar[i]} → $rakam - $cikarilacak = $deger → $isim');
      } else {
        buf.writeln('${i + 1}. ${aciklamalar[i]} → $deger → $isim');
      }
    }

    buf.writeln('\n═══════════════════════════');
    buf.writeln('Toplam: $toplamDeger');
    buf.writeln('Ana İsim: ${EbcedCalculator.degeriIsmeGevir(toplamDeger, ek)}');
    buf.writeln('═══════════════════════════');

    if (_kombineAktif) {
      int rakamAdedi = _rakamListesi.length;
      int rakamToplami = _rakamListesi.fold(0, (a, b) => a + b);
      int kombineSonuc = rakamToplami * rakamAdedi;
      buf.writeln('\n● KOMBİNE ESMA ●');
      buf.writeln('$rakamToplami × $rakamAdedi = $kombineSonuc');
      buf.writeln('Kombine İsim: ${EbcedCalculator.degeriIsmeGevir(kombineSonuc, ek)}');
    }

    setState(() {
      _sonuc = buf.toString();
    });
  }

  void _temizle() {
    setState(() {
      _rakamListesi = [];
      _rakamlarGosterim = '';
      _sonuc = '';
      _rakamController.clear();
      _isimEbcedController.text = '0';
      _seciliTur = IsimTuru.sahis;
      _kombineAktif = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Özel Hesaplama')),
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _rakamController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Rakam',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _rakamEkle, child: const Text('Ekle')),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _isimEbcedController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'İsim Ebced Değeri',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Kombine Esma'),
              value: _kombineAktif,
              onChanged: (v) => setState(() => _kombineAktif = v),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _hesapla,
                    child: const Text('Hesapla'),
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
            if (_rakamlarGosterim.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Rakamlar:\n$_rakamlarGosterim',
                    style: const TextStyle(fontFamily: 'monospace')),
              ),
            ],
            if (_sonuc.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SelectableText(_sonuc,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _rakamController.dispose();
    _isimEbcedController.dispose();
    super.dispose();
  }
}
