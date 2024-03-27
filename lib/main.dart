import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Geolocation(),
    );
  }
}

class Geolocation extends StatefulWidget {
  const Geolocation({super.key});

  @override
  State<Geolocation> createState() => _GeolocationState();
}

class _GeolocationState extends State<Geolocation> {


  Position? _currentLocation;
  late bool servicePermission= false;
  late LocationPermission permission;

  String _currentAddress = "";

  Future<Position> _getCurrentLocation() async {
    //let's first of all check if we have permission to access location service
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print("service disabled");
    }
    //the service is enabled on major phones ,but it is always okay to check it
    permission = await Geolocator.checkPermission();
    if(permission==LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  //now let's test our app

  //Let's geocode the coordinates and convert them into adressess
  _getAddressFromCoordinates() async {
    try{
      List<Placemark> placemarks = await placemarkFromCoordinates(_currentLocation!.latitude, _currentLocation!.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress = "${place.locality}, ${place.country}";
      });
    }
    catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    //noe lets create the logic of the app


    return Scaffold(
      appBar: AppBar(
        title: Text("Get User Location"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Location  Coordinates",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),),
            SizedBox(
              height: 6,
            ),
            Text("Latitude = ${ _currentLocation?.latitude} ;  Longitude = ${_currentLocation?.longitude}"),

            SizedBox(
              height: 30.0,
            ),
            Text("Location  Address",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),
            SizedBox(
              height: 6,
            ),
            Text("${_currentAddress}"),
            SizedBox(height: 50.0,),
            ElevatedButton(onPressed: () async {
              //get current location
              _currentLocation = await _getCurrentLocation();
              await _getAddressFromCoordinates();
              print("${_currentLocation}");
              print("${_currentAddress}");

            },
                child: Text("Get Location"))

          ],

      ),),
    );
  }
}
