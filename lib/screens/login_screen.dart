import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoladominical/screens/register_page.dart';
import 'package:escoladominical/screens/home_screen.dart';
import 'package:escoladominical/models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controladores separados para cada animação
  late final AnimationController _logoController; // Para logo.png (rápido)
  late final AnimationController _flutterController; // Para flutter_logo.png (lento)

  // Animação do logo principal (aparece instantaneamente)
  late Animation<double> _logoAnimation;

  // Animações do flutter logo (durante carregamento)
  late Animation<double> _flutterScaleAnimation;
  late Animation<double> _flutterRotateAnimation;
  late Animation<double> _flutterOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // Configuração para logo.png (aparece imediatamente)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Muito rápido
    );

    _logoAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeIn,
      ),
    );

    // Inicia imediatamente a animação do logo principal
    _logoController.forward();

    // Configuração para flutter_logo.png (animação durante carregamento)
    _flutterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // 2 segundos por ciclo
    );

    _flutterScaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _flutterController,
        curve: Curves.easeInOut,
      ),
    );

    _flutterRotateAnimation = Tween<double>(begin: -0.2, end: 0.2).animate(
      CurvedAnimation(
        parent: _flutterController,
        curve: Curves.easeInOut,
      ),
    );

    _flutterOpacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _flutterController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _flutterController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _flutterController.repeat(reverse: true); // Animação contínua
    });

    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      final user = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
    } on FirebaseAuthException catch (e) {
      String msg = 'Erro ao fazer login';
      if (e.code == 'user-not-found') msg = 'Usuário não encontrado';
      if (e.code == 'wrong-password') msg = 'Senha incorreta';
      if (e.code == 'invalid-email') msg = 'E-mail inválido';

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _flutterController.stop();
        });
      }
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite seu e-mail para recuperar a senha')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail de recuperação enviado!')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Tela principal (sempre visível)
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Logo principal (aparece instantaneamente)
                  FadeTransition(
                    opacity: _logoAnimation,
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 100,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Formulário (visível quando não está carregando)
                  if (!_isLoading) ...[
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email, color: Colors.white70),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white10,
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (v) => v!.isEmpty ? 'Informe o e-mail' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: Icon(Icons.lock, color: Colors.white70),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white10,
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (v) => v!.isEmpty ? 'Informe a senha' : null,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _resetPassword,
                        child: const Text(
                          'Esqueci minha senha',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterPage()),
                        );
                      },
                      child: const Text(
                        'Criar nova conta',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Overlay de carregamento (aparece apenas durante o login)
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.85),
              child: Center(
                child: AnimatedBuilder(
                  animation: _flutterController,
                  builder: (context, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.rotate(
                          angle: _flutterRotateAnimation.value,
                          child: Transform.scale(
                            scale: _flutterScaleAnimation.value,
                            child: Opacity(
                              opacity: _flutterOpacityAnimation.value,
                              child: Image.asset(
                                'assets/images/flutter_logo.png',
                                height: 120,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Carregando...',
                          style: TextStyle(
                            color: Colors.deepPurpleAccent.withOpacity(_flutterOpacityAnimation.value),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}