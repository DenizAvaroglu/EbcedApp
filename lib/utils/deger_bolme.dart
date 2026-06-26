class DegerBolme {
  static ({int parca1, int parca2, String oran})? bol(int deger) {
    if (deger % 5 == 0) {
      return (parca1: deger * 2 ~/ 5, parca2: deger * 3 ~/ 5, oran: '2/5 - 3/5');
    }
    if (deger % 3 == 0) {
      return (parca1: deger ~/ 3, parca2: deger * 2 ~/ 3, oran: '1/3 - 2/3');
    }
    if (deger % 7 == 0) {
      return (parca1: deger * 3 ~/ 7, parca2: deger * 4 ~/ 7, oran: '3/7 - 4/7');
    }
    return null;
  }
}
