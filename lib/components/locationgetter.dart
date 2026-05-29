import 'package:geolocator/geolocator.dart';

class LocationGetter {
  Position? _currentPosition;

  Future<void> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica daca serviciul de locatie este activat
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Serviciul de locatie nu este activat
      return;
    }

    // Verifica permisiunile
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permisiunea a fost refuzata
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permisiunea a fost refuzata permanent
      return;
    }

    // Preia locatia curenta si o salveaza in variabila
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Position? get currentPosition => _currentPosition;
}