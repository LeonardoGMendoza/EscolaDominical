import 'package:flutter/material.dart';
import 'package:escoladominical/models/user_model.dart';

class YoungWomenOrganizationScreen extends StatelessWidget {
  final UserModel user;
  const YoungWomenOrganizationScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organização das Moças'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Bem-vindo à Organização das Moças!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
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
                _buildCard('Atividades', Icons.event, Colors.pinkAccent),
                _buildCard('Estudo do Evangelho', Icons.book, Colors.deepOrange),
                _buildCard('Liderança', Icons.leaderboard, Colors.deepPurple),
                _buildCard('Projetos de Serviço', Icons.volunteer_activism, Colors.teal),
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
