import 'package:flutter/material.dart';
import '../models/isim_turu.dart';

class IsimTuruDropdown extends StatelessWidget {
  final IsimTuru secili;
  final ValueChanged<IsimTuru?> onChanged;

  const IsimTuruDropdown({
    super.key,
    required this.secili,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<IsimTuru>(
      value: secili,
      isExpanded: true,
      items: IsimTuru.values.map((tur) {
        return DropdownMenuItem<IsimTuru>(
          value: tur,
          child: Text(tur.gorunenAd),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
