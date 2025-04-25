import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'models/user_model.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedLocale = await LocaleProvider.getSavedLocale();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(
      ChangeNotifierProvider(
        create: (context) => LocaleProvider()..setLocale(savedLocale),
        child: const MyApp(),
      ),
    );
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
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt'),
        Locale('en'),
        Locale('es'),
      ],
      locale: Provider.of<LocaleProvider>(context).locale,
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
                  return const Center(
                      child: Text('Erro ao carregar dados do usuário.'));
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