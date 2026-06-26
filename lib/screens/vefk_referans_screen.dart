import 'package:flutter/material.dart';

class VefkReferansScreen extends StatefulWidget {
  const VefkReferansScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<VefkReferansScreen> createState() => _VefkReferansScreenState();
}

class _VefkReferansScreenState extends State<VefkReferansScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, 4),
    );
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vefk Referans Bilgileri'),
        bottom: TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Tütsüler'),
            Tab(text: 'Melekler'),
            Tab(text: 'Günler'),
            Tab(text: 'Gezegenler'),
            Tab(text: 'Elementler'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: const [
          _TutsuTab(),
          _ImageTab(
            images: ['assets/vefk_ref/melek_pictureBox1.png'],
            caption:
                'Dört element meleği: İsrafil (ateş), Mikail (hava), Cebrail (su), Azrail (toprak)',
          ),
          _GunlerTab(),
          _GezegenImagesTab(),
          _ElementlerTab(),
        ],
      ),
    );
  }
}

class _TutsuTab extends StatelessWidget {
  const _TutsuTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection('Gezegen Tütsüleri', [
          _buildItem('Güneş', 'Günlük veya Sendrus'),
          _buildItem('Ay', 'Günlük'),
          _buildItem('Merkür', 'Mahlep'),
          _buildItem('Venüs', 'Masteki (Hindistan Sakızı)'),
          _buildItem('Mars', 'Kıst (Toprak Otu)'),
          _buildItem('Jüpiter', 'Öd Ağacı ve Kafur'),
          _buildItem('Satürn', 'İyi Amaç için Sandal, Şer İçin Kişniş'),
        ]),
        const SizedBox(height: 16),
        _buildSection('Genel Tütsüler', [
          _buildItem('Berhetiye', 'Berhetiye ile okuma yapılan işleme Sandal'),
          _buildItem('Şer/Sufli', 'Şer Sufli işler için Hardal tohumu veya kişniş'),
          _buildItem('Genel', 'Buhur otu veya Günlükte yakılabilir'),
        ]),
      ],
    );
  }
}

class _GunlerTab extends StatelessWidget {
  const _GunlerTab();

  static const _mainImage = 'assets/vefk_ref/gunler_pictureBox1.png';
  static const _hourImages = [
    'assets/vefk_ref/gunler_pictureBox2.png',
    'assets/vefk_ref/gunler_pictureBox3.png',
    'assets/vefk_ref/gunler_pictureBox5.png',
    'assets/vefk_ref/gunler_pictureBox6.png',
    'assets/vefk_ref/gunler_pictureBox7.png',
    'assets/vefk_ref/gunler_pictureBox8.png',
    'assets/vefk_ref/gunler_pictureBox9.png',
    'assets/vefk_ref/gunler_pictureBox4.png',
    'assets/vefk_ref/gunler_pictureBox10.png',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _assetImage(_mainImage),
        const SizedBox(height: 12),
        const Text(
          'Günler, gezegenler ve saatler',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._hourImages.map(_assetImage),
        const SizedBox(height: 16),
        _buildSection('Günler ve Gezegen İlişkisi', [
          _buildItem('Pazar', 'Güneş — Ateş — Ulvi işler, makam, mevki'),
          _buildItem('Pazartesi', 'Ay — Su — Seyahat, ticaret'),
          _buildItem('Salı', 'Mars — Ateş — Savaş, mücadele, güç'),
          _buildItem('Çarşamba', 'Merkür — Hava — İlim, ticaret, iletişim'),
          _buildItem('Perşembe', 'Jüpiter — Bereket, hayır, ibad'),
          _buildItem('Cuma', 'Venüs — Muhabbet, sevgi, nikah'),
          _buildItem('Cumartesi', 'Satürn — Bağlama, engelleme'),
        ]),
      ],
    );
  }
}

class _GezegenImagesTab extends StatelessWidget {
  const _GezegenImagesTab();

