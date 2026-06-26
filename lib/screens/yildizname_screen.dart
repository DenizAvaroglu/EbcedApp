import 'package:flutter/material.dart';
import '../utils/ebced_calculator.dart';

class YildizNameScreen extends StatefulWidget {
  const YildizNameScreen({super.key});

  @override
  State<YildizNameScreen> createState() => _YildizNameScreenState();
}

class _YildizNameScreenState extends State<YildizNameScreen> {
  final _isimController = TextEditingController();
  final _ebcedManuelController = TextEditingController();
  final _partnerIsimController = TextEditingController();

  DateTime _dogumTarihi = DateTime(2000, 1, 1);
  DateTime _bugunTarihi = DateTime.now();

  final List<String> _gezegenler = [
    'Güneş',
    'Ay',
    'Mars',
    'Merkür',
    'Jüpiter',
    'Venüs',
    'Satürn',
  ];

  final Set<int> _seciliGezegenler = {};

  int _ebcedDegeri = 0;
  Map<String, int> _unsurDagilimi = {
    'Ateş': 0,
    'Toprak': 0,
    'Hava': 0,
    'Su': 0,
  };
  Map<String, int>? _hicriDogum;
  Map<String, int>? _hicriGuncel;

  final Map<String, List<String>> _analizSonuclari = {};
  String? _evlilikSonucu;

  // --- Unsur (Element) tablosu ---
  static const Map<String, String> _harfUnsur = {
    'ا': 'Ateş', 'ه': 'Ateş', 'ط': 'Ateş', 'م': 'Ateş',
    'ف': 'Ateş', 'ش': 'Ateş', 'ذ': 'Ateş',
    'ب': 'Toprak', 'و': 'Toprak', 'ي': 'Toprak', 'ن': 'Toprak',
    'ص': 'Toprak', 'ت': 'Toprak', 'ض': 'Toprak',
    'ج': 'Hava', 'ز': 'Hava', 'ك': 'Hava', 'س': 'Hava',
    'ق': 'Hava', 'ث': 'Hava', 'ظ': 'Hava',
    'د': 'Su', 'ح': 'Su', 'ل': 'Su', 'ع': 'Su',
    'ر': 'Su', 'خ': 'Su', 'غ': 'Su',
  };

