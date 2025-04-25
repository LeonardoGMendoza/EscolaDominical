import 'package:flutter/material.dart';
import 'package:escoladominical/models/user_model.dart'; // <- ESSA LINHA É ESSENCIAL



class EldersQuorumOrganizationScreen extends StatelessWidget {
  final UserModel user;
  const EldersQuorumOrganizationScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quórum de Élderes'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Bem-vindo ao Quórum de Élderes!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildCard('Visitas de Ministração', Icons.home, Colors.teal),
                _buildCard('Ensino do Evangelho', Icons.school, Colors.blue),
                _buildCard('Administração', Icons.admin_panel_settings, Colors.brown),
                _buildCard('Atividades do Quórum', Icons.event, Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, Color color) {
    return Card(
      color: color.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
