import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class CalendarScreen extends StatefulWidget {
  final String organization;

  const CalendarScreen({required this.organization, Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final snapshot = await _firestore
        .collection('events')
        .where('organization', isEqualTo: widget.organization)
        .get();

    final eventsMap = <DateTime, List<Event>>{};

    for (var doc in snapshot.docs) {
      final event = Event.fromMap(doc.data(), doc.id);
      final date = DateTime(event.date.year, event.date.month, event.date.day);

      eventsMap[date] ??= [];
      eventsMap[date]!.add(event);
    }

    setState(() => _events = eventsMap);
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendário - ${widget.organization}'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadEvents,
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
            },
            onPageChanged: (focusedDay) => _focusedDay = focusedDay,
            eventLoader: _getEventsForDay,
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: _getEventsForDay(_selectedDay!).length,
              itemBuilder: (context, index) {
                final event = _getEventsForDay(_selectedDay!)[index];
                return Card(
                  child: ListTile(
                    title: Text(event.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.description),
                        Text('Tipo: ${event.type}'),
                        if (event.teacherId != null)
                          FutureBuilder<DocumentSnapshot>(
                            future: _firestore.collection('users').doc(event.teacherId).get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text('Professor: ${snapshot.data!['name']}');
                              }
                              return SizedBox();
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showAddEventDialog(),
      ),
    );
  }

  Future<void> _showAddEventDialog() async {
    // Implementar diálogo para adicionar novo evento
  }
}