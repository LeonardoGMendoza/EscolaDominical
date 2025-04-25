import 'package:flutter/material.dart';
import 'package:escoladominical/models/user_model.dart';
import 'package:escoladominical/screens/primaryorganizationc_sreen.dart';
import 'package:escoladominical/screens/young_men_screen.dart';
import 'package:escoladominical/screens/youngwomen_organization_screen.dart';
import 'package:escoladominical/screens/reliefsociety_organization_screen.dart';
import 'package:escoladominical/screens/eldersquorum_organization_screen.dart';
import 'package:escoladominical/screens/calendar_screen.dart';
import 'package:escoladominical/screens/login_screen.dart';
import 'package:escoladominical/screens/add_event_screen.dart'; // ✅ Import da AddEventScreen

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
            icon: const Icon(Icons.add),
            tooltip: 'Novo Evento',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEventScreen(organization: user.organization),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: 'Calendário',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalendarScreen(organization: user.organization),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Sair',
            onPressed: () {
              _showLogoutDialog(context);
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
                        Text('Calendário será exibido aqui', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
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
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 5),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }

  Widget _buildOrganizationChip(BuildContext context, String org, IconData icon) {
    Widget getScreenForOrganization() {
      switch (org) {
        case 'Primária':
          return PrimaryOrganizationScreen(user: user);
        case 'Rapazes':
          return YoungMenScreen(user: user);
        case 'Moças':
          return YoungWomenOrganizationScreen(user: user);
        case 'Sociedade de Socorro':
          return ReliefSocietyScreen(user: user);
        case 'Quórum de Élderes':
          return EldersQuorumOrganizationScreen(user: user);
        default:
          return Container();
      }
    }

    Color getColorForOrganization() {
      switch (org) {
        case 'Primária':
          return Colors.blue;
        case 'Rapazes':
          return Colors.blue;
        case 'Moças':
          return Colors.pink;
        case 'Sociedade de Socorro':
          return Colors.red;
        case 'Quórum de Élderes':
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => getScreenForOrganization()),
        );
      },
      child: Chip(
        label: Text(org),
        avatar: Icon(icon, size: 18),
        backgroundColor: getColorForOrganization().withOpacity(0.1),
        side: BorderSide(color: getColorForOrganization().withOpacity(0.3)),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sair do aplicativo'),
          content: const Text('Você tem certeza que deseja sair?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }
}
