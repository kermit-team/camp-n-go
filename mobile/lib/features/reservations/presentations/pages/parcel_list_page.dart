import 'package:campngo/config/constants.dart';
import 'package:campngo/features/reservations/domain/entities/parcel_entity.dart';
import 'package:campngo/features/reservations/presentations/widgets/parcel_list.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/texts/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ParcelListPage extends StatelessWidget {
  const ParcelListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBody(
      child: Column(
        children: [
          TitleText(LocaleKeys.parcelList.tr()),
          const SizedBox(
            height: Constants.spaceM,
            width: double.maxFinite,
          ),
          ParcelList(
            onListTilePressed: (parcel) {},
            parcelList: [
              ParcelEntity(
                parcelNumber: 1,
                pricePerDay: 100,
                description:
                    "To jest fajna parcela w cieniu lipy, usiądziesz tam spokojnie wędrowcze...",
                generalInfo: Map.fromEntries(
                  [
                    const MapEntry("W cieniu", "tak"),
                    const MapEntry("Podpięcie do wody", "tak"),
                    const MapEntry("Podpięcie do prądu", "nie"),
                    const MapEntry("Prosecco w kranie", "chciałbyś jełopie"),
                  ],
                ),
              ),
              ParcelEntity(
                parcelNumber: 1,
                pricePerDay: 100,
                description:
                    "To jest fajna parcela w cieniu lipy, usiądziesz tam spokojnie wędrowcze...",
                generalInfo: Map.fromEntries(
                  [
                    const MapEntry("W cieniu", "tak"),
                    const MapEntry("Podpięcie do wody", "tak"),
                    const MapEntry("Podpięcie do prądu", "nie"),
                    const MapEntry("Prosecco w kranie", "chciałbyś jełopie"),
                  ],
                ),
              ),
              ParcelEntity(
                parcelNumber: 1,
                pricePerDay: 100,
                description:
                    "To jest fajna parcela w cieniu lipy, usiądziesz tam spokojnie wędrowcze...",
                generalInfo: Map.fromEntries(
                  [
                    const MapEntry("W cieniu", "tak"),
                    const MapEntry("Podpięcie do wody", "tak"),
                    const MapEntry("Podpięcie do prądu", "nie"),
                    const MapEntry("Prosecco w kranie", "chciałbyś jełopie"),
                  ],
                ),
              ),
              ParcelEntity(
                parcelNumber: 1,
                pricePerDay: 100,
                description:
                    "To jest fajna parcela w cieniu lipy, usiądziesz tam spokojnie wędrowcze...",
                generalInfo: Map.fromEntries(
                  [
                    const MapEntry("W cieniu", "tak"),
                    const MapEntry("Podpięcie do wody", "tak"),
                    const MapEntry("Podpięcie do prądu", "nie"),
                    const MapEntry("Prosecco w kranie", "chciałbyś jełopie"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
