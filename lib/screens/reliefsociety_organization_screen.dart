import 'package:flutter/material.dart';
import 'package:escoladominical/models/user_model.dart';

class ReliefSocietyScreen extends StatelessWidget {
  final UserModel user;

  const ReliefSocietyScreen({Key? key, required this.user}) : super(key: key);

  bool get isReliefSocietyLeader => ['Presidente da Sociedade de Socorro', 'Conselheira da Sociedade de Socorro'].contains(user.calling);
  bool get isReliefSocietyTeacher => user.calling == 'Instrutora da Sociedade de Socorro';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sociedade de Socorro'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserHeader(),
            const SizedBox(height: 20),
            if (isReliefSocietyLeader) _buildTrainingSection(),
            if (isReliefSocietyTeacher || isReliefSocietyLeader) _buildMinistrationSection(),
            _buildResourcesSection(),
            if (isReliefSocietyLeader) _buildAdminSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.female, size: 40, color: Colors.red),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.calling,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Próximos Treinamentos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTrainingItem(
                  'Treinamento: Ministração',
                  DateTime.now().add(const Duration(days: 14)),
                ),
                const Divider(),
                _buildTrainingItem(
                  'Conselho da Presidência',
                  DateTime.now().add(const Duration(days: 30)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Agendar Novo Treinamento'),
        ),
      ],
    );
  }

  Widget _buildTrainingItem(String title, DateTime date) {
    return ListTile(
      leading: const Icon(Icons.event, color: Colors.red),
      title: Text(title),
      subtitle: Text('${date.day}/${date.month}/${date.year} às 19:30'),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {},
    );
  }

  Widget _buildMinistrationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Grupos de Ministração',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildGroupChip('Grupo 1'),
            _buildGroupChip('Grupo 2'),
            _buildGroupChip('Grupo 3'),
            _buildGroupChip('Grupo 4'),
          ],
        ),
      ],
    );
  }

  Widget _buildGroupChip(String groupName) {
    return Chip(
      label: Text(groupName),
      avatar: const Icon(Icons.group, size: 18),
      backgroundColor: Colors.red.withOpacity(0.2),
      onDeleted: isReliefSocietyLeader ? () {} : null,
    );
  }

  Widget _buildResourcesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Recursos para Ensino',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildResourceCard('Vem, e Segue-Me', Icons.book),
            _buildResourceCard('Ministração', Icons.people),
            _buildResourceCard('Aulas Dominicais', Icons.school),
            _buildResourceCard('Manuais', Icons.library_books),
          ],
        ),
      ],
    );
  }

  Widget _buildResourceCard(String title, IconData icon) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.red),
              const SizedBox(height: 10),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Administração',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildAdminItem('Relatório de Ministração', Icons.assignment),
                const Divider(),
                _buildAdminItem('Designar Irmãs', Icons.person_add),
                const Divider(),
                _buildAdminItem('Agendar Reuniões', Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdminItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {},
    );
  }
}