import 'package:flutter/material.dart';
import 'package:qr_code_reader/screens/qr_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatosScreen extends StatefulWidget {
  final String qrData;

  const DatosScreen({super.key, required this.qrData});

  @override
  _DatosScreenState createState() => _DatosScreenState();
}

class _DatosScreenState extends State<DatosScreen> {
  bool verificado = false;
  String errorMessage = '';
  bool? ingreso;

  @override
  void initState() {
    super.initState();
    verificarCorreo();
  }

  Future<void> verificarCorreo() async {
    List<String> dataItems = widget.qrData.split(',');

    String? correo;
    String? dia;
    for (var item in dataItems) {
      if (item.contains('@')) {
        RegExp emailRegex = RegExp(r'[\w\.-]+@[\w\.-]+\.\w+');
        final match = emailRegex.firstMatch(item);
        if (match != null) {
          correo = match.group(0);
        }
      }
      if (item.toLowerCase().contains('día')) {
        dia = item.split(':').last.trim().toLowerCase();
      }
    }

    if (correo != null && dia != null) {
      try {
        final response = await Supabase.instance.client
            .from('participantes')
            .select('email')
            .eq('email', correo)
            .single();

        final responseId = await Supabase.instance.client
            .from('participantes')
            .select('id')
            .eq('email', correo)
            .single();

        String tableName;
        if (dia == 'uno') {
          tableName = 'ingreso_participantes_dia_uno';
        } else if (dia == 'dos') {
          tableName = 'ingreso_participantes_dia_dos';
        } else {
          setState(() {
            errorMessage = 'Día no válido en el QR.';
            verificado = true;
          });
          return;
        }

        final responseTwo = await Supabase.instance.client
            .from(tableName)
            .select('ingreso')
            .eq('id_participante', responseId["id"])
            .single();

        final data = response["email"];
        final estado = responseTwo['ingreso'];

        setState(() {
          ingreso = estado;
          verificado = true;
        });

        if ((correo == data) && (estado == false)) {
          setState(() {
            verificado = true;
          });
        } else if ((correo == data) && (estado == true)) {
          setState(() {
            verificado = true;
          });
        } else {
          setState(() {
            errorMessage = 'No existe este usuario en la base de datos';
            verificado = true;
          });
        }
      } catch (error) {
        setState(() {
          verificado = true;
        });
      }
    } else {
      setState(() {
        errorMessage = 'No se encontró un correo válido o un día en el QR.';
        verificado = true;
      });
    }
  }

  Future<void> registrarIngreso() async {
    List<String> dataItems = widget.qrData.split(',');

    String? correo;
    String? dia;
    for (var item in dataItems) {
      if (item.contains('@')) {
        RegExp emailRegex = RegExp(r'[\w\.-]+@[\w\.-]+\.\w+');
        final match = emailRegex.firstMatch(item);
        if (match != null) {
          correo = match.group(0);
        }
      }
      if (item.toLowerCase().contains('día')) {
        dia = item.split(':').last.trim().toLowerCase();
      }
    }

    if (correo != null && dia != null) {
      try {
        final response = await Supabase.instance.client
            .from('participantes')
            .select('email')
            .eq('email', correo)
            .single();

        final email = response['email'];

        final responseId = await Supabase.instance.client
            .from('participantes')
            .select('id')
            .eq('email', email)
            .single();

        final idParticipante = responseId['id'];

        String tableName;
        if (dia == 'uno') {
          tableName = 'ingreso_participantes_dia_uno';
        } else if (dia == 'dos') {
          tableName = 'ingreso_participantes_dia_dos';
        } else {
          setState(() {
            errorMessage = 'Día no válido en el QR.';
            verificado = true;
          });
          return;
        }

        await Supabase.instance.client.from(tableName).update(
            {'ingreso': true}).match({'id_participante': idParticipante});

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const QRScreen()),
        );
      } catch (error) {
        setState(() {
          errorMessage = 'Error al registrar el ingreso: $error';
        });
      }
    } else {
      setState(() {
        errorMessage = 'No se encontró un correo válido o un día en el QR.';
        verificado = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> dataItems = widget.qrData.split(',');
    Color backgroundColor;
    String? message;
    Color textColor = Colors.white;

    if (ingreso == null) {
      backgroundColor = const Color(0xFF441E1E);
      message = 'Usuario no está registrado en la base de datos';
      textColor = const Color(0xFFC40C0C);
    } else if (!ingreso!) {
      backgroundColor = const Color(0xFF1E3A44); // Azul oscuro
      message = null;
      textColor = Colors.white;
    } else {
      backgroundColor = const Color(0xE01A4D2E); // Verde oscuro
      message = 'Usuario ya ha ingresado al evento';
      textColor = const Color(0xE01A4D2E);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Datos del QR'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'CODEC',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.5), // Sombra similar al botón
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (var i = 0; i < dataItems.length; i++) ...[
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: dataItems[i].split(':').first.trim() +
                                      ': ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Clashdisplay',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: dataItems[i].split(':').last.trim(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Clashdisplay',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (i < dataItems.length - 1)
                            const SizedBox(
                                height:
                                    25), // Añade más espacio entre elementos
                        ],
                      ],
                    ),
                  ),
                  if (message != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (ingreso != null && !ingreso!)
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Container(
                        width: null, // Elimina el ancho por defecto
                        constraints: BoxConstraints(
                          maxWidth:
                              200, // Ajusta el ancho máximo según tus necesidades
                        ),
                        child: ElevatedButton(
                          onPressed: registrarIngreso,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets
                                .zero, // Remueve el padding por defecto
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation:
                                10, // Añade elevación para la sombra (similar al 3D)
                            shadowColor: Colors.black
                                .withOpacity(0.5), // Color de la sombra
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF354E57),
                                  Color(0xFF405E69),
                                  Color(0xFF73A9BD),
                                ],
                                stops: [
                                  0.10,
                                  0.83,
                                  1.0
                                ], // Porcentajes del degradado
                                begin: Alignment
                                    .topCenter, // Punto inicial (arriba)
                                end: Alignment
                                    .bottomCenter, // Punto final (abajo)
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              alignment: Alignment.center,
                              child: const Text(
                                'Registrar Ingreso',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
