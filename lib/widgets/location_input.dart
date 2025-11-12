import 'dart:convert';
import 'package:favorite_places/apis.dart';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({required this.onSelectLocation, super.key});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLoaction;
  bool _isGettingLocation = false;

  String get locationImage {
    if (_pickedLoaction == null) {
      return '';
    }
    final lat = _pickedLoaction!.latitude;
    final lng = _pickedLoaction!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:%7C$lat,$lng&key=$googleAPI';
  }

  Future<List<double>> _getCurrentLocation() async {
    final location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return [0, 0];
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return [0, 0];
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return [0, 0];
    }

    return [lat, lng];
  }

  Future<void> _savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleAPI',
    );
    final response = await http.get(url);
    final respData = json.decode(response.body);
    // ignore: avoid_dynamic_calls
    final address = respData['results'][0]['formatted_address'];

    setState(() {
      _pickedLoaction = PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: address as String,
      );
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickedLoaction!);
  }

  Future<void> _selectCurrentLocation() async {
    await _getCurrentLocation().then((value) async {
      await _savePlace(value[0], value[1]);
    });
  }

  Future<void> _selectOnMap() async {
    final currentLocation = await _getCurrentLocation();

    final pickedLocation =
        await Navigator.of(
          // ignore: use_build_context_synchronously
          context,
        ).push<LatLng>(
          MaterialPageRoute(
            builder: (ctx) => MapScreen(
              location: PlaceLocation(
                latitude: currentLocation[0],
                longitude: currentLocation[1],
                address: '',
              ),
            ),
          ),
        );

    if (pickedLocation == null) {
      return;
    }

    await _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen.',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );

    if (_pickedLoaction != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.5,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _selectCurrentLocation,
              label: const Text('Get Current Location'),
              icon: const Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              label: const Text('Select on Map'),
              icon: const Icon(Icons.map),
            ),
          ],
        ),
      ],
    );
  }
}
