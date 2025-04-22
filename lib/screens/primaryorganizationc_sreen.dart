import 'package:flutter/material.dart';
import 'package:escoladominical/models/user_model.dart';

class PrimaryOrganizationScreen extends StatelessWidget {
  final UserModel user;

  const PrimaryOrganizationScreen({Key? key, required this.user}) : super(key: key);

  bool get isPrimaryTeacher => user.calling == 'Professor da Primária';
  bool get isPrimaryLeader => ['Presidente da Primária', 'Conselheiro da Primária'].contains(user.calling);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organização da Primária'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserHeader(),
            const SizedBox(height: 20),
            if (isPrimaryLeader) _buildTrainingSection(),
            if (isPrimaryTeacher || isPrimaryLeader) _buildClassesSection(),
            _buildResourcesSection(),
            if (isPrimaryLeader) _buildAdminSection(),
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
            const Icon(Icons.child_care, size: 40, color: Colors.blue),
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
                  'Treinamento: Ensinar à Maneira do Salvador',
                  DateTime.now().add(const Duration(days: 14)),
                ),
                const Divider(),
                _buildTrainingItem(
                  'Conselho de Professores Trimestral',
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
      leading: const Icon(Icons.event, color: Colors.blue),
      title: Text(title),
      subtitle: Text('${date.day}/${date.month}/${date.year} às 19:30'),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {},
    );
  }

  Widget _buildClassesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Classes da Primária',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildClassChip('Raios de Sol (3-4 anos)'),
            _buildClassChip('Valentes (5-7 anos)'),
            _buildClassChip('Meninos (8-11 anos)'),
            _buildClassChip('Meninas (8-11 anos)'),
          ],
        ),
      ],
    );
  }

  Widget _buildClassChip(String className) {
    return Chip(
      label: Text(className),
      avatar: const Icon(Icons.child_care, size: 18),
      backgroundColor: Colors.blue.withOpacity(0.2),
      onDeleted: isPrimaryLeader ? () {} : null,
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
            _buildResourceCard('Músicas Primária', Icons.music_note),
            _buildResourceCard('Atividades', Icons.games),
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
              Icon(icon, size: 40, color: Colors.blue),
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
                _buildAdminItem('Relatório de Frequência', Icons.assignment),
                const Divider(),
                _buildAdminItem('Chamar Professores', Icons.person_add),
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
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {},
    );
  }
}