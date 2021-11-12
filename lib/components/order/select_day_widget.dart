import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salon/provider/order_provider.dart';
import 'package:salon/repository.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectDayWidget extends StatefulWidget {
  SelectDayWidget({Key key}) : super(key: key);

  @override
  _SelectDayWidgetState createState() => _SelectDayWidgetState();
}

class _SelectDayWidgetState extends State<SelectDayWidget> {
  @override
  Widget build(BuildContext context) {
    OrderProvider val = Provider.of(context);
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background, border: Border.all(color: Theme.of(context).colorScheme.secondary.withOpacity(0.2))),
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: TableCalendar(
        locale: 'mn',
        firstDay: DateTime.now(),
        focusedDay: val.order.day,
        currentDay: DateTime.now(),
        lastDay: DateTime.now().subtract(Duration(days: -30)),
        onCalendarCreated: (pageController) => val.calendarCreated(),
        rowHeight: 40,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarFormat: CalendarFormat.week,
        availableCalendarFormats: {CalendarFormat.week: ''},
        onDaySelected: (selectedDay, focusedDay) => val.setDay(selectedDay),
        selectedDayPredicate: (day) => repo.bformat.format(val.order.day) == repo.bformat.format(day),
        calendarStyle: CalendarStyle(outsideDaysVisible: false),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
          titleTextFormatter: (date, locale) => DateFormat.yMMMM(locale).format(date),
          leftChevronIcon: Icon(Icons.chevron_left, color: Theme.of(context).hintColor.withOpacity(0.6), size: 25),
          rightChevronIcon: Icon(Icons.chevron_right, color: Theme.of(context).hintColor.withOpacity(0.6), size: 25),
          headerPadding: EdgeInsets.symmetric(vertical: 2),
        ),
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, date, events) => Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ),
          todayBuilder: (context, date, events) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle().copyWith(fontSize: 16.0, color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
