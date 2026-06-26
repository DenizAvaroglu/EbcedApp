import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/vefk_gram.dart';
import 'teksir_tab.dart';
import 'vefk_referans_screen.dart';

// Grid position → cell index mappings for magic square arrangements
const _buduh3 = [1, 8, 3, 6, 4, 2, 5, 0, 7];

const _magic4 = [
  15, 2, 1, 12, //
  4, 9, 10, 7,
  8, 5, 6, 11,
  3, 14, 13, 0,
];

const _magic5 = [
  16, 23, 0, 7, 14, //
  22, 4, 6, 13, 15,
  3, 5, 12, 19, 21,
  9, 11, 18, 20, 2,
  10, 17, 24, 1, 8,
];

List<List<dynamic>> _arrangeGrid(
  List<dynamic> cells,
  int size,
  List<int> order,
) {
  return List.generate(
    size,
    (r) => List.generate(size, (c) => cells[order[r * size + c]]),
  );
}

// ═══════════════════ SHARED GRID WIDGET ═══════════════════

Widget _buildVefkGrid(
  List<List<dynamic>> grid,
  int size, {
  Color? bgColor,
}) {
  final cellH = size <= 3 ? 72.0 : (size <= 4 ? 60.0 : 48.0);
  final fontSize = size <= 3 ? 22.0 : (size <= 4 ? 18.0 : 14.0);

  return Table(
    border: TableBorder.all(color: Colors.grey.shade700, width: 1.5),
    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    children: grid
        .map(
          (row) => TableRow(
            children: row.map((cell) {
              final empty = cell.toString().isEmpty;
              return Container(
                height: cellH,
                decoration: BoxDecoration(
                  color: empty
                      ? Colors.grey.shade200
                      : bgColor?.withValues(alpha: 0.12),
                ),
                alignment: Alignment.center,
                child: Text(
                  cell.toString(),
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: empty ? Colors.transparent : Colors.black87,
                  ),
                ),
              );
            }).toList(),
          ),
        )
        .toList(),
  );
}

// ═══════════════════ MAIN SCREEN ═══════════════════

