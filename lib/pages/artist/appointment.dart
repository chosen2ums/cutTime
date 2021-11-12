import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salon/helper/loading.dart';
import 'package:salon/provider/artist_state_provider.dart';
import 'package:salon/repository.dart';
import 'package:table_calendar/table_calendar.dart';

class Appointment extends StatefulWidget {
  Appointment({Key key}) : super(key: key);

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  Widget build(BuildContext context) {
    ArtistStateProvider val = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          child: Container(
            child: TableCalendar(
              locale: 'mn',
              firstDay: val.focused.subtract(Duration(days: 14)),
              lastDay: val.focused.subtract(Duration(days: -30)),
              rowHeight: 40,
              focusedDay: val.selected,
              currentDay: val.selected,
              calendarFormat: CalendarFormat.week,
              startingDayOfWeek: StartingDayOfWeek.monday,
              availableCalendarFormats: {CalendarFormat.week: ''},
              onDaySelected: val.selectDay,
              selectedDayPredicate: (day) =>
                  repo.bformat.format(val.selected) == repo.bformat.format(day),
              calendarStyle: CalendarStyle(outsideDaysVisible: false),
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
                titleTextFormatter: (date, locale) =>
                    DateFormat.yMMMM(locale).format(date),
                leftChevronIcon: Icon(Icons.chevron_left,
                    color: Theme.of(context).hintColor.withOpacity(0.6),
                    size: 25),
                rightChevronIcon: Icon(Icons.chevron_right,
                    color: Theme.of(context).hintColor.withOpacity(0.6),
                    size: 25),
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
                      style: TextStyle().copyWith(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                todayBuilder: (context, date, events) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.3),
                    ),
                    child: Center(
                      child: Text(
                        '${date.day} xxa',
                        style: TextStyle().copyWith(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          preferredSize: Size.fromHeight(55),
        ),
      ),
      body: Stack(
        children: [
          DayView(
            userZoomable: false,
            controller: val.controller,
            hoursColumnStyle: HoursColumnStyle(
              interval: Duration(minutes: 30),
              width: 40,
              textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                border: Border(
                  right: BorderSide(
                      width: 0.3, color: Theme.of(context).hintColor),
                ),
              ),
            ),
            minimumTime: val.start,
            maximumTime: val.end,
            date: val.selected,
            events: val.events,
            style: DayViewStyle(
              headerSize: 0,
              hourRowHeight: 150,
              currentTimeCircleColor: Colors.red,
              backgroundRulesColor:
                  Theme.of(context).hintColor.withOpacity(0.6).withOpacity(0.1),
              currentTimeRuleColor: Colors.red,
              currentTimeCirclePosition: CurrentTimeCirclePosition.left,
              currentTimeCircleRadius: 5,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          val.loading ? Loading(20) : Container()
        ],
      ),
    );
  }
}
