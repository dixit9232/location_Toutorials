import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(MaterialApp(home: LocationDemo()));
}

class LocationDemo extends StatefulWidget {
  const LocationDemo({super.key});

  @override
  State<LocationDemo> createState() => _LocationStateDemo();
}

class _LocationStateDemo extends State<LocationDemo> {
  String lat = '';
  String long = '';

  Future getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location Service is disable');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Geolocator.openAppSettings();
    }
    return await Geolocator.getCurrentPosition();
  }

  LiveLocation() {
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();
    });
  }

  Future OpenMap(String lat, String long) async {
    String url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tuttorials'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User Loaction :\nlatitude:$lat\nLongitude:$long',
                style: TextStyle(fontSize: 20)),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  getLocation().then((value) {
                    lat = value.latitude.toString();
                    long = value.longitude.toString();
                    print(value);
                    setState(() {});
                  });
                },
                child: Text('Get Locaton')),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  getLocation().then((value) {
                    OpenMap(value.latitude.toString(), value.longitude.toString());
                  });
                },
                child: Text('OpenMap')),
            SizedBox(height: 30,),
            ElevatedButton(
                onPressed: () {
                  LiveLocation();
                  setState(() {

                  });
                },
                child: Text('Live Location'))
          ],
        ),
      ),
    );
  }
}
