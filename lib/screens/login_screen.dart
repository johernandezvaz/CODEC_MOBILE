import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qr_code_reader/screens/home_screen.dart'; // Importa la nueva pantalla que creaste

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showUsernameError = false;
  bool _showPasswordError = false;

  Future<void> _login(BuildContext context) async {
    final email = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Validar si los campos están vacíos
    setState(() {
      _showUsernameError = email.isEmpty;
      _showPasswordError = password.isEmpty;
    });

    if (_showUsernameError || _showPasswordError) {
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('administradores')
          .select('contrasena')
          .eq('usuario', email)
          .single();

      print('Response from Supabase: $response');

      final dbPassword = response['contrasena'];

      if (dbPassword == password) {
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()), // Cambiado a HomeScreen
        );
      } else {
        _showError(context, 'Usuario o contraseña incorrectos');
      }
    } catch (e) {
      _showError(context, 'Error al iniciar sesión');
      print('Error during login: ${e.toString()}');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7), // Fondo ligeramente gris
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'CODEC',
              style: TextStyle(
                fontFamily: 'Clashdisplay',
                fontSize: 36,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 70),
            const Text(
              'Iniciar Sesión',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorText: _showUsernameError
                    ? 'El usuario no puede estar vacío'
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorText: _showPasswordError
                    ? 'La contraseña no puede estar vacía'
                    : null,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _login(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero, // Remueve el padding por defecto
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 10, // Añade elevación para la sombra (similar al 3D)
                shadowColor:
                    Colors.black.withOpacity(0.5), // Color de la sombra
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF354E57),
                      Color(0xFF405E69),
                      Color(0xFF73A9BD),
                    ],
                    stops: [0.10, 0.83, 1.0], // Porcentajes del degradado
                    begin: Alignment.topCenter, // Punto inicial (arriba)
                    end: Alignment.bottomCenter, // Punto final (abajo)
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  child: const Text(
                    'Continuar',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Clashdisplay',
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
