import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ParticipantsScreen extends StatefulWidget {
  const ParticipantsScreen({super.key});

  @override
  _ParticipantsScreenState createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends State<ParticipantsScreen> {
  List<Map<String, dynamic>> participants = [];
  List<Map<String, dynamic>> filteredParticipants = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchParticipants();
    _searchController.addListener(_filterParticipants);
  }

  Future<void> _fetchParticipants() async {
    try {
      final response = await Supabase.instance.client
          .from('participantes')
          .select('nombre, apellido')
          .order('nombre', ascending: true);

      setState(() {
        participants = List<Map<String, dynamic>>.from(response);
        filteredParticipants = participants;
      });
    } catch (e) {
      print('Error fetching participants: $e');
    }
  }

  void _filterParticipants() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredParticipants = participants.where((participant) {
        final fullName =
            '${participant['nombre']} ${participant['apellido']}'.toLowerCase();
        return fullName.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7), // Fondo de pantalla claro
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F5F7), // Mismo color para la AppBar
        elevation: 0,
        title: const Text(
          'Usuarios',
          style: TextStyle(color: Colors.black), // Color del texto en AppBar
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'CODEC',
              style: TextStyle(
                fontSize: 36,
                fontFamily: 'Clashdisplay',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Usuarios Registrados',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Clashdisplay',
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Buscar',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredParticipants.length,
                itemBuilder: (context, index) {
                  final participant = filteredParticipants[index];
                  return Column(
                    children: [
                      ListTile(
                        leading: const CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.black,
                        ),
                        title: Text(
                          '${participant['nombre']} ${participant['apellido']}',
                          style: const TextStyle(
                            fontFamily: 'Clashdisplay',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const Divider(), // Línea separadora
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
