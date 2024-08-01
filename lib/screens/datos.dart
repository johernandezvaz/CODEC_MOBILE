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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos del QR'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Datos escaneados:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: dataItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.circle, size: 10),
                    title: Text(dataItems[index].trim(),
                        style: const TextStyle(fontSize: 16)),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            if (!verificado)
              const Center(child: CircularProgressIndicator())
            else
              Column(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (ingreso != null && !ingreso!)
                          Column(
                            children: [
                              const Text(
                                'El usuario está registrado pero no ha ingresado',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 100),
                              ElevatedButton(
                                onPressed: registrarIngreso,
                                child: const Text('Registrar Ingreso'),
                              ),
                            ],
                          ),
                        if (ingreso != null && ingreso!)
                          const Text(
                            'El usuario ya ha ingresado al evento',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        if (ingreso == null)
                          const Text(
                            'No existe este usuario en la base de datos',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        if (errorMessage.isNotEmpty)
                          Text(
                            errorMessage,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
