import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import './datos.dart';
import './login_screen.dart'; // Importa la pantalla de inicio de sesión

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<StatefulWidget> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _showLogoutConfirmationDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Color de fondo azul
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Borde circular
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            ),
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.white), // Texto blanco
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller
          .pauseCamera(); // Pausa la cámara para evitar múltiples escaneos
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DatosScreen(qrData: scanData.code!),
        ),
      ).then((_) {
        controller
            .resumeCamera(); // Reanuda la cámara al volver a esta pantalla
      });
    });
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Cerrar Sesión?'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Pausar la cámara antes de cerrar sesión
                controller?.pauseCamera();
                // Volver a la pantalla de inicio de sesión
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  }),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Color de fondo azul
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Borde circular
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
