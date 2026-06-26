import 'package:flutter/material.dart';
import '../utils/teksir.dart';

class TeksirTab extends StatefulWidget {
  const TeksirTab({super.key});

  @override
  State<TeksirTab> createState() => _TeksirTabState();
}

class _TeksirTabState extends State<TeksirTab> {
  final _metinController = TextEditingController();
  TeksirYontem _yontem = TeksirYontem.birSondanBirBastan;
  bool _simetrikSonBasa = true; // true: son→başa, false: baş→sona
  List<List<String>> _satirlar = [];
  String? _hata;

  void _hesapla() {
    final harfler = metindenHarfler(_metinController.text);
    if (harfler.isEmpty) {
      setState(() {
        _satirlar = [];
        _hata = 'Lütfen Arapça kelime veya harf dizisi girin.';
      });
      return;
    }

    try {
      final satirlar = teksirSatirlari(
        harfler,
        yontem: _yontem,
        simetrikSonBasa: _simetrikSonBasa,
      );
      setState(() {
        _satirlar = satirlar;
        _hata = null;
      });
    } on ArgumentError catch (e) {
      setState(() {
        _satirlar = [];
        _hata = e.message;
      });
    }
  }

  String _yontemAciklama() {
    switch (_yontem) {
      case TeksirYontem.birSondanBirBastan:
        return 'Bir sondan, bir baştan harf alınır (ör: abcde → eadbc → …). '
            'İlk satırla aynı olan son satır dahil edilmez.';
      case TeksirYontem.sutunlu:
        return 'Son harf 1. sütuna, ilk harf 2. sütuna… (en fazla 20 harf). '
            'İlk satırla aynı olan son satır dahil edilmez.';
      case TeksirYontem.simetrik:
        return _simetrikSonBasa
            ? 'Son harf başa alınır (abcde → eabcd → deabc …).'
            : 'Baş harf sona alınır (abcde → bcdea → cdeab …).';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _metinController,
            textDirection: TextDirection.rtl,
            decoration: const InputDecoration(
              labelText: 'Kelime / Harf Dizisi (Arapça)',
              hintText: 'Örn: متكبر',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            minLines: 2,
            maxLines: 4,
          ),
          const SizedBox(height: 12),
          Text('Teksir Yöntemi',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          SegmentedButton<TeksirYontem>(
            segments: const [
              ButtonSegment(
                value: TeksirYontem.birSondanBirBastan,
                label: Text('1. Yöntem', style: TextStyle(fontSize: 11)),
                tooltip: 'Bir sondan bir baştan',
              ),
              ButtonSegment(
                value: TeksirYontem.sutunlu,
                label: Text('2. Yöntem', style: TextStyle(fontSize: 11)),
                tooltip: 'Sütunlu (max 20 harf)',
              ),
              ButtonSegment(
                value: TeksirYontem.simetrik,
                label: Text('3. Yöntem', style: TextStyle(fontSize: 11)),
                tooltip: 'Simetrik döndürme',
              ),
            ],
            selected: {_yontem},
            onSelectionChanged: (s) => setState(() => _yontem = s.first),
          ),
          if (_yontem == TeksirYontem.simetrik) ...[
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sağdan sola (son harf başa)',
                  style: TextStyle(fontSize: 13)),
              subtitle: Text(
                _simetrikSonBasa
                    ? 'Aktif: son harf başa eklenir'
                    : 'Kapalı: baş harf sona eklenir (soldan sağa)',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
              value: _simetrikSonBasa,
              onChanged: (v) => setState(() => _simetrikSonBasa = v),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            _yontemAciklama(),
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _hesapla,
            icon: const Icon(Icons.grid_on),
            label: const Text('Teksir Oluştur'),
          ),
          if (_hata != null) ...[
            const SizedBox(height: 12),
            Text(_hata!, style: TextStyle(color: theme.colorScheme.error)),
          ],
          if (_satirlar.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              '${_satirlar.length} satır',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < _satirlar.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 28,
                              child: Text(
                                '${i + 1}.',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Expanded(
                              child: _TeksirSatirGosterim(harfler: _satirlar[i]),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _metinController.dispose();
    super.dispose();
  }
}

class _TeksirSatirGosterim extends StatelessWidget {
  const _TeksirSatirGosterim({required this.harfler});

  final List<String> harfler;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 4,
        runSpacing: 4,
        children: harfler
            .map(
              (h) => Container(
                width: 40,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade600),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                child: Text(
                  h,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
