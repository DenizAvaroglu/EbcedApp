import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/isim_turu.dart';
import '../utils/ebced_calculator.dart';
import '../utils/deger_bolme.dart';
import '../widgets/isim_turu_dropdown.dart';

class SureAyetEsmaScreen extends StatefulWidget {
  const SureAyetEsmaScreen({super.key});

  @override
  State<SureAyetEsmaScreen> createState() => _SureAyetEsmaScreenState();
}

class _SureAyetEsmaScreenState extends State<SureAyetEsmaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  IsimTuru _seciliTur = IsimTuru.sahis;
  final TextEditingController _dosyaAdiController = TextEditingController();
  String _sonuc = '';
  String _kayitIcerigi = '';

  // Sure
  final TextEditingController _sureController = TextEditingController();
  // Ayet
  final TextEditingController _ayetController = TextEditingController();
  // Esma
  final TextEditingController _esmaEbcedController = TextEditingController();
  final TextEditingController _gezegenNoController = TextEditingController();
  final TextEditingController _harfSayisiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  // ═══════════════ SURE ═══════════════
  // Ayetleri böler. Metinde ayet numarası (1. 2. 3. veya Arapça ٠١٢ /
  // Farsça ۰۱۲ rakamları) varsa bunlara göre böler — böylece uzun ayetler
  // alt satıra kaysa bile doğru sayılır. Numara yoksa satır sonlarına göre böler.
  static List<String> _ayetlereBol(String metin) {
    final numaraRegex = RegExp(r'[0-9\u0660-\u0669\u06F0-\u06F9\u06DD]+');
    final numaraSayisi = numaraRegex.allMatches(metin).length;

    Iterable<String> parcalar;
    if (numaraSayisi >= 2) {
      parcalar = metin.split(numaraRegex);
    } else {
      parcalar = metin.split(RegExp(r'[\r\n]+'));
    }
    return parcalar.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }

  void _sureHesapla() {
    String metin = _sureController.text;
    var satirlar = _ayetlereBol(metin);
    if (satirlar.isEmpty) {
      _gosterUyari('Ayetleri girin!');
      return;
    }

    int cikarilacak = _seciliTur.cikarilacakDeger;
    String ek = _seciliTur.ek;

    int toplamEbced = 0;
    List<int> ayetEbcedleri = [];

    for (var satir in satirlar) {
      String temiz = EbcedCalculator.temizle(satir.trim());
      int deger = EbcedCalculator.ebcedHesapla(temiz);
      if (deger > 0) {
        ayetEbcedleri.add(deger);
        toplamEbced += deger;
      }
    }

    int ayetSayisi = ayetEbcedleri.length;
    var (anaHesap, anaEkle361) = EbcedCalculator.hesaplaDeger(toplamEbced, cikarilacak);
    String anaIsim = EbcedCalculator.degeriIsmeGevir(anaHesap, ek);

    StringBuffer buf = StringBuffer();
    buf.writeln('═══════════════════════════');
    buf.writeln('● SURE HESAPLAMASI ●');
    buf.writeln('═══════════════════════════');
    buf.writeln('Ayet Sayısı: $ayetSayisi');
    buf.writeln('Toplam Ebced: $toplamEbced');
    if (anaEkle361) {
      buf.writeln('Ana İsim: $toplamEbced + 361 - $cikarilacak = $anaHesap → $anaIsim [+361]');
    } else if (cikarilacak > 0) {
      buf.writeln('Ana İsim: $toplamEbced - $cikarilacak = $anaHesap → $anaIsim');
    } else {
      buf.writeln('Ana İsim: $anaIsim');
    }
    buf.writeln('───────────────────────────');

    List<int> kullanilan = [anaHesap];
    for (int i = 0; i < ayetEbcedleri.length; i++) {
      var (hesap, ekle361) = EbcedCalculator.hesaplaDeger(ayetEbcedleri[i], cikarilacak);

      if (kullanilan.contains(hesap)) {
        var bolunmus = DegerBolme.bol(hesap);
        if (bolunmus != null) {
          String i1 = EbcedCalculator.degeriIsmeGevir(bolunmus.parca1, ek);
          String i2 = EbcedCalculator.degeriIsmeGevir(bolunmus.parca2, ek);
          buf.writeln('${i + 1}. Ayet: ${ayetEbcedleri[i]} → $hesap (${bolunmus.oran}) → $i1 + $i2');
        } else {
          String isim = EbcedCalculator.degeriIsmeGevir(hesap, ek);
          buf.writeln('${i + 1}. Ayet: ${ayetEbcedleri[i]} → $hesap → $isim');
        }
      } else {
        kullanilan.add(hesap);
        String isim = EbcedCalculator.degeriIsmeGevir(hesap, ek);
        if (ekle361) {
          buf.writeln('${i + 1}. Ayet: ${ayetEbcedleri[i]} + 361 - $cikarilacak = $hesap → $isim [+361]');
        } else if (cikarilacak > 0) {
          buf.writeln('${i + 1}. Ayet: ${ayetEbcedleri[i]} - $cikarilacak = $hesap → $isim');
        } else {
          buf.writeln('${i + 1}. Ayet: ${ayetEbcedleri[i]} → $isim');
        }
      }
    }
    buf.writeln('\nOkuma Adedi: $ayetSayisi');

    setState(() {
      _sonuc = buf.toString();
      _kayitIcerigi = _sonuc;
    });
  }

  // ═══════════════ AYET ═══════════════
  void _ayetHesapla() {
    String metin = _ayetController.text.trim();
    if (metin.isEmpty) {
      _gosterUyari('Ayeti girin!');
      return;
    }

    int cikarilacak = _seciliTur.cikarilacakDeger;
    String ek = _seciliTur.ek;

    String temiz = EbcedCalculator.temizle(metin);
    int anaEbced = EbcedCalculator.ebcedHesapla(temiz);

    var kelimeler = temiz.split(RegExp(r'\s+'))
        .where((k) => k.isNotEmpty).toList();
    List<({String kelime, int deger})> kelimeListesi = [];

    for (var k in kelimeler) {
      int kd = EbcedCalculator.ebcedHesapla(k);
      if (kd > 0) kelimeListesi.add((kelime: k, deger: kd));
    }

    int kelimeSayisi = kelimeListesi.length;
    var (anaHesap, anaEkle361) = EbcedCalculator.hesaplaDeger(anaEbced, cikarilacak);
    String anaIsim = EbcedCalculator.degeriIsmeGevir(anaHesap, ek);

    StringBuffer buf = StringBuffer();
    buf.writeln('═══════════════════════════');
    buf.writeln('● AYET HESAPLAMASI ●');
    buf.writeln('═══════════════════════════');
    buf.writeln('Ana Ebced: $anaEbced');
    buf.writeln('Kelime Sayısı: $kelimeSayisi');
    if (anaEkle361) {
      buf.writeln('Ana İsim: $anaEbced + 361 - $cikarilacak = $anaHesap → $anaIsim [+361]');
    } else if (cikarilacak > 0) {
      buf.writeln('Ana İsim: $anaEbced - $cikarilacak = $anaHesap → $anaIsim');
    } else {
      buf.writeln('Ana İsim: $anaIsim');
    }
    buf.writeln('───────────────────────────');

    List<int> kullanilan = [anaHesap];
    for (int i = 0; i < kelimeListesi.length; i++) {
      var (hesap, ekle361) = EbcedCalculator.hesaplaDeger(kelimeListesi[i].deger, cikarilacak);

      if (kullanilan.contains(hesap)) {
        var bolunmus = DegerBolme.bol(hesap);
        if (bolunmus != null) {
          String i1 = EbcedCalculator.degeriIsmeGevir(bolunmus.parca1, ek);
          String i2 = EbcedCalculator.degeriIsmeGevir(bolunmus.parca2, ek);
          buf.writeln('${i + 1}. ${kelimeListesi[i].kelime} = ${kelimeListesi[i].deger} → $hesap (${bolunmus.oran}) → $i1 + $i2');
        } else {
          String isim = EbcedCalculator.degeriIsmeGevir(hesap, ek);
          buf.writeln('${i + 1}. ${kelimeListesi[i].kelime} = ${kelimeListesi[i].deger} → $hesap → $isim');
        }
      } else {
        kullanilan.add(hesap);
        String isim = EbcedCalculator.degeriIsmeGevir(hesap, ek);
        if (ekle361) {
          buf.writeln('${i + 1}. ${kelimeListesi[i].kelime} = ${kelimeListesi[i].deger} + 361 - $cikarilacak = $hesap → $isim [+361]');
        } else if (cikarilacak > 0) {
          buf.writeln('${i + 1}. ${kelimeListesi[i].kelime} = ${kelimeListesi[i].deger} - $cikarilacak = $hesap → $isim');
        } else {
          buf.writeln('${i + 1}. ${kelimeListesi[i].kelime} = ${kelimeListesi[i].deger} → $isim');
        }
      }
    }

    int okumaAdedi = kelimeSayisi * anaEbced;
    buf.writeln('\nOkuma Adedi: $kelimeSayisi × $anaEbced = $okumaAdedi');

    setState(() {
      _sonuc = buf.toString();
      _kayitIcerigi = _sonuc;
    });
  }

  // ═══════════════ ESMA ═══════════════
  void _esmaHesapla() {
    int? esmaEbced = int.tryParse(_esmaEbcedController.text);
    int? gezegenNo = int.tryParse(_gezegenNoController.text);
    int? harfSayisi = int.tryParse(_harfSayisiController.text);

    if (esmaEbced == null || esmaEbced <= 0) {
      _gosterUyari('Geçerli Esma Ebced girin!');
      return;
    }
    if (gezegenNo == null || gezegenNo <= 0) {
      _gosterUyari('Geçerli Gezegen No girin!');
      return;
    }
    if (harfSayisi == null || harfSayisi <= 0) {
      _gosterUyari('Geçerli Harf Sayısı girin!');
      return;
    }

    int cikarilacak = _seciliTur.cikarilacakDeger;
    String ek = _seciliTur.ek;

    int d1 = esmaEbced;
    int d2 = esmaEbced * gezegenNo;
    int d3 = esmaEbced * harfSayisi;
    int d4 = esmaEbced * esmaEbced;
    int d5 = d1 + d2 + d3 + d4;

    var (h1, e1) = EbcedCalculator.hesaplaDeger(d1, cikarilacak);
    var (h2, e2) = EbcedCalculator.hesaplaDeger(d2, cikarilacak);
    var (h3, e3) = EbcedCalculator.hesaplaDeger(d3, cikarilacak);
    var (h4, e4) = EbcedCalculator.hesaplaDeger(d4, cikarilacak);
    var (h5, e5) = EbcedCalculator.hesaplaDeger(d5, cikarilacak);

    List<int> hesaplar = [h1, h2, h3, h4, h5];
    List<String> isimler = [];
    List<int> kullanilan = [];

    for (int h in hesaplar) {
      if (kullanilan.contains(h)) {
        var bolunmus = DegerBolme.bol(h);
        if (bolunmus != null) {
          String i1 = EbcedCalculator.degeriIsmeGevir(bolunmus.parca1, ek);
          String i2 = EbcedCalculator.degeriIsmeGevir(bolunmus.parca2, ek);
          isimler.add('$i1 + $i2 (${bolunmus.oran})');
        } else {
          isimler.add(EbcedCalculator.degeriIsmeGevir(h, ek));
        }
      } else {
        kullanilan.add(h);
        isimler.add(EbcedCalculator.degeriIsmeGevir(h, ek));
      }
    }

    StringBuffer buf = StringBuffer();
    buf.writeln('═══════════════════════════');
    buf.writeln('● ESMA HESAPLAMASI ●');
    buf.writeln('═══════════════════════════');
    buf.writeln('Esma Ebced: $esmaEbced');
    buf.writeln('Gezegen No: $gezegenNo');
    buf.writeln('Harf Sayısı: $harfSayisi');
    buf.writeln('───────────────────────────');

    String formatSatir(int sira, String aciklama, int orijinal, int hesaplanan, bool ekle361, String isim) {
      if (ekle361) return '$sira. İsim ($aciklama): $orijinal + 361 - $cikarilacak = $hesaplanan → $isim [+361]';
      if (cikarilacak > 0) return '$sira. İsim ($aciklama): $orijinal - $cikarilacak = $hesaplanan → $isim';
      return '$sira. İsim ($aciklama): $orijinal → $isim';
    }

    buf.writeln(formatSatir(1, 'Ebced', d1, h1, e1, isimler[0]));
    buf.writeln(formatSatir(2, 'Ebced×Gezegen($gezegenNo)', d2, h2, e2, isimler[1]));
    buf.writeln(formatSatir(3, 'Ebced×Harf($harfSayisi)', d3, h3, e3, isimler[2]));
    buf.writeln(formatSatir(4, 'Ebced²', d4, h4, e4, isimler[3]));
    buf.writeln('───────────────────────────');
    buf.writeln(formatSatir(5, 'TOPLAM', d5, h5, e5, isimler[4]));
    buf.writeln('\nOkuma Adedi: $d5');

    StringBuffer kayitBuf = StringBuffer();
    kayitBuf.writeln('5. İsim (Ana): ${isimler[4]}');
    kayitBuf.writeln('1. İsim: ${isimler[0]}');
    kayitBuf.writeln('2. İsim: ${isimler[1]}');
    kayitBuf.writeln('3. İsim: ${isimler[2]}');
    kayitBuf.writeln('4. İsim: ${isimler[3]}');
    kayitBuf.writeln('\nOkuma Adedi: $d5');

    setState(() {
      _sonuc = buf.toString();
      _kayitIcerigi = kayitBuf.toString();
    });
  }

  // ═══════════════ KAYDET ═══════════════
  Future<void> _kaydet() async {
    if (_kayitIcerigi.isEmpty) {
      _gosterUyari('Önce hesaplama yapın!');
      return;
    }
    String dosyaAdi = _dosyaAdiController.text.trim();
    if (dosyaAdi.isEmpty) {
      _gosterUyari('Dosya adı girin!');
      return;
    }

    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$dosyaAdi.txt');
      await file.writeAsString(_kayitIcerigi);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kaydedildi: ${file.path}')),
        );
      }
    } catch (e) {
      _gosterUyari('Hata: $e');
    }
  }

  Future<void> _paylas() async {
    if (_kayitIcerigi.isEmpty) {
      _gosterUyari('Önce hesaplama yapın!');
      return;
    }
    await Share.share(_kayitIcerigi, subject: 'Ebced Hesaplama Sonucu');
  }

  void _gosterUyari(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mesaj)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sure / Ayet / Esma'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Sure'),
            Tab(text: 'Ayet'),
            Tab(text: 'Esma'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: IsimTuruDropdown(
                    secili: _seciliTur,
                    onChanged: (v) => setState(() => _seciliTur = v!),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: _dosyaAdiController,
                    decoration: const InputDecoration(
                      labelText: 'Dosya Adı',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _kaydet,
                  icon: const Icon(Icons.save),
                  tooltip: 'Kaydet',
                ),
                IconButton(
                  onPressed: _paylas,
                  icon: const Icon(Icons.share),
                  tooltip: 'Paylaş',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSureTab(),
                _buildAyetTab(),
                _buildEsmaTab(),
              ],
            ),
          ),
          if (_sonuc.isNotEmpty)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    _sonuc,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSureTab() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
              'Surenin ayetlerini girin. Ayet numarası (1. 2. 3. …) varsa '
              'ona göre, yoksa her satır bir ayet sayılır:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: _sureController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: _sureHesapla, child: const Text('Sure Hesapla')),
        ],
      ),
    );
  }

  Widget _buildAyetTab() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Tek bir ayetin Arapçasını girin:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: _ayetController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: _ayetHesapla, child: const Text('Ayet Hesapla')),
        ],
      ),
    );
  }

  Widget _buildEsmaTab() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _esmaEbcedController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Esma Ebced',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _gezegenNoController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Gezegen No',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _harfSayisiController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Harf Sayısı',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _esmaHesapla, child: const Text('Esma Hesapla')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dosyaAdiController.dispose();
    _sureController.dispose();
    _ayetController.dispose();
    _esmaEbcedController.dispose();
    _gezegenNoController.dispose();
    _harfSayisiController.dispose();
    super.dispose();
  }
}