  // --- Gezegen yorumları (7 gezegen × 6 kategori) — orijinal detaylı metinler ---
  static final Map<String, Map<int, String>> _gezegenYorumlari = {
    'Kişilik': {
      0: "GÜNEŞ (Ateş – Liderlik, Güç, Yükselme, Büyüme)\n\nKişilik olarak liderlik, iş olarak makam mevki, ailede parlama, sağlık olarak iyileşme, hayat olarak önemli bir gelişme, evlilik, yeni ve güzel bir yön çizme vb., yapısı ile ateş elementine yakındır. Yöneticidir. Güçlendiricidir. Yükseltici arttırıcı ve genişleticidir. Aynı zamanda biraz itiraf edilmeyen yalnızlıktır. Galip gelmektir.\n\nGüneş kişiliğe güçlü bir benlik, lider ruhu ve özgüven verir. Ateş elementi etkisiyle hırslı, mücadeleci, enerjik ve yaratıcıdır. Kendini ön planda tutmak ister ve başkaları tarafından fark edilmek onun için önemlidir. Yükselmeye ve başarılı olmaya odaklanır.\n\nAncak gizli bir yalnızlık taşır. İnsanlara yol gösterir, ışık olur ama kendisi genellikle yalnız hisseder. Çünkü Güneş merkezde durur ve her şey onun etrafında döner. Bazen fazla otoriter, inatçı ve kontrolcü olabilir.\n\nHer şeyi kendi yapmak ister ama bu ona büyük bir yük getirir.\n\nEğer hava elementi etkisi varsa, daha konuşkan ve sosyal olur ama yine de insanlara mesafeli yaklaşır. Su elementi etkisinde daha duyarlı ve sezgisel, toprak elementi etkisinde daha disiplinli ve güvenilir, ateş etkisinde ise son derece hırslı, baskın ve lider ruhludur.",
      1: "AY (Su – Duygusallık, Sezgisellik, Değişkenlik)\n\nDuygudur, hassaslıktır, durgunluktur, duygusal iletişimdir, su elementidir, şifacılıktır, denizle ilgilidir ve yolculuktur, gizli işlerdir, mide, karın ve kulaktır.\n\nAy insanı duygusal, sezgisel, hassas ve değişken yapar. Su elementi olduğu için derin duygulara sahiptir ve çevresindeki insanların duygularına karşı çok duyarlıdır. Kendi içinde gelgitler yaşayabilir ve bazen mantıktan çok hisleriyle hareket eder.\n\nEğer hava etkisi fazlaysa, duyguları daha gelip geçici olur. Toprak etkisi fazlaysa, duygularını daha dengeli ve sağlam tutar. Ateş etkisi fazlaysa, duygularını yoğun ve tutkulu yaşar.",
      2: "MARS (Ateş – Enerji, Mücadele, Savaş, Tutku)\n\nSavaş, mücadele, düşmanlık, güç, öfke, dominant karakter, fiziksel güç, kas sistemi, safra kesesi, yüz dişler, ateş ve toprak.\n\nMars insanı cesur, mücadeleci, hırslı ve enerjiktir. İçinde bitmek bilmeyen bir hareket ve başarma isteği vardır. Risk almayı sever, meydan okumaktan kaçınmaz ve rekabetçidir. Zorluklardan korkmaz, aksine onları aşmak için büyük bir istek duyar.\n\nAncak sabırsız ve öfkeli olabilir. Bazen ani kararlar alır ve agresif davranabilir. Öfkesini kontrol edemezse çatışmacı bir yapıya bürünebilir.",
      3: "MERKÜR (Hava – Zeka, İletişim, Hareket, Analitik Düşünme)\n\nİletişim, zeka, sanatkarlık, mantık, titizlik, plan yapma, sinir sistemi ve ciğerler, burun, haberler, hava ve toprak.\n\nMerkür insanı zeka, merak ve hızlı düşünme yeteneğiyle öne çıkar. Hızlı öğrenir, çok yönlüdür ve her konu hakkında konuşabilir. Pratik ve çözüm odaklıdır. Kararlarını mantık çerçevesinde alır, ancak bazen yüzeysel veya fazla değişken olabilir.\n\nMerkür insanı konuşkan, sosyal ve iletişimci olur. Bilgiyi paylaşmayı, tartışmayı ve yeni şeyler öğrenmeyi sever.",
      4: "JÜPİTER (Toprak ve Su – Bereket, Maddiyat, Fırsatlar, Şans)\n\nToprak ve su (bereket kısmı), maddiyat, kara ciğer, damarlar, kalça, uyluk, ayak, fırsatlar, müjdeli haberler.\n\nJüpiter insanı geniş perspektife sahip, iyimser ve cömerttir. Fırsatları görmek ve büyümek konusunda doğuştan bir yeteneğe sahiptir. Genellikle pozitif düşünür ve hayatı bir macera olarak görür.\n\nMaddi kazançlar konusunda başarılı olma eğilimindedir ve bu alanda büyük fırsatları çabucak fark eder.",
      5: "VENÜS (Ateş ve Su – Aşk, Cazibe, Zevk, İlişkiler)\n\nŞans, ateş ve su (bazen de havasal özellikler), böbrekler ve bezler, üreme organları, sevgi, aşk, cazibe, zevk ve eğlence.\n\nVenüs insanı cazibesi, güzellik anlayışı ve estetik duygusu ile öne çıkar. İyi bir ilişki kurmaya heveslidir ve sevdiklerine çok şey verir. Hem duygusal hem de fiziksel olarak yoğun bir bağ kurma isteği vardır.",
      6: "SATÜRN (Toprak – Sınırlamalar, Disiplin, Yalnızlık, Sıkıntılar)\n\nSoğukluk, ayrılık, genel olarak olumsuzluk, toprak, kas iskelet sistemi, dalak ve ayaklar, bacaklar, sıkıntılar.\n\nSatürn insanı genellikle sorumluluk sahibi, disiplinli ve ciddi bir kişiliğe sahiptir. Hayatına daha gerçekçi ve pratik bir bakış açısıyla yaklaşır. Ancak bazen olaylara aşırı olumsuz bir şekilde yaklaşabilir, bu da onu karamsar ve depresif yapabilir.",
    },
    'Aile': {
      0: "Güneş, aile içinde baskın bir figürdür. Ailesi ve çevresi ona hayranlık duyar ama aynı zamanda ondan çekinir. Çünkü otoriter bir yapısı vardır. Aile içinde parlayan bir yıldız gibidir ama bazen kendi isteklerini ve yolunu seçmek için ailesine mesafe koyabilir.",
      1: "Ay insanı aileye çok bağlıdır ve ailesine karşı fedakardır. Ancak bazen ailesi tarafından yeterince değer görmediğini hissedebilir.",
      2: "Mars insanı aile içinde baskın ve koruyucu bir figürdür. Sevdiklerini savunur ama bazen gereksiz tartışmalar çıkarabilir. Kendi istediğinin olmasını ister ve aile içinde sözünün geçmesini bekler.",
      3: "Merkür insanı çevresiyle kolayca iletişim kurar. Hızlı düşünen, kolay adapte olan biridir. Ailesiyle iletişimi iyidir, ancak bazen fazla sorgulayıcı ve sabırsız olabilir.",
      4: "Jüpiter insanı ailesiyle ilgili sorumluluklarını yerine getirirken, etrafındaki insanlara da büyük yardımlar sunar. Aile ilişkilerinde sadık ve cömerttir. Ancak, bazen fazla fedakar olabilir ve bu da aşırı yüklenmesine yol açabilir.",
      5: "Venüs insanı çevresindeki insanlarla genellikle uyumlu ilişkilere sahiptir. Aile üyeleriyle de çok yakın ve duyarlı bir bağ kurar. Ancak bazen aşırı duygusal olabilir ve bu da ilişkilere dengesizlik katabilir.",
      6: "Satürn insanı, çevresiyle genellikle mesafeli bir ilişki kurar. Ailesiyle olan bağları bazen soğuk olabilir ve her zaman dikkatli davranmak isteyebilir.",
    },
    'İş': {
      0: "Güneş yöneticilik, otorite ve mevki verir. Ateş elementi güçlü bir çalışma azmi ve kendi işini yapma potansiyeli sunar. İş hayatında yükselmek, tanınmak ve güçlü olmak ister. Çalışkan ve üretkendir ancak bazen kendi bildiğini okumak yüzünden zorluklarla karşılaşabilir.",
      1: "Ay insanı iş hayatında stabil bir çizgi izler. Belirli dönemlerde iyi kazanırken bazı dönemlerde maddi sıkıntılar çekebilir.",
      2: "Mars insanı çalışkan, dinamik ve rekabetçidir. İş hayatında liderlik etmek, mücadele etmek ve öne çıkmak ister. Genellikle risk alır ve cesur kararlar verir. İş ortamında inatçı ve kararlı olması başarı getirebilir. Ancak fevri hareket ederse zarar görebilir.",
      3: "Merkür insanı zekasını kullanarak başarılı olur. İş hayatında iletişim, ticaret, medya ve eğitim gibi alanlarda çok iyi olabilir. Hızlı düşünebildiği için sorunları çabuk çözer ve fırsatları kolay yakalar.",
      4: "Jüpiter insanı, ticaret, yatırım ve fırsatlar konusunda oldukça şanslıdır. Maddi kazanç peşindedir ve başarılı iş fırsatlarını hızlıca değerlendirir. Bununla birlikte, bazı zamanlar fazla savurgan olabilir.",
      5: "Venüs insanı güzellik, sanat ve estetikle ilgili alanlarda başarılı olabilir. Maddi konularda fazla harcama yapabilir, ancak zevklerine önem verir. Yaratıcı işlerde başarılıdır.",
      6: "Satürn insanı iş hayatında istikrara, planlı çalışmaya ve disipline çok önem verir. Başarı, çoğu zaman sabır ve sıkı çalışma ile gelir, ancak her zaman büyük kazançlar elde etmeyebilir.",
    },
    'İlişki': {
      0: "Güneş aşk hayatında baskın, sahiplenici ama cömerttir. Sevdiğine değer verir ama liderliği bırakmak istemez. Partnerini yüceltir ama bazen kendi yoluna uymaya zorlayabilir.",
      1: "Ay insanı aşkta duygusal ve romantiktir. Sevdiği kişiye kendini adayabilir ama bazen fazla hassas olup kolay kırılabilir.",
      2: "Mars insanı aşkta tutkulu, ateşli ve sahiplenicidir. Sevdiği kişiyi elde etmek için mücadele eder ama bazen fazla kıskanç veya baskıcı olabilir. Anlık öfke patlamaları veya sabırsızlık nedeniyle ilişkide sorun yaşayabilir.",
      3: "Merkür insanı duygulardan çok mantığıyla hareket eder. İletişim onun için çok önemlidir, partneriyle konuşabilmeli, fikir alışverişi yapabilmelidir. Ancak duygusal derinlik konusunda zorluk yaşayabilir ve fazla yüzeysel kalabilir.",
      4: "Aşkta genellikle cömert, idealist ve sadıktır. Ancak bazen aşırı iyimserliği ve çok büyük beklentileri ilişkilerinde hayal kırıklığına yol açabilir. Partnerinin duygusal ihtiyaçlarını anlamakta zorluk çekebilir.",
      5: "Aşkta romantik, tutkulu ve özverili bir yapıya sahiptir. İlişkilerde genellikle bağlılık ve sadakat arar. Ancak bazen fazla sahiplenici olabilir ve ilişkinin dengesini zorlayabilir.",
      6: "Satürn insanı aşkta genellikle mesafelidir, duygusal anlamda bağ kurmakta zorluk çeker. İlişkilerinde ciddi ve karamsar bir tutum sergileyebilir. Genellikle uzun vadeli, istikrarlı ilişkiler arar.",
    },
    'Sağlık': {
      0: "Güneş enerji verir ancak baş, göz, kalp ve dolaşım sistemi hassas olabilir. Günlük hayatında hareketli, hedef odaklı ve kendini geliştiren biridir. Ateş elementi hızlı karar almayı ve hareket etmeyi sağlar.",
      1: "Ay sağlığa duygusal etkiler bırakır. Mide, karın ve hormonlarla ilgili hassasiyet olabilir. Günlük hayatında iç dünyasına dönük ve sezgileriyle hareket eden bir yapısı vardır.",
      2: "Mars insanı hareketli, enerjik ve spora yatkındır. Ancak kaza, yaralanma ve sakarlıklara açıktır. Ayrıca öfkesi ve sabırsızlığı yüzünden strese bağlı sağlık sorunları yaşayabilir.",
      3: "Merkür insanı hareketli, enerjik ve zihinsel olarak sürekli meşguldür. Ancak çok düşünmek zihinsel yorgunluk ve stres getirebilir. Ayrıca konuşma organları, eller ve sinir sistemi hassas olabilir.",
      4: "Jüpiter insanı genellikle sağlıklı olur ve yaşamdan zevk alır. Ancak fazla iyimserlik veya aşırıya kaçan aktiviteler bazı sağlık problemlerine yol açabilir. Zihinsel ve fiziksel açıdan genişlemeyi sever.",
      5: "Venüs insanı sağlıklı yaşamaya özen gösterir, ancak bazen zevklerine düşkünlük nedeniyle aşırılıklar olabilir. Sanatla ilgili aktiviteler onun ruhunu canlandırır.",
      6: "Satürn insanı genellikle sağlığı konusunda dikkatli ve tedbirli bir yaklaşım sergiler. Ancak fazla disiplinli olması, stres ve baskı nedeniyle fiziksel ya da psikolojik rahatsızlıklar yaşamasına yol açabilir.",
    },
    'Sıkıntılar': {
      0: "Güneş'in en büyük sıkıntısı yalnızlık ve kibir olabilir. Çok fazla kontrolcü olması bazen başkalarıyla arasına mesafe koyar. İnatçılığı yüzünden fırsatları kaçırabilir.",
      1: "Ay insanı duygusal yönden hassastır ve çabuk etkilenir. İnsanlar onun fedakarlığını suistimal edebilir.",
      2: "Mars insanı en çok öfkesini ve sabırsızlığını kontrol etmekte zorlanır. Fevri kararlar alarak kendini zor duruma sokabilir. Rekabetçi yapısı yüzünden insanlarla sürekli yarış halinde olabilir.",
      3: "Merkür insanı düşüncelerini fazla dağıtabilir ve odaklanmakta zorlanabilir. Çok fazla bilgi edinmek ister ama bazen derinleşmek yerine yüzeysel kalabilir. Ayrıca konuşkanlığı bazen tartışmalara ve yanlış anlaşılmalara yol açabilir.",
      4: "Jüpiter insanı bazen aşırı güven ve iyimserlik nedeniyle başını derde sokabilir. Ayrıca, fazla özgürlük isteği bazen düzenli bir yaşam sürmesini engelleyebilir.",
      5: "Venüs insanı, bazen aşırı rahatına düşkün olabilir ve sorumluluklarını ihmal edebilir. Keyif ve konfor odaklı olduğu için disiplin gerektiren işlerde zorlanabilir. Maddi konularda lükse olan düşkünlüğü bazen savurganlık yapmasına neden olabilir.",
      6: "Satürn insanı sık sık olumsuz düşüncelere kapılır ve hayatındaki zorluklar üzerine fazla kafa yorar. Zorluklar karşısında karamsarlık, yalnızlık ve umutsuzluk hissi yaygın olabilir.",
    },
  };