class VefkScreen extends StatelessWidget {
  const VefkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vefk Hesaplama'),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'Referans Bilgileri',
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const VefkReferansScreen())),
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "3'lü Vefk"),
              Tab(text: "4'lü Vefk"),
              Tab(text: "5'li Vefk"),
              Tab(text: 'Teksir'),
            ],
          ),
        ),
        body: const Column(
          children: [
            VefkReferansButtonBar(),
            Expanded(
              child: TabBarView(
                children: [
                  _Vefk3Tab(),
                  _Vefk4Tab(),
                  _Vefk5Tab(),
                  TeksirTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════ 3'LÜ VEFK ═══════════════════

class _Vefk3Tab extends StatefulWidget {
  const _Vefk3Tab();
  @override
  State<_Vefk3Tab> createState() => _Vefk3TabState();
}

class _Vefk3TabState extends State<_Vefk3Tab>
    with AutomaticKeepAliveClientMixin {
  final _ctrl = TextEditingController();
  String _variant = 'Düz Ateş';
  List<List<dynamic>>? _grid;
  List<GramCell>? _hexCells;
  bool _isHexagram = false;

  static const _variants = [
    'Düz Ateş',
    'Düz Hava',
    'Düz Su',
    'Düz Toprak',
    'Hexagram',
    'Ortası Boş (Hali Vasat)',
    'Alt Orta Boş',
    'Behdaz Vecet',
  ];

  Color? get _color {
    switch (_variant) {
      case 'Düz Ateş':
        return Colors.red;
      case 'Düz Hava':
        return Colors.lightBlue;
      case 'Düz Su':
        return Colors.blue;
      case 'Düz Toprak':
        return Colors.brown;
      default:
        return null;
    }
  }

  void _olustur() {
    final n = int.tryParse(_ctrl.text);
    if (n == null || n <= 0) return _hata('Geçerli bir pozitif sayı girin.');

    if (_variant.startsWith('Düz') && n < 12) {
      return _hata("Düz 3'lü vefk için en az 12 girin.");
    }
    if (_variant == 'Hexagram' && n < 12) {
      return _hata("Hexagram vefk için en az 12 girin.");
    }

    setState(() {
      _isHexagram = false;
      _hexCells = null;
      if (_variant == 'Hexagram') {
        _isHexagram = true;
        _grid = null;
        _hexCells = hexagramCells(n);
      } else if (_variant.startsWith('Düz')) {
        _grid = _duz3(n);
      } else if (_variant.startsWith('Ortası')) {
        _grid = [
          [n + 1, n + 2, n + 3],
          [n + 4, '', n - 4],
          [n - 3, n - 2, n - 1],
        ];
      } else if (_variant.startsWith('Alt')) {
        _grid = [
          [n * 2, n * 3, n * 4],
          [n * 5, n * 6, n * 7],
          [n * 8, '', n * 9],
        ];
      } else {
        final bolum = n ~/ 12;
        final kalan = n % 12;
        _grid = [
          [bolum, bolum * 2, bolum * 3],
          [bolum * 4, n, bolum * 5],
          [bolum * 6 + kalan, bolum * 7 + kalan, bolum * 8 + kalan],
        ];
      }
    });
  }

  List<List<dynamic>> _duz3(int anaSayi) {
    final b = (anaSayi - 12) ~/ 3;
    final k = (anaSayi - 12) % 3;
    final cells = <int>[
      for (var i = 0; i < 6; i++) b + i,
      for (var i = 6; i < 9; i++) b + i + k,
    ];
    return _arrangeGrid(cells, 3, _buduh3);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _dropDown(_variants, _variant, (v) {
            setState(() {
              _variant = v;
              _grid = null;
              _hexCells = null;
              _isHexagram = false;
            });
          }),
          const SizedBox(height: 12),
          _numField(_ctrl, 'Ebced Toplamı'),
          const SizedBox(height: 12),
          _olusturBtn(_olustur),
          if (_isHexagram && _hexCells != null) ...[
            const SizedBox(height: 20),
            Center(
              child: buildGramDiagram(
                cells: _hexCells!,
                imageAsset: 'assets/vefk/hexagram.png',
                aspectRatio: 1.0,
                width: (MediaQuery.of(context).size.width - 32)
                    .clamp(0.0, 380.0),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Ortadaki hanenin değeri yazılır, altına seçilen ayet/esma '
                'eklenir. Dış çembere de ayet/esma yazılabilir.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ] else if (_grid != null) ...[
            const SizedBox(height: 20),
            _buildVefkGrid(_grid!, 3, bgColor: _color),
            if (_variant.startsWith('Düz'))
              _sumLabel('Satır/Sütun/Köşegen Toplamı: ${_ctrl.text}'),
          ],
        ],
      ),
    );
  }

  void _hata(String m) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(m), backgroundColor: Colors.red));

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}

// ═══════════════════ 4'LÜ VEFK ═══════════════════

class _Vefk4Tab extends StatefulWidget {
  const _Vefk4Tab();
  @override
  State<_Vefk4Tab> createState() => _Vefk4TabState();
}

class _Vefk4TabState extends State<_Vefk4Tab>
    with AutomaticKeepAliveClientMixin {
  final _ctrl = TextEditingController();
  final _ctrlA = TextEditingController();
  final _ctrlB = TextEditingController();
  final _ctrlC = TextEditingController();
  final _ctrlD = TextEditingController();
  String _variant = "Düz 4'lü";
  List<List<dynamic>>? _grid;
  List<GramCell>? _gramCells;
  bool _isSeptagram = false;

  static const _variants = ["Düz 4'lü", "Septagram", "Köşe Değerli (Yazılı 4'lü)"];

  bool get _isKose => _variant.startsWith('Köşe');
  bool get _isSeptagramVariant => _variant == 'Septagram';

  void _olustur() {
    if (_isKose) {
      final a = int.tryParse(_ctrlA.text);
      final b = int.tryParse(_ctrlB.text);
      final c = int.tryParse(_ctrlC.text);
      final d = int.tryParse(_ctrlD.text);
      if (a == null || b == null || c == null || d == null) {
        return _hata('Tüm köşe değerlerini girin.');
      }
      if (a + b != c + d) {
        _uyari('Uyarı: A+B ≠ C+D — satır toplamları eşit olmayabilir.');
      }
      setState(() {
        _grid = [
          [a, b + 1, a + 1, b],
          [c + 1, d, c, d + 1],
          [d - 1, c + 2, d + 2, c - 1],
          [b + 2, a - 1, b - 1, a + 2],
        ];
        _gramCells = null;
        _isSeptagram = false;
      });
    } else if (_isSeptagramVariant) {
      final n = int.tryParse(_ctrl.text);
      if (n == null || n < 30) {
        return _hata("Septagram vefk için en az 30 girin.");
      }
      setState(() {
        _grid = null;
        _isSeptagram = true;
        _gramCells = septagramCells(n);
      });
    } else {
      final n = int.tryParse(_ctrl.text);
      if (n == null || n < 30) {
        return _hata("Düz 4'lü vefk için en az 30 girin.");
      }
      setState(() {
        _grid = _duz4(n);
        _gramCells = null;
        _isSeptagram = false;
      });
    }
  }

  List<List<dynamic>> _duz4(int anaSayi) {
    final b = (anaSayi - 30) ~/ 4;
    final k = (anaSayi - 30) % 4;
    final cells = <int>[
      for (var i = 0; i < 16 - k; i++) b + i,
      for (var i = 0; i < k; i++) b + 16 + i,
    ];
    return _arrangeGrid(cells, 4, _magic4);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _dropDown(_variants, _variant, (v) {
            setState(() {
              _variant = v;
              _grid = null;
              _gramCells = null;
              _isSeptagram = false;
            });
          }),
          const SizedBox(height: 12),
          if (_isKose) ...[
            Row(children: [
              Expanded(child: _numField(_ctrlA, 'Sol Üst (A)')),
              const SizedBox(width: 8),
              Expanded(child: _numField(_ctrlB, 'Sağ Üst (B)')),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _numField(_ctrlC, 'Sol Alt (C)')),
              const SizedBox(width: 8),
              Expanded(child: _numField(_ctrlD, 'Sağ Alt (D)')),
            ]),
          ] else
            _numField(_ctrl, 'Ebced Toplamı'),
          const SizedBox(height: 12),
          _olusturBtn(_olustur),
          if (_isSeptagram && _gramCells != null) ...[
            const SizedBox(height: 20),
            Center(
              child: buildGramDiagram(
                cells: _gramCells!,
                imageAsset: 'assets/vefk/septagram.png',
                aspectRatio: 804 / 506,
                width:
                    (MediaQuery.of(context).size.width - 32).clamp(0.0, 520.0),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Yıldızın 16 hanesi sayılarla dolar. Ortadaki boşluğa ayet/esma '
                'veya isim yazılabilir.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ] else if (_grid != null) ...[
            const SizedBox(height: 20),
            _buildVefkGrid(_grid!, 4),
            if (!_isKose)
              _sumLabel('Satır/Sütun/Köşegen Toplamı: ${_ctrl.text}'),
          ],
        ],
      ),
    );
  }

  void _hata(String m) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(m), backgroundColor: Colors.red));

  void _uyari(String m) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m), backgroundColor: Colors.orange));

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _ctrl.dispose();
    _ctrlA.dispose();
    _ctrlB.dispose();
    _ctrlC.dispose();
    _ctrlD.dispose();
    super.dispose();
  }
}

