import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ogireal_app/common/data/dataCustomClass.dart';
import 'package:ogireal_app/common/data/firebase.dart';
import 'package:ogireal_app/common/logic.dart';
import 'package:ogireal_app/common/provider.dart';
import 'package:ogireal_app/scene/homeScene/homeSceneProvider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends ConsumerWidget {
  final DateTime startDay = DateTime.utc(2024, 5, 23);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _selectedDay = ref.watch(selectedDateProvider);

    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.white, // カレンダー背景を白色に設定
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5, // 必要に応じて高さを調整
        ),
        child: TableCalendar(
          firstDay: startDay,
          lastDay: globalDate,
          focusedDay: _selectedDay,
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) async {
            if (!isSameDay(_selectedDay, selectedDay)) {
              ref.read(selectedDateProvider.notifier).state = selectedDay;
              String _selectedDayString = getSelectedDateString(ref);
              await FirebaseFunction()
                  .getDateUserPostCardIdsFromFirebase(ref, _selectedDayString);
              await setNowShowPostsCardIds(ref, _selectedDayString, false);
              await fetchThemeToProviderFromFirebase(ref, _selectedDayString);
              Navigator.of(context).pop();
            }
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              if (day.isBefore(startDay) || day.isAfter(globalDate)) {
                return Center(
                  child: Text(
                    day.day.toString(),
                    style: TextStyle(color: Colors.grey[400]), // 薄めのグレー
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    day.day.toString(),
                    style: TextStyle(color: Colors.black), // 黒色
                  ),
                );
              }
            },
            selectedBuilder: (context, day, focusedDay) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.all(6.0),
                width: 50,
                height: 50,
                child: Center(
                  child: Text(
                    day.day.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
            todayBuilder: (context, day, focusedDay) {
              if (day.isBefore(startDay) || day.isAfter(globalDate)) {
                return Center(
                  child: Text(
                    day.day.toString(),
                    style: TextStyle(color: Colors.black), // 黒色
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    day.day.toString(),
                    style: TextStyle(color: Colors.grey[400]), // 薄めのグレー
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