  // --- Evlilik yorumları (9 sonuç) ---
  static const Map<int, String> _evlilikYorumlari = {
    0: 'Mükemmel uyum! Bu çift birbirini tamamlıyor, güçlü bir bağ.',
    1: 'İyi bir uyum. Karşılıklı saygı ve anlayış ile mutlu bir birliktelik.',
    2: 'Uyumlu bir çift. Küçük farklılıklar zenginlik katıyor.',
    3: 'Orta düzey uyum. İletişim güçlendirilmeli.',
    4: 'Zorlayıcı ama öğretici bir ilişki. Sabır gerektirir.',
    5: 'Farklılıklar belirgin. Ortak noktalar bulmak önemli.',
    6: 'Zor bir kombinasyon. Karşılıklı fedakarlık şart.',
    7: 'Çatışma potansiyeli yüksek. Profesyonel destek faydalı olabilir.',
    8: 'Çok zor bir uyum. Ancak güçlü irade ile sürdürülebilir.',
  };

  // --- Miladi → Hicri çevrim ---
  static Map<String, int> miladiToHicri(int year, int month, int day) {
    int a = ((14 - month) / 12).floor();
    int y = year + 4800 - a;
    int m = month + 12 * a - 3;
    int jd = day +
        ((153 * m + 2) / 5).floor() +
        365 * y +
        (y / 4).floor() -
        (y / 100).floor() +
        (y / 400).floor() -
        32045;

    int l = jd - 1948440 + 10632;
    int n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;
    int j = ((10985 - l) / 5316).floor() * ((50 * l) / 17719).floor() +
        ((l) / 5670).floor() * ((43 * l) / 15238).floor();
    l = l -
        ((30 - j) / 15).floor() * ((17719 * j) / 50).floor() -
        ((j) / 16).floor() * ((15238 * j) / 43).floor() +
        29;
    int hMonth = ((24 * l) / 709).floor();
    int hDay = l - ((709 * hMonth) / 24).floor();
    int hYear = 30 * n + j - 30;

    return {'year': hYear, 'month': hMonth, 'day': hDay};
  }

