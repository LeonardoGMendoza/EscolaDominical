import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'calendar_screen.dart'; // import da sua tela de calendário

class DashboardScreen extends StatelessWidget {
  final UserModel user;

  DashboardScreen({required this.user});

  bool get isPresidency {
    final lowerCalling = user.calling.toLowerCase();
    return lowerCalling == 'presidente'
        || lowerCalling == '1º conselheiro'
        || lowerCalling == 'primeiro conselheiro'
        || lowerCalling == '2º conselheiro'
        || lowerCalling == 'segundo conselheiro';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bem-vindo, ${user.name}'),
            Text('Chamado: ${user.calling}'),
            Text('Organização: ${user.organization}'),
            SizedBox(height: 20),
            if (isPresidency)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalendarScreen(organization: user.organization),
                    ),
                  );
                },
                child: Text('Gerenciar Calendário'),
              )
            else
              Text('Você não tem permissão para gerenciar o calendário.'),
          ],
        ),
      ),
    );
  }
}
