import 'package:flutter/material.dart';
import '../models/user_model.dart';

class DashboardScreen extends StatelessWidget {
  final UserModel user;

  DashboardScreen({required this.user});

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
          ],
        ),
      ),
    );
  }
}