  // --- Unsur hesaplama ---
  Map<String, int> _unsurHesapla(String metin) {
    final dagilim = {'Ateş': 0, 'Toprak': 0, 'Hava': 0, 'Su': 0};
    final temiz = EbcedCalculator.temizle(metin);
    for (int i = 0; i < temiz.length; i++) {
      final c = temiz[i];
      if (_harfUnsur.containsKey(c)) {
        dagilim[_harfUnsur[c]!] = dagilim[_harfUnsur[c]!]! + 1;
      }
    }
    return dagilim;
  }

  void _hesaplaEbced() {
    final isim = _isimController.text.trim();
    if (isim.isEmpty) return;

    setState(() {
      _ebcedDegeri = EbcedCalculator.ebcedHesapla(isim);
      _ebcedManuelController.text = _ebcedDegeri.toString();
      _unsurDagilimi = _unsurHesapla(isim);

      _hicriDogum = miladiToHicri(
          _dogumTarihi.year, _dogumTarihi.month, _dogumTarihi.day);
      _hicriGuncel = miladiToHicri(
          _bugunTarihi.year, _bugunTarihi.month, _bugunTarihi.day);

      _analizSonuclari.clear();
      _evlilikSonucu = null;
    });
  }

  int _getEbced() {
    final manuel = int.tryParse(_ebcedManuelController.text);
    return manuel ?? _ebcedDegeri;
  }

