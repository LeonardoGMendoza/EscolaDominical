import 'package:cloud_firestore/cloud_firestore.dart'; // Import necessário para Timestamp

class Training {
  final String title;
  final String description;
  final DateTime date;
  final String theme;
  final String organization;
  final List<String> attendees;
  final bool completed;

  Training({
    required this.title,
    required this.description,
    required this.date,
    required this.theme,
    required this.organization,
    required this.attendees,
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'theme': theme,
      'organization': organization,
      'attendees': attendees,
      'completed': completed,
    };
  }

  factory Training.fromMap(Map<String, dynamic> map) {
    // Verificação segura para o campo date
    DateTime date;
    if (map['date'] is Timestamp) {
      date = (map['date'] as Timestamp).toDate();
    } else if (map['date'] is DateTime) {
      date = map['date'] as DateTime;
    } else {
      date = DateTime.now(); // Valor padrão se não for possível converter
    }

    return Training(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: date,
      theme: map['theme'] ?? '',
      organization: map['organization'] ?? '',
      attendees: List<String>.from(map['attendees'] ?? []),
      completed: map['completed'] ?? false,
    );
  }
}