  static const _images = [
    'assets/vefk_ref/gezegen_pictureBox1.png',
    'assets/vefk_ref/gezegen_pictureBox5.png',
    'assets/vefk_ref/gezegen_pictureBox2.png',
    'assets/vefk_ref/gezegen_pictureBox4.png',
    'assets/vefk_ref/gezegen_pictureBox3.png',
    'assets/vefk_ref/gezegen_pictureBox6.png',
    'assets/vefk_ref/gezegen_pictureBox7.png',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (final path in _images) ...[
          _assetImage(path),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 8),
        _buildGezegenCard('Güneş (Şems)', 'Ateş', Colors.orange,
            'Liderlik, güç, yükselme, makam, mevki. Altın, sarı renk.'),
        _buildGezegenCard('Ay (Kamer)', 'Su', Colors.blue,
            'Duygusallık, sezgi, değişkenlik, seyahat. Gümüş, beyaz renk.'),
        _buildGezegenCard('Mars (Merih)', 'Ateş', Colors.red,
            'Enerji, mücadele, savaş, cesaret. Demir, kırmızı renk.'),
        _buildGezegenCard('Merkür (Utarid)', 'Hava', Colors.green,
            'Zeka, iletişim, ticaret, ilim. Cıva, yeşil renk.'),
        _buildGezegenCard('Jüpiter (Müşteri)', 'Toprak/Su', Colors.purple,
            'Bereket, şans, fırsat, adalet. Kalay, mor renk.'),
        _buildGezegenCard('Venüs (Zühre)', 'Su/Ateş', Colors.pink,
            'Aşk, cazibe, güzellik, sanat. Bakır, pembe renk.'),
        _buildGezegenCard('Satürn (Zuhal)', 'Toprak', Colors.grey,
            'Disiplin, sınır, yalnızlık, sabır. Kurşun, siyah renk.'),
      ],
    );
  }

  Widget _buildGezegenCard(
      String name, String element, Color color, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(Icons.circle, color: color, size: 20),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Element: $element',
                style: TextStyle(color: color, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(desc),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}

class _ElementlerTab extends StatelessWidget {
  const _ElementlerTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _elementCard(
          'Ateş',
          'İsrafil (a.s.)',
          Colors.red,
          Icons.local_fire_department,
          'Sıcak ve kuru tabiatlıdır. Güneş ve Mars ile ilişkilidir. '
              'Ulvi işler, güç, yükselme ve cesaret konularında kullanılır.',
        ),
        _elementCard(
          'Hava',
          'Mikail (a.s.)',
          Colors.lightBlue,
          Icons.air,
          'Sıcak ve nemli tabiatlıdır. Merkür ile ilişkilidir. '
              'İlim, iletişim, ticaret ve haberleşme işlerinde tercih edilir.',
        ),
        _elementCard(
          'Su',
          'Cebrail (a.s.)',
          Colors.blue,
          Icons.water_drop,
          'Soğuk ve nemli tabiatlıdır. Ay ve Venüs ile ilişkilidir. '
              'Muhabbet, seyahat, duygu ve sezgi işlerinde kullanılır.',
        ),
        _elementCard(
          'Toprak',
          'Azrail (a.s.)',
          Colors.brown,
          Icons.landscape,
          'Soğuk ve kuru tabiatlıdır. Satürn ve Jüpiter ile ilişkilidir. '
              'Sabır, bağlama, engelleme ve kalıcılık işlerinde tercih edilir.',
        ),
        const SizedBox(height: 8),
        _buildSection('Görevli Melekler (Günlere Göre)', [
          _buildItem('Pazar', 'Rukyail (Güneş)'),
          _buildItem('Pazartesi', 'Cebrail (Ay)'),
          _buildItem('Salı', 'Semsamail (Mars)'),
          _buildItem('Çarşamba', 'Mikail (Merkür)'),
          _buildItem('Perşembe', 'Sarfiyail (Jüpiter)'),
          _buildItem('Cuma', 'Aniyail (Venüs)'),
          _buildItem('Cumartesi', 'Kesfiyail (Satürn)'),
        ]),
      ],
    );
  }

  Widget _elementCard(
    String element,
    String melek,
    Color color,
    IconData icon,
    String desc,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$element Elementi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    melek,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(desc),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageTab extends StatelessWidget {
  const _ImageTab({required this.images, this.caption});

  final List<String> images;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (caption != null) ...[
          Text(caption!, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
        ],
        for (final path in images) ...[
          _assetImage(path),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

Widget _assetImage(String path) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        height: 80,
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: Text('Görsel yüklenemedi: $path',
            style: const TextStyle(fontSize: 12)),
      ),
    ),
  );
}

Widget _buildSection(String title, List<Widget> items) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          ...items,
        ],
      ),
    ),
  );
}

Widget _buildItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(label,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}

/// Vefk ekranından hızlı erişim butonları
class VefkReferansButtonBar extends StatelessWidget {
  const VefkReferansButtonBar({super.key});

  static const _tabs = [
    ('Tütsüler', 0, Icons.spa),
    ('Melekler', 1, Icons.auto_awesome),
    ('Günler', 2, Icons.calendar_today),
    ('Gezegenler', 3, Icons.public),
    ('Elementler', 4, Icons.whatshot),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            for (final (label, tab, icon) in _tabs)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: OutlinedButton.icon(
                  icon: Icon(icon, size: 16),
                  label: Text(label, style: const TextStyle(fontSize: 12)),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VefkReferansScreen(initialTab: tab),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