  // Her kategori, seçilen gezegen saatlerinden kendi sırasındakini kullanır:
  // Kişilik→1., Aile→2., İş→3., İlişki→4., Sağlık→5., Sıkıntılar→6. gezegen.
  static const Map<String, int> _kategoriSaatSirasi = {
    'Kişilik': 0,
    'Aile': 1,
    'İş': 2,
    'İlişki': 3,
    'Sağlık': 4,
    'Sıkıntılar': 5,
  };

  void _analizYap(String kategori) {
    final ebced = _getEbced();
    if (ebced == 0) return;

    final hD = _hicriDogum ??
        miladiToHicri(
            _dogumTarihi.year, _dogumTarihi.month, _dogumTarihi.day);
    final hG = _hicriGuncel ??
        miladiToHicri(
            _bugunTarihi.year, _bugunTarihi.month, _bugunTarihi.day);

    int birthPlanet;
    int currentPlanet;

    switch (kategori) {
      case 'Kişilik':
        birthPlanet = ebced % 7;
        currentPlanet = (_bugunTarihi.year + _dogumTarihi.year) % 7;
        break;
      case 'Aile':
        birthPlanet = _dogumTarihi.month % 7;
        currentPlanet = (_bugunTarihi.month + _dogumTarihi.month) % 7;
        break;
      case 'İş':
        birthPlanet = _dogumTarihi.day % 7;
        currentPlanet = (_bugunTarihi.day + _dogumTarihi.day) % 7;
        break;
      case 'İlişki':
        birthPlanet = hD['year']! % 7;
        currentPlanet = (hG['year']! + hD['year']!) % 7;
        break;
      case 'Sağlık':
        birthPlanet = hD['month']! % 7;
        currentPlanet = (hG['month']! + hD['month']!) % 7;
        break;
      case 'Sıkıntılar':
        birthPlanet = hD['day']! % 7;
        currentPlanet = (hG['day']! + hD['day']!) % 7;
        break;
      default:
        return;
    }

    // Gezegen saati: kategorinin sırasına denk gelen seçili gezegen.
    // _seciliGezegenler ekleme sırasını korur (LinkedHashSet).
    final secimSirasi = _seciliGezegenler.toList();
    final saatSirasi = _kategoriSaatSirasi[kategori]!;
    final int? gezegenSaati =
        saatSirasi < secimSirasi.length ? secimSirasi[saatSirasi] : null;

    final yorumlar = _gezegenYorumlari[kategori]!;

    setState(() {
      _analizSonuclari[kategori] = [
        '🌟 Doğum Gezegeni: ${_gezegenler[birthPlanet]}',
        yorumlar[birthPlanet] ?? '',
        '',
        '🔄 Güncel Gezegen: ${_gezegenler[currentPlanet]}',
        yorumlar[currentPlanet] ?? '',
        '',
        if (gezegenSaati != null) ...[
          '⏰ Gezegen Saati (${saatSirasi + 1}. seçim): ${_gezegenler[gezegenSaati]}',
          yorumlar[gezegenSaati] ?? '',
        ] else
          '⏰ Gezegen Saati: ${saatSirasi + 1}. sıra için gezegen seçilmedi '
              '(yukarıdan en az ${saatSirasi + 1} gezegen seçin)',
      ];
    });
  }

