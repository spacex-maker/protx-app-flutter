import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationData {
  static Map<String, List<String>> getLocationData(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return {
      l10n.countryChina: [
        l10n.cityBeijing,
        l10n.cityShanghai,
        l10n.cityGuangzhou,
        l10n.cityShenzhen,
        l10n.cityHangzhou,
        l10n.cityChengdu,
        l10n.cityWuhan,
        l10n.cityXian,
        l10n.cityNanjing,
        l10n.cityChongqing,
      ],
      l10n.countryUSA: [
        l10n.cityNewYork,
        l10n.cityLosAngeles,
        l10n.cityChicago,
        l10n.citySanFrancisco,
        l10n.citySeattle,
        l10n.cityBoston,
        l10n.cityMiami,
        l10n.cityLasVegas,
      ],
      l10n.countryJapan: [
        l10n.cityTokyo,
        l10n.cityOsaka,
        l10n.cityNagoya,
        l10n.citySapporo,
        l10n.cityFukuoka,
        l10n.cityKobe,
        l10n.cityKyoto,
      ],
      l10n.countryKorea: [
        l10n.citySeoul,
        l10n.cityBusan,
        l10n.cityIncheon,
        l10n.cityDaegu,
        l10n.cityGwangju,
        l10n.cityDaejeon,
        l10n.cityUlsan,
      ],
    };
  }
}
