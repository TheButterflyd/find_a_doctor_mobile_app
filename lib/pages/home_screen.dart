import 'package:doctor_aplicattion/components/search.dart';
import 'package:doctor_aplicattion/pages/founddoctors_screen.dart';
import 'package:doctor_aplicattion/structures/doctor_struct.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:doctor_aplicattion/pages/account_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _initialPosition = CameraPosition(
    target: LatLng(44.43244876983076, 26.087730656501407),
    zoom: 12,
  );

  bool showButtons = true;
  int _selectedIndex = 0;
  final TextEditingController _simptomecontroller = TextEditingController();
  String specialty = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeScreenWithMap(), // Acasă
          const Center(child: Text('Programari')), // Programări
          AccountScreen(), // Cont
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_filled, color: Colors.black),
            label: 'Acasa',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_rounded, color: Colors.black),
            label: 'Programari',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_rounded, color: Colors.black),
            label: 'Cont',
          ),
        ],
      ),
    );
  }

  String removeDiacritics(String input) {
    const diacritics = {
      'ă': 'a',
      'â': 'a',
      'î': 'i',
      'ș': 's',
      'ş': 's',
      'ț': 't',
      'ţ': 't',
      'Ă': 'A',
      'Â': 'A',
      'Î': 'I',
      'Ș': 'S',
      'Ş': 'S',
      'Ț': 'T',
      'Ţ': 'T',
    };

    return input.split('').map((char) => diacritics[char] ?? char).join();
  }

  Future<List> _filtreazaDoctori() async {
    if (_simptomecontroller.text.isEmpty) return [];

    specialty = _simptomecontroller.text;

    final snapshot =
        await FirebaseFirestore.instance.collection('doctori').get();

    final ziuaCurenta = removeDiacritics(
      DateFormat('EEEE', 'ro_RO').format(DateTime.now()).toLowerCase(),
    );

    final doctoriDisponibili =
        snapshot.docs.where((doc) {
          final docData = doc.data();
          final docspecialty = (docData['specialty'] ?? '')
              .toString()
              .toLowerCase()
              .replaceAll(' ', '');
          final cautare = specialty.toLowerCase().replaceAll(' ', '');
          final orar = docData['orar']?[ziuaCurenta];
          return docspecialty == cautare && orar != null;
        }).toList();

    return doctoriDisponibili;
  }

  Widget _buildHomeScreenWithMap() {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _initialPosition,
          zoomControlsEnabled: false,
        ),
        NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            setState(() {
              showButtons = notification.extent > 0.20;
            });
            return true;
          },
          child: DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.12,
            maxChildSize: 0.4,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 246, 245, 245),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 18),
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        height: 50,
                        child: SearchBar(
                          controller: _simptomecontroller,
                          hintText: 'Ce medic cauți azi?',
                          hintStyle: WidgetStateProperty.all(
                            const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          leading: const Icon(Icons.search, size: 20),
                          textStyle: WidgetStateProperty.all(
                            const TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          backgroundColor: WidgetStateProperty.all(
                            Colors.white,
                          ),
                          onSubmitted: (value) async {
                            if (_simptomecontroller.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Introdu specialitatea dorită'),
                                ),
                              );
                              return;
                            }
                            final searchService = SearchDoctorService();
                            final doctorList = await searchService
                                .findAllDoctorsBySpecialty(
                                  _simptomecontroller.text,
                                );
                            if (doctorList.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Nu a fost găsit niciun doctor cu această specialitate.',
                                  ),
                                ),
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => FoundDoctorsScreen(
                                      doctors:
                                          doctorList
                                              .map((e) => Doctor.fromMap(e))
                                              .toList(),
                                      specialty: _simptomecontroller.text,
                                      ora:
                                          TimeOfDay.now(), // trimite ora curentă ca placeholder
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child:
                          showButtons
                              ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildActionButton(
                                      icon: Icons.local_hospital,
                                      label: "Clinici",
                                      onTap: () {},
                                    ),
                                    _buildActionButton(
                                      icon: Icons.medication,
                                      label: "Doctori",
                                      onTap: () {
                                        //
                                      },
                                    ),
                                  ],
                                ),
                              )
                              : const SizedBox.shrink(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              shape: BoxShape.rectangle,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Icon(icon, size: 30, color: Colors.teal),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
