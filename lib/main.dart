import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'models/user_model.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/primaryorganizationc_sreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Erro ao inicializar Firebase: $e'),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<UserModel?> _getUserModel(User firebaseUser) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();
      final data = doc.data();

      if (data == null) return null;

      return UserModel(
        uid: firebaseUser.uid,
        name: data['name'] ?? firebaseUser.displayName ?? 'Usuário',
        email: firebaseUser.email ?? '',
        photoUrl: firebaseUser.photoURL,
        calling: data['calling'] ?? '',
        organization: data['organization'] ?? '',
      );
    } catch (e) {
      debugPrint('Erro ao buscar usuário do Firestore: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escola Dominical',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return FutureBuilder<UserModel?>(
              future: _getUserModel(snapshot.data!),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (userSnapshot.hasData) {
                  return HomeScreen(user: userSnapshot.data!);
                } else {
                  return const Center(child: Text('Erro ao carregar dados do usuário.'));
                }
              },
            );
          }

          return const LoginScreen();
        },
      ),
    );
  }
}