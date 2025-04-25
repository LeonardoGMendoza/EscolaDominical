import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:escoladominical/models/event_model.dart'; // seu model de evento
import 'add_event_screen.dart'; // tela de adicionar evento

class CalendarScreen extends StatefulWidget {
  final String organization;

  const CalendarScreen({Key? key, required this.organization}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}
//teste
class _CalendarScreenState extends State<CalendarScreen> {
  late List<Event> _events;
  bool _isLoading = true;
  String? _selectedType;
  final List<String> _eventTypes = ['Todos', 'Aula', 'Reunião', 'Treinamento'];

  @override
  void initState() {
    super.initState();
    _events = [];
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      Query query = FirebaseFirestore.instance
          .collection('events')
          .where('organization', isEqualTo: widget.organization);

      if (_selectedType != null && _selectedType != 'Todos') {
        query = query.where('type', isEqualTo: _selectedType);
      }

      final snapshot = await query.get();

      final events = snapshot.docs.map((doc) {
        final data = doc.data();
        if (data is Map<String, dynamic>) {
          return Event.fromMap(data, doc.id);
        } else {
          throw Exception('Dados do Firestore inválidos para o documento: \${doc.id}');
        }
      }).toList();

      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar eventos: \$e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToAddEvent() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEventScreen(organization: widget.organization),
      ),
    );
    _loadEvents(); // Atualiza eventos após adicionar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos da \${widget.organization}'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToAddEvent,
            tooltip: 'Agendar Novo Evento',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedType ?? 'Todos',
              items: _eventTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                  _isLoading = true;
                });
                _loadEvents();
              },
              hint: Text('Filtrar por tipo'),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _events.isEmpty
                ? Center(child: Text('Nenhum evento encontrado.'))
                : ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return Card(
                  child: ListTile(
                    title: Text(event.title),
                    subtitle: Text(event.description),
                    trailing: Text(
                      DateFormat('dd/MM/yyyy').format(event.date),
                    ),
                    onTap: () {
                      print('Evento clicado: \${event.title}');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _showAddEventDialog() async {
    // Implementar diálogo para adicionar novo evento
  }
}
