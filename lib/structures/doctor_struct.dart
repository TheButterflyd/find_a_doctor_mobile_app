import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String name;
  final String specialty;
  final LatLng location;
  final String imageUrl;
  final double ? distance;
  final int? price; 

  Doctor(this.name, this.specialty, this.location, this.imageUrl, {this.distance, this.price});

  factory Doctor.fromMap(Map<String, dynamic> map) {
    final GeoPoint geoPoint = map['location']; 
    return Doctor(
      map['name'] ?? '',
      map['specialty'] ?? '',
      LatLng(geoPoint.latitude, geoPoint.longitude),
      map['imageUrl'] ?? '',
      distance: (map['distance'] is num) ? (map['distance'] as num).toDouble() : null,
      price: (map['price'] is int) ? map['price'] : int.tryParse(map['price']?.toString() ?? ''),
    );
  }
}
