import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:doctor_aplicattion/structures/doctor_struct.dart';
import 'package:doctor_aplicattion/pages/home_screen.dart';

class FoundDoctorsScreen extends StatefulWidget {
  final List<Doctor> doctors;
  final String specialty;
  final TimeOfDay ora; // <-- ora transmisă

  const FoundDoctorsScreen({
    super.key,
    required this.doctors,
    required this.specialty,
    required this.ora,
  });

  @override
  State<FoundDoctorsScreen> createState() => _FoundDoctorsScreenState();
}

class _FoundDoctorsScreenState extends State<FoundDoctorsScreen> {
  static const _initialPosition = CameraPosition(
    target: LatLng(44.43244876983076, 26.087730656501407),
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctori găsiți pentru: ${widget.specialty}'),
      ),
      body: widget.doctors.isEmpty
          ? const Center(
              child: Text(
                'Nu s-a găsit niciun doctor cu această specialty sau nu ai locația activată.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            )
          : Stack(
              children: [
                GoogleMap(initialCameraPosition: _initialPosition),
                DraggableScrollableSheet(
                  builder: (context, scrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 246, 245, 245),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: widget.doctors.length,
                        itemBuilder: (context, index) {
                          final doc = widget.doctors[index];
                          return ListTile(
                            title: Text(doc.name),
                            subtitle: Text(
                              'Ora disponibilă: ${widget.ora.format(context)}',
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
