import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'locationgetter.dart';

class SearchDoctorService {
  final LocationGetter _locationGetter = LocationGetter();

  /// Returnează toți doctorii cu specializarea dorită, sortați după distanță față de utilizator
  Future<List<Map<String, dynamic>>> findAllDoctorsBySpecialty(String specialty) async {
    await _locationGetter.getUserLocation();
    final Position? userPosition = _locationGetter.currentPosition;
    if (userPosition == null) return [];

    final querySnapshot = await FirebaseFirestore.instance
        .collection('doctors')
        .where('specialty', isEqualTo: specialty)
        .get();

    if (querySnapshot.docs.isEmpty) return [];

    final List<Map<String, dynamic>> doctors = [];
    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final double? lat = data['location']?['lat'];
      final double? lng = data['location']?['lng'];
      if (lat == null || lng == null) continue;
      final double distance = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        lat,
        lng,
      );
      data['id'] = doc.id;
      data['distance'] = distance;
      doctors.add(data);
    }
    // Sortează doctorii după distanță
    doctors.sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));
    return doctors;
  }
}
