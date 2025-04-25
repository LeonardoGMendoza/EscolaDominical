class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String type;
  final String organization; // Verifique se isso existe no Firestore
  final String? teacherId;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.organization,
    this.teacherId,
  });

  factory Event.fromMap(Map<String, dynamic> data, String id) {
    return Event(
      id: id,
      title: data['title'],
      description: data['description'],
      date: data['date'].toDate(),
      type: data['type'],
      organization: data['organization'], // Verifique se 'organization' existe no Firestore
      teacherId: data['teacherId'],
    );
  }
}
