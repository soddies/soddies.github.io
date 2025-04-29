import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://sbwtujnhyswwnphyibjq.supabase.co', 
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNid3R1am5oeXN3d25waHlpYmpxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU2NDk3NTAsImV4cCI6MjA2MTIyNTc1MH0.6-tXcsL8Lr4buByhg8JGhFbwEAwjZsvljayICaJxtsk'
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Поле для регистрации',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signUp() async {
    final response = await Supabase.instance.client.auth.signUp(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (response.error != null) {
      print('Error signing up: ${response.error!.message}');
    } else {
      print('User signed up: ${response.user}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

extension on AuthResponse {
  get error => null;
}
