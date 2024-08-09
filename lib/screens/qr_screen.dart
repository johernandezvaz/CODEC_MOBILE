import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import './datos.dart';
import './login_screen.dart';

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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            controller?.pauseCamera();
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white, // Fondo blanco
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20), // Espacio ajustado para el AppBar
          const Text(
            'CODEC',
            style: TextStyle(
              fontFamily: 'Clashdisplay',
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(), // Empuja el contenido siguiente hacia el centro
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        15), // Esquina redondeada del contenedor QR
                    child: Stack(
                      children: [
                        QRView(
                          key: qrKey,
                          onQRViewCreated: _onQRViewCreated,
                          overlay: QrScannerOverlayShape(
                            borderColor: Colors.white,
                            borderRadius: 10,
                            borderLength: 30,
                            borderWidth: 10,
                            cutOutSize: 280,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Escanea el código QR',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Clashdisplay',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(), // Empuja el contenido anterior hacia el centro
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
                controller
                    ?.pauseCamera(); // Pausar la cámara antes de cerrar sesión
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const LoginScreen();
                  }),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.white),
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