  void _evlilikHesapla() {
    final isim1 = _isimController.text.trim();
    final isim2 = _partnerIsimController.text.trim();
    if (isim1.isEmpty || isim2.isEmpty) return;

    final ebced1 = _getEbced();
    final ebced2 = EbcedCalculator.ebcedHesapla(isim2);
    final sonuc = (ebced1 + ebced2 + 7) % 9;

    setState(() {
      _evlilikSonucu =
          'Ebced 1: $ebced1 | Ebced 2: $ebced2\n'
          'Formül: ($ebced1 + $ebced2 + 7) % 9 = $sonuc\n\n'
          '${_evlilikYorumlari[sonuc]}';
    });
  }

  Future<void> _tarihSec(bool dogum) async {
    final secilen = await showDatePicker(
      context: context,
      initialDate: dogum ? _dogumTarihi : _bugunTarihi,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('tr', 'TR'),
    );
    if (secilen != null) {
      setState(() {
        if (dogum) {
          _dogumTarihi = secilen;
        } else {
          _bugunTarihi = secilen;
        }
      });
    }
  }

  String _tarihFormat(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';

  String _hicriFormat(Map<String, int>? h) {
    if (h == null) return '-';
    return '${h['day']}.${h['month']}.${h['year']}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yıldız Name Cifir'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Giriş Alanları ──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bilgi Girişi',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _isimController,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        labelText: 'Arapça İsim',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      onChanged: (_) => _hesaplaEbced(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _ebcedManuelController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Ebced Değeri (otomatik / manuel)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calculate),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _tarihSec(true),
                            icon: const Icon(Icons.cake),
                            label: Text(
                                'Doğum: ${_tarihFormat(_dogumTarihi)}'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _tarihSec(false),
                            icon: const Icon(Icons.today),
                            label: Text(
                                'Bugün: ${_tarihFormat(_bugunTarihi)}'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Gezegen Saati Seçimi ──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gezegen Saati Seçimi (maks. 6)',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      'Seçim sırası kategorilere eşlenir: '
                      '1.→Kişilik, 2.→Aile, 3.→İş, 4.→İlişki, 5.→Sağlık, 6.→Sıkıntılar',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: List.generate(_gezegenler.length, (i) {
                        final secili = _seciliGezegenler.contains(i);
                        final sira = secili
                            ? _seciliGezegenler.toList().indexOf(i) + 1
                            : 0;
                        return FilterChip(
                          label: Text(secili
                              ? '$sira. ${_gezegenler[i]}'
                              : _gezegenler[i]),
                          selected: secili,
                          onSelected: (val) {
                            setState(() {
                              if (val) {
                                if (_seciliGezegenler.length < 6) {
                                  _seciliGezegenler.add(i);
                                }
                              } else {
                                _seciliGezegenler.remove(i);
                              }
                            });
                          },
                          selectedColor: Colors.amber[200],
                          avatar: Icon(_gezegenIkonu(i), size: 18),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Hesapla Butonu ──
            ElevatedButton.icon(
              onPressed: _hesaplaEbced,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Hesapla'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 16),

            // ── Sonuçlar ──
            if (_ebcedDegeri > 0) ...[
              Card(
                color: Colors.indigo[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sonuçlar',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const Divider(),
                      _bilgiSatiri('Ebced Değeri', _ebcedDegeri.toString()),
                      const SizedBox(height: 8),
                      Text('Unsur Dağılımı:',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _unsurChip('Ateş 🔥', _unsurDagilimi['Ateş']!,
                              Colors.red[100]!),
                          _unsurChip('Hava 🌬️', _unsurDagilimi['Hava']!,
                              Colors.lightBlue[100]!),
                          _unsurChip('Su 💧', _unsurDagilimi['Su']!,
                              Colors.blue[100]!),
                          _unsurChip('Toprak 🌍', _unsurDagilimi['Toprak']!,
                              Colors.brown[100]!),
                        ],
                      ),
                      const Divider(),
                      _bilgiSatiri('Hicri Doğum',
                          _hicriFormat(_hicriDogum)),
                      _bilgiSatiri('Hicri Güncel',
                          _hicriFormat(_hicriGuncel)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Analiz Kategorileri ──
              Text('Cifir Analizi',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              ..._kategoriListesi(),

              const SizedBox(height: 16),

              // ── Evlilik Cifir ──
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Evlilik Cifir Hesabı',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _isimController,
                        enabled: false,
                        textDirection: TextDirection.rtl,
                        decoration: const InputDecoration(
                          labelText: 'Kendi İsminiz',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _partnerIsimController,
                        textDirection: TextDirection.rtl,
                        decoration: const InputDecoration(
                          labelText: 'Eş Adayı İsmi (Arapça)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.favorite),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _evlilikHesapla,
                          icon: const Icon(Icons.favorite_border),
                          label: const Text('Evlilik Uyumunu Hesapla'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink[300],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      if (_evlilikSonucu != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.pink[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.pink[200]!),
                          ),
                          child: Text(_evlilikSonucu!,
                              style: const TextStyle(fontSize: 14)),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  List<Widget> _kategoriListesi() {
    const kategoriler = [
      ('Kişilik', Icons.psychology),
      ('Aile', Icons.family_restroom),
      ('İş', Icons.work),
      ('İlişki', Icons.people),
      ('Sağlık', Icons.health_and_safety),
      ('Sıkıntılar', Icons.warning_amber),
    ];

    return kategoriler.map((k) {
      final ad = k.$1;
      final ikon = k.$2;
      final sonuc = _analizSonuclari[ad];

      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ExpansionTile(
          leading: Icon(ikon, color: Colors.indigo),
          title: Text(ad, style: const TextStyle(fontWeight: FontWeight.w600)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (sonuc == null)
                TextButton(
                  onPressed: () => _analizYap(ad),
                  child: const Text('Analiz Et'),
                ),
              const Icon(Icons.expand_more),
            ],
          ),
          initiallyExpanded: sonuc != null,
          children: [
            if (sonuc == null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () => _analizYap(ad),
                  child: Text('$ad Analizi Yap'),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sonuc
                      .where((s) => s.isNotEmpty)
                      .map((s) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(s, style: const TextStyle(fontSize: 14)),
                          ))
                      .toList(),
                ),
              ),
          ],
        ),
      );
    }).toList();
  }

  Widget _bilgiSatiri(String baslik, String deger) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(baslik,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(deger,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _unsurChip(String label, int sayi, Color renk) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: renk,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text('$label: $sayi',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  IconData _gezegenIkonu(int index) {
    switch (index) {
      case 0:
        return Icons.wb_sunny;
      case 1:
        return Icons.nightlight_round;
      case 2:
        return Icons.shield;
      case 3:
        return Icons.speed;
      case 4:
        return Icons.star;
      case 5:
        return Icons.favorite;
      case 6:
        return Icons.ring_volume;
      default:
        return Icons.circle;
    }
  }

  @override
  void dispose() {
    _isimController.dispose();
    _ebcedManuelController.dispose();
    _partnerIsimController.dispose();
    super.dispose();
  }
}
