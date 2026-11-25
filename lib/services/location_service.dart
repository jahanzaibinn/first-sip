import 'dart:async';
import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';

/// A plain latitude/longitude pair, kept free of plugin types so it can be
/// stored, compared and unit tested without a device.
class GeoPoint {
  const GeoPoint(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  @override
  bool operator ==(Object other) =>
      other is GeoPoint &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() => 'GeoPoint($latitude, $longitude)';
}

/// Why a location fix could not be produced.
enum LocationFailure {
  servicesOff,
  permissionDenied,
  permissionPermanentlyDenied,
  timeout,
  unavailable,
}

/// Either a fix or a user-readable reason it failed.
class LocationResult {
  const LocationResult.success(GeoPoint this.point) : failure = null;

  const LocationResult.failure(LocationFailure this.failure) : point = null;

  final GeoPoint? point;
  final LocationFailure? failure;

  bool get hasPoint => point != null;

  String get message => switch (failure) {
        LocationFailure.servicesOff =>
          'Turn on your phone\'s location (GPS) to see how far each spot is.',
        LocationFailure.permissionDenied =>
          'Location permission is needed to sort spots by distance.',
        LocationFailure.permissionPermanentlyDenied =>
          'Location is blocked for this app. Enable it in Settings to use '
              'near-me distances.',
        LocationFailure.timeout =>
          'Could not get a GPS fix in time. Move near a window and try again.',
        LocationFailure.unavailable =>
          'Your location is unavailable right now. Please try again.',
        null => 'Location ready.',
      };
}

/// Live device location, used to calculate real distances to each spot.
class LocationService {
  const LocationService();

  /// Asks for permission (if needed) and returns one GPS fix.
  Future<LocationResult> currentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const LocationResult.failure(LocationFailure.servicesOff);
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        return const LocationResult.failure(LocationFailure.permissionDenied);
      }
      if (permission == LocationPermission.deniedForever) {
        return const LocationResult.failure(
          LocationFailure.permissionPermanentlyDenied,
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 12),
        ),
      );

      return LocationResult.success(
        GeoPoint(position.latitude, position.longitude),
      );
    } on TimeoutException {
      return const LocationResult.failure(LocationFailure.timeout);
    } catch (_) {
      return const LocationResult.failure(LocationFailure.unavailable);
    }
  }

  /// Great-circle distance in kilometres between two points.
  static double distanceKm(GeoPoint from, GeoPoint to) {
    const earthRadiusKm = 6371.0;
    final dLat = _radians(to.latitude - from.latitude);
    final dLng = _radians(to.longitude - from.longitude);
    final lat1 = _radians(from.latitude);
    final lat2 = _radians(to.latitude);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    return earthRadiusKm * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  /// `0.8` → `800 m`, `4.2` → `4.2 km`, `23.6` → `24 km`.
  static String formatDistance(double km) {
    if (km < 1) return '${(km * 1000).round()} m';
    if (km < 10) return '${km.toStringAsFixed(1)} km';
    return '${km.round()} km';
  }

  static double _radians(double degrees) => degrees * math.pi / 180;
}
