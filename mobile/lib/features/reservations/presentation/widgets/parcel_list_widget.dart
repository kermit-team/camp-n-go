import 'package:campngo/config/constants.dart';
import 'package:campngo/core/resources/submission_status.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:campngo/features/reservations/presentation/cubit/parcel_list_cubit.dart';
import 'package:campngo/features/reservations/presentation/widgets/parcel_details_dialog.dart';
import 'package:campngo/features/reservations/presentation/widgets/parcel_list_tile.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParcelListWidget extends StatefulWidget {
  const ParcelListWidget({super.key});

  @override
  State<ParcelListWidget> createState() => _ParcelListWidgetState();
}

class _ParcelListWidgetState extends State<ParcelListWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isAtBottom() &&
        context.read<ParcelListCubit>().state.hasMoreParcels!) {
      _loadMoreTasks();
    }
  }

  bool _isAtBottom() {
    return _scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent;
  }

  void _loadMoreTasks() {
    final currentState = context.read<ParcelListCubit>().state;
    context.read<ParcelListCubit>().getParcelList(
          page: currentState.currentPage! + 1,
          params: currentState.params!,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParcelListCubit, ParcelListState>(
      builder: (context, state) {
        if (state.getParcelListStatus == SubmissionStatus.loading ||
            state.getParcelListStatus == SubmissionStatus.initial) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        } else if (state.getParcelListStatus == SubmissionStatus.failure) {
          return Expanded(
            child: Center(
              child: Text(LocaleKeys.somethingWentWrong.tr()),
            ),
          );
        } else {
          return Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: Constants.spaceM),
              controller: _scrollController,
              itemCount:
                  state.parcels!.length + (state.hasMoreParcels! ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.parcels!.length) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: Constants.spaceM),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                return ParcelListTile(
                  parcel: state.parcels![index],
                  onListTilePressed: (Parcel parcel) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ParcelDetailsDialog(
                          parcel: parcel,
                          params: state.params!,
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}

// import 'package:campngo/config/constants.dart';
// import 'package:campngo/features/reservations/domain/entities/parcel.dart';
// import 'package:campngo/features/reservations/presentation/widgets/parcel_details_dialog.dart';
// import 'package:campngo/features/shared/widgets/texts/key_value_text.dart';
// import 'package:campngo/features/shared/widgets/texts/subtitle_text.dart';
// import 'package:campngo/generated/locale_keys.g.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
//
// class ParcelList extends StatelessWidget {
//   final void Function(Parcel) onListTilePressed;
//   final List<Parcel> parcelList;
//
//   const ParcelList({
//     super.key,
//     required this.onListTilePressed,
//     required this.parcelList,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     //TODO: add cubit handling
//     return Column(
//       children: [
//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           padding: const EdgeInsets.all(0),
//           itemCount: parcelList.length,
//           itemBuilder: (context, index) {
//             final parcel = parcelList[index];
//             return ParcelListItem(
//               parcel: parcel,
//               onListTilePressed: onListTilePressed,
//             );
//           },
//         )
//       ],
//     );
//   }
// }
//
// class ParcelListItem extends StatelessWidget {
//   final Parcel parcel;
//   final void Function(Parcel) onListTilePressed;
//
//   const ParcelListItem({
//     super.key,
//     required this.parcel,
//     required this.onListTilePressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.only(
//         bottom: Constants.spaceM,
//       ),
//       color: Theme.of(context).colorScheme.surface,
//       elevation: 0,
//       shape: Border.fromBorderSide(
//         BorderSide(
//           color: Theme.of(context).colorScheme.primary,
//         ),
//       ),
//       child: InkWell(
//         onTap: () {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return ParcelDetailsDialog(
//                 parcel: parcel,
//               );
//             },
//           );
//         },
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             vertical: Constants.spaceM,
//             horizontal: Constants.spaceM,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: SubtitleText(
//                   "${LocaleKeys.parcelNumber.tr()} ${parcel.parcelNumber}",
//                   isUnderlined: true,
//                 ),
//               ),
//               SizedBox(height: Constants.spaceS),
//               KeyValueText(
//                 keyText: "Price per day (USD)",
//                 valueText: "${parcel.pricePerDay}",
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
