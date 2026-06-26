/// Metni ayetlere böler.
///
/// Metinde ayet numarası (1. 2. 3. … veya Arapça ٠١٢ / Farsça ۰۱۲ rakamları,
/// ayet sonu işareti ۝) varsa bunlara göre böler — böylece uzun ayetler bir
/// alt satıra kaysa bile doğru sayılır. Numara yoksa satır sonlarına göre böler.
List<String> ayetlereBol(String metin) {
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
