import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  String location;

  LocationProvider() {
    // getCurrentLocation();
  }
  String get currentLocation {
    return location;
  }

  void getCurrentLocation(BuildContext context) async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");

    location = addresses[0].subLocality + ', ' + addresses[0].locality;
    notifyListeners();
  }
}
