import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GetLocation extends GetxController {
  Position? currentPosition;

  Future<void> checkLocationPermission() async {
    final status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      await getCurrentLocation();
      update();
    } else {
      print("Location permission denied");
      // Handle permission denied scenario
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      print("Current Location: $currentPosition");
    } catch (e) {
      print("Error getting location: $e");
    }
  }
}
