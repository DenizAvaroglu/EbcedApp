import 'package:flutter/material.dart';
import '../utils/bast.dart';

class BastTab extends StatefulWidget {
  const BastTab({super.key});

  @override
  State<BastTab> createState() => _BastTabState();
}

class _BastTabState extends State<BastTab> {
  final _ebcedController = TextEditingController();
  BastSonuc? _sonuc;
  String? _hata;

  void _hesapla() {
    final ebced = int.tryParse(_ebcedController.text.trim());
    if (ebced == null || ebced <= 0) {
      setState(() {
        _sonuc = null;
        _hata = 'Geçerli bir ebced değeri girin.';
      });
      return;
    }

    try {
      setState(() {
        _sonuc = BastCalc.hesapla(ebced);
        _hata = null;
      });
    } on ArgumentError catch (e) {
      setState(() {
        _sonuc = null;
        _hata = e.message;
      });
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
            controller: _ebcedController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Ebced Değeri',
              hintText: 'Örn: 2135',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Son rakam tek → 5. basamak tablosu, çift → 4. basamak tablosu. '
            'Harfler soldan sağa dizilir, kelimeler 4 veya 5\'li gruplanır.',
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _hesapla,
            icon: const Icon(Icons.text_fields),
            label: const Text('Bast Hesapla'),
          ),
          if (_hata != null) ...[
            const SizedBox(height: 12),
            Text(_hata!, style: TextStyle(color: theme.colorScheme.error)),
          ],
          if (_sonuc != null) ...[
            const SizedBox(height: 16),
            Text(
              'Basamak: ${_sonuc!.basamak}. | ${_sonuc!.kelimeler.length} kelime',
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
                    for (var i = 0; i < _sonuc!.satirlar.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            _sonuc!.satirlar[i],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            ExpansionTile(
              title: const Text('Bast Tablosu', style: TextStyle(fontSize: 14)),
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Harf')),
                      DataColumn(label: Text('4. Basamak')),
                      DataColumn(label: Text('5. Basamak')),
                    ],
                    rows: BastCalc.tablo
                        .map(
                          (e) => DataRow(cells: [
                            DataCell(Text(e.$1,
                                style: const TextStyle(fontSize: 18))),
                            DataCell(Text('${e.$2}')),
                            DataCell(Text('${e.$3}')),
                          ]),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ebcedController.dispose();
    super.dispose();
  }
}
