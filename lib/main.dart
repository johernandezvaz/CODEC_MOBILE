import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart'; // Importa la pantalla de apertura

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qndgdxhhlzxeokoqiubs.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFuZGdkeGhobHp4ZW9rb3FpdWJzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU3NDE3NTEsImV4cCI6MjAzMTMxNzc1MX0.GTfhPLaHhE6lNCQ5XjK4oCMxItAzX3qbmy41HuzFigg',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lector QR CODEC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily:
            'Clashdisplay', // Asegúrate de que la fuente esté disponible en todo el app
      ),
      home: SplashScreen(), // Aquí es donde llamas a la pantalla de apertura
    );
  }
}
