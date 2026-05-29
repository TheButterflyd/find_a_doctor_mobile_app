import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_aplicattion/structures/clinica_struct.dart';
import 'package:flutter/material.dart';

class ClinicaScreen extends StatelessWidget {
  final Clinica clinica;

  const ClinicaScreen({super.key, required this.clinica});

  Future<List<Clinica>> fetchClinics() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('clinics').get();
    return snapshot.docs
        .map((doc) => Clinica.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(clinica.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(clinica.imageUrl),
          const SizedBox(height: 10),
          Text(clinica.city),
        ],
      ),
    );
  }
}
