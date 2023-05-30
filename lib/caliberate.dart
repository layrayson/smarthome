import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smarthome/cubits/location_cubit.dart';

class CaliberateLocation extends StatefulWidget {
  const CaliberateLocation({super.key});

  @override
  State<CaliberateLocation> createState() => _CaliberateLocationState();
}

class _CaliberateLocationState extends State<CaliberateLocation> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getUserLocation());
  }

  Future<Position?> getUserLocation() async {
    PermissionStatus permission = await Permission.location.request();

// Check if permission was granted
    if (permission == PermissionStatus.granted) {
      // Get the user's location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      // Print the latitude and longitude
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      return position;
    } else {
      // Permission denied
      print('Permission denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Location Caliberation',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              child: Text(
                "Please note, for correct caliberation, make sure you're within the view of the IoT device",
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextButton(
              onPressed: () async {
                Position? position = await getUserLocation();
                print(position?.latitude);
                BlocProvider.of<LocationCubit>(context).writeLocation(
                    '${position?.latitude},${position?.longitude}');
                BlocProvider.of<LocationCubit>(context).start();
              },
              child: Text(
                "Yes, Caliberate",
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue[900]),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
