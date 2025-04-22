import 'package:flutter/material.dart';
import 'package:escoladominical/models/user_model.dart';
import 'package:escoladominical/screens/primaryorganizationc_sreen.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escola Dominical'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.pushNamed(context, '/calendar');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Seção do perfil
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Bem-vindo, ${user.name}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Seção de informações
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildInfoRow(context, Icons.assignment_ind, 'Chamado:', user.calling),
                      const SizedBox(height: 12),
                      _buildInfoRow(context, Icons.group, 'Organização:', user.organization),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Seção do calendário
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Próximos Eventos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_month, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'Calendário será exibido aqui',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Seção de organizações
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Outras Organizações',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildOrganizationChip(context, 'Primária', Icons.child_care),
                  _buildOrganizationChip(context, 'Rapazes', Icons.face),
                  _buildOrganizationChip(context, 'Moças', Icons.face),
                  _buildOrganizationChip(context, 'Sociedade de Socorro', Icons.female),
                  _buildOrganizationChip(context, 'Quórum de Élderes', Icons.people),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildOrganizationChip(BuildContext context, String org, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (org == 'Primária') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrimaryOrganizationScreen(user: user),
            ),
          );
        }
      },
      child: Chip(
        label: Text(org),
        avatar: Icon(icon, size: 18),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        side: BorderSide(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
    );
  }
}