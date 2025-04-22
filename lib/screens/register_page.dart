import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoladominical/models/user_model.dart';
import 'package:escoladominical/screens/home_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. Criar usuário no Firebase Auth
      UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );

      // 2. Atualizar nome do usuário
      await cred.user!.updateDisplayName(_nomeController.text.trim());
      await cred.user!.reload();

      // 3. Criar registro no Firestore
      final newUser = UserModel(
        uid: cred.user!.uid,
        name: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        calling: 'Membro', // Valor padrão
        organization: 'Geral', // Valor padrão
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set(newUser.toMap());

      // 4. Feedback e navegação
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Conta criada com sucesso!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: newUser)),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Erro ao criar conta.";
      if (e.code == "email-already-in-use") {
        errorMessage = "Este e-mail já está em uso.";
      } else if (e.code == "weak-password") {
        errorMessage = "A senha deve ter pelo menos 6 caracteres.";
      } else if (e.code == "invalid-email") {
        errorMessage = "Formato de e-mail inválido.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: ${e.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Conta"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: "Nome Completo",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value != null && value.trim().isNotEmpty
                    ? null
                    : "Digite seu nome",
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "E-mail",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value != null && value.contains("@")
                    ? null
                    : "Digite um e-mail válido",
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _senhaController,
                decoration: const InputDecoration(
                  labelText: "Senha",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) => value != null && value.length >= 6
                    ? null
                    : "Mínimo 6 caracteres",
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _registrar,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "CRIAR CONTA",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}