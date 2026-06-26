enum IsimTuru {
  sahis(0, 'in', 'Şahıs (0, in)'),
  ulvi(41, 'ayil', 'Ulvi (-41, ayil)'),
  sufli(316, 'yuşin', 'Sufli (-316, yuşin)'),
  ser(319, 'tayşin', 'Şer (-319, tayşin)');

  final int cikarilacakDeger;
  final String ek;
  final String gorunenAd;

  const IsimTuru(this.cikarilacakDeger, this.ek, this.gorunenAd);
}
