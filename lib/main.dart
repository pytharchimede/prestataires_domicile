import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prestataires à Domicile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthenticationScreen(),
    );
  }
}

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLogin = true;
  String _errorMessage = '';

  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
      _errorMessage =
          ''; // Réinitialiser l'erreur quand on change de formulaire
    });
  }

  Future<void> _submitForm() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage =
            'L\'email et le mot de passe ne peuvent pas être vides.';
      });
      return;
    }

    try {
      if (_isLogin) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur : ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(_isLogin ? 'Se connecter' : 'Créer un compte'),
            ),
            TextButton(
              onPressed: _toggleForm,
              child: Text(_isLogin ? 'Créer un compte' : 'Se connecter'),
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: Center(
        child: Text('Bienvenue !'),
      ),
    );
  }
}