// ═══════════════════ 5'Lİ VEFK ═══════════════════

class _Vefk5Tab extends StatefulWidget {
  const _Vefk5Tab();
  @override
  State<_Vefk5Tab> createState() => _Vefk5TabState();
}

class _Vefk5TabState extends State<_Vefk5Tab>
    with AutomaticKeepAliveClientMixin {
  final _ctrl = TextEditingController();
  final _ctrlIsim = TextEditingController();
  final _ctrlIslem = TextEditingController();
  String _variant = "Düz 5'li";
  List<List<dynamic>>? _grid;
  List<GramCell>? _gramCells;
  bool _isOctagram = false;

  static const _variants = [
    "Düz 5'li",
    "Octagram",
    "Hali Vasat 5'li",
    "Hali Vasat Birleşik",
  ];

  bool get _isBirlesik => _variant.contains('Birleşik');
  bool get _isDuz => _variant.startsWith('Düz');
  bool get _isOctagramVariant => _variant == 'Octagram';

  // Hali Vasat 5'li düzeni: orijinal vefkin etiket konumlarından çıkarılan
  // sihirli kare yerleşimi. 0 = merkez (isim/esma yazılan hane).
  // Her satır/sütun/köşegen toplamı isim*işlem (standartta ebced²) eder.
  static const _haliVasatDuzen = [
    [11, 15, 24, 3, 7],
    [4, 8, 12, 16, 20],
    [17, 21, 0, 9, 13],
    [5, 14, 18, 22, 1],
    [23, 2, 6, 10, 19],
  ];

  void _olustur() {
    if (_isBirlesik) {
      final isim = int.tryParse(_ctrlIsim.text);
      final islem = int.tryParse(_ctrlIslem.text);
      if (isim == null || isim <= 0 || islem == null || islem <= 0) {
        return _hata('İsim ve İşlem ebced değerlerini girin.');
      }
      setState(() {
        _grid = _haliVasat(isim, islemEbced: islem);
        _gramCells = null;
        _isOctagram = false;
      });
    } else if (_isOctagramVariant) {
      final n = int.tryParse(_ctrl.text);
      if (n == null || n < 60) {
        return _hata("Octagram vefk için en az 60 girin.");
      }
      setState(() {
        _grid = null;
        _isOctagram = true;
        _gramCells = octagramCells(n);
      });
    } else if (_isDuz) {
      final n = int.tryParse(_ctrl.text);
      if (n == null || n < 60) {
        return _hata("Düz 5'li vefk için en az 60 girin.");
      }
      setState(() {
        _grid = _duz5(n);
        _gramCells = null;
        _isOctagram = false;
      });
    } else {
      final n = int.tryParse(_ctrl.text);
      if (n == null || n <= 0) return _hata('Geçerli bir pozitif sayı girin.');
      setState(() {
        _grid = _haliVasat(n);
        _gramCells = null;
        _isOctagram = false;
      });
    }
  }

  List<List<dynamic>> _duz5(int anaSayi) {
    final b = (anaSayi - 60) ~/ 5;
    final k = (anaSayi - 60) % 5;
    final cells = <int>[
      for (var i = 0; i < 25 - k; i++) b + i,
      for (var i = 0; i < k; i++) b + 25 + i,
    ];
    return _arrangeGrid(cells, 5, _magic5);
  }

  // Bir hane numarasının değerini hesaplar.
  // 1..19 -> isim*n,  20..24 -> (islem-(60-n))*isim,  0 -> merkez (isim metni)
  dynamic _haneDegeri(int n, int isim, int islem) {
    if (n == 0) return 'isim'; // merkez: isim/esma yazılır
    if (n <= 19) return isim * n;
    // n: 20->(islem-40), 21->(islem-39), ... 24->(islem-36)
    return (islem - (60 - n)) * isim;
  }

  List<List<dynamic>> _haliVasat(int ebced, {int? islemEbced}) {
    final isim = ebced;
    final islem = islemEbced ?? ebced;
    return [
      for (final satir in _haliVasatDuzen)
        [for (final n in satir) _haneDegeri(n, isim, islem)],
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _dropDown(_variants, _variant, (v) {
            setState(() {
              _variant = v;
              _grid = null;
              _gramCells = null;
              _isOctagram = false;
            });
          }),
          const SizedBox(height: 12),
          if (_isBirlesik) ...[
            _numField(_ctrlIsim, 'İsim Ebced Değeri'),
            const SizedBox(height: 8),
            _numField(_ctrlIslem, 'İşlem Ebced Değeri'),
          ] else
            _numField(
              _ctrl,
              _isDuz || _isOctagramVariant ? 'Ebced Toplamı' : 'Ebced Değeri',
            ),
          const SizedBox(height: 12),
          _olusturBtn(_olustur),
          if (_isOctagram && _gramCells != null) ...[
            const SizedBox(height: 20),
            Center(
              child: buildGramDiagram(
                cells: _gramCells!,
                imageAsset: 'assets/vefk/octagram.png',
                aspectRatio: 1070 / 554,
                width:
                    (MediaQuery.of(context).size.width - 32).clamp(0.0, 560.0),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Yıldızın 25 hanesi sayılarla dolar. Ortadaki boşluğa ayet/esma '
                'veya isim yazılabilir.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ] else if (_grid != null) ...[
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: MediaQuery.of(context).size.width > 420 ? null : 420,
                child: _buildVefkGrid(_grid!, 5),
              ),
            ),
            if (_isDuz)
              _sumLabel('Satır/Sütun/Köşegen Toplamı: ${_ctrl.text}')
            else
              _sumLabel(_haliVasatToplam()),
            if (!_isDuz)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Merkez haneye (isim) istediğiniz isim/esma yazılabilir, '
                  'vefke zararı yoktur.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ],
      ),
    );
  }

  String _haliVasatToplam() {
    if (_isBirlesik) {
      final isim = int.tryParse(_ctrlIsim.text) ?? 0;
      final islem = int.tryParse(_ctrlIslem.text) ?? 0;
      return 'Satır/Sütun Toplamı: ${isim * islem}';
    }
    final e = int.tryParse(_ctrl.text) ?? 0;
    return 'Satır/Sütun Toplamı: ${e * e}';
  }

  void _hata(String m) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(m), backgroundColor: Colors.red));

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _ctrl.dispose();
    _ctrlIsim.dispose();
    _ctrlIslem.dispose();
    super.dispose();
  }
}

// ═══════════════════ SHARED HELPERS ═══════════════════

Widget _dropDown(
  List<String> items,
  String value,
  ValueChanged<String> onChanged,
) {
  return DropdownButtonFormField<String>(
    value: value,
    isExpanded: true,
    decoration: const InputDecoration(
      labelText: 'Vefk Türü',
      border: OutlineInputBorder(),
    ),
    items: items
        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
        .toList(),
    onChanged: (v) => onChanged(v!),
  );
}

Widget _numField(TextEditingController ctrl, String label) {
  return TextField(
    controller: ctrl,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
  );
}

Widget _olusturBtn(VoidCallback onPressed) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    icon: const Icon(Icons.grid_on),
    label: const Text('Oluştur'),
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
  );
}

Widget _sumLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Text(text, textAlign: TextAlign.center),
  );
}
