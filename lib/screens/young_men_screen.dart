import 'package:flutter/material.dart';
import 'package:escoladominical/models/user_model.dart';

class YoungMenScreen extends StatelessWidget {
  final UserModel user;

  const YoungMenScreen({Key? key, required this.user}) : super(key: key);

  bool get isYoungMenLeader =>
      ['Presidente dos Rapazes', 'Conselheiro dos Rapazes'].contains(user.calling);
  bool get isYoungMenTeacher => user.calling == 'Instrutor dos Rapazes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organização dos Rapazes'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserHeader(),
            const SizedBox(height: 20),
            if (isYoungMenLeader) _buildTrainingSection(),
            if (isYoungMenTeacher || isYoungMenLeader) _buildQuorumsSection(),
            _buildResourcesSection(),
            if (isYoungMenLeader) _buildAdminSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.male, size: 40, color: Colors.blue),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(user.calling, style: TextStyle(color: Colors.grey[600])),
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
        const Text('Próximos Treinamentos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildTrainingItem('Curso de Liderança dos Rapazes', DateTime.now().add(const Duration(days: 10))),
                const Divider(),
                _buildTrainingItem('Conselho de Juventude', DateTime.now().add(const Duration(days: 28))),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: () {}, child: const Text('Agendar Novo Treinamento')),
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

  Widget _buildQuorumsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('Quóruns dos Rapazes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildClassChip('Diáconos (12-13 anos)'),
            _buildClassChip('Mestres (14-15 anos)'),
            _buildClassChip('Sacerdotes (16-17 anos)'),
          ],
        ),
      ],
    );
  }

  Widget _buildClassChip(String name) {
    return Chip(
      label: Text(name),
      avatar: const Icon(Icons.male, size: 18),
      backgroundColor: Colors.blue.withOpacity(0.2),
      onDeleted: isYoungMenLeader ? () {} : null,
    );
  }

  Widget _buildResourcesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('Recursos e Materiais', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildResourceItem('Manual do Líder dos Rapazes'),
        _buildResourceItem('Atividades de Testemunho para Rapazes'),
      ],
    );
  }

  Widget _buildResourceItem(String title) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {},
    );
  }

  Widget _buildAdminSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('Administração', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: () {}, child: const Text('Adicionar Novo Jovem')),
      ],
    );
  }
}
