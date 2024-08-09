import 'package:flutter/material.dart';
import 'package:qr_code_reader/screens/participantes_screen.dart';
import 'package:qr_code_reader/screens/qr_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ajusta estos valores según el tamaño más grande entre los botones.
    final double buttonWidth = MediaQuery.of(context).size.width * 0.7;
    final double buttonHeight = 60;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7), // Fondo ligeramente gris
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F5F7), // Mismo color para la AppBar
        elevation: 0,
        title: const Text(
          'Inicio',
          style: TextStyle(color: Colors.black), // Color del texto en AppBar
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'CODEC',
              style: TextStyle(
                fontSize: 36,
                fontFamily: 'Clashdisplay',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 50), // Espacio entre el texto y los botones
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ParticipantsScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero, // Remueve el padding por defecto
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10, // Sombra con elevación de 10
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF354E57),
                      Color(0xFF405E69),
                      Color(0xFF73A9BD),
                    ],
                    stops: [0.10, 0.63, 1.0], // Porcentajes del degradado
                    begin: Alignment.topCenter, // Punto inicial (arriba)
                    end: Alignment.bottomCenter, // Punto final (abajo)
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: buttonWidth,
                  height: buttonHeight,
                  alignment: Alignment.center,
                  child: const Text(
                    'Usuarios',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Espacio entre los dos botones
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero, // Remueve el padding por defecto
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10, // Sombra con elevación de 10
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF354E57),
                      Color(0xFF405E69),
                      Color(0xFF73A9BD),
                    ],
                    stops: [0.1, 0.63, 1], // Porcentajes del degradado
                    begin: Alignment.topCenter, // Punto inicial (arriba)
                    end: Alignment.bottomCenter, // Punto final (abajo)
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: buttonWidth,
                  height: buttonHeight,
                  alignment: Alignment.center,
                  child: const Text(
                    'Escanear código QR',
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
