import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smarthome/cubit/app_cubit.dart';
import 'package:smarthome/splash_screen.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(BlocProvider(create: (context) => AppCubit(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/location.txt');
  }

  Future<List<double>> readLocation() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      final splitContent = contents.split(',');

      return [
        double.parse(contents.split(',')[0]),
        double.parse(contents.split(',')[1])
      ];
    } catch (e) {
      // If encountering an error, return 0
      return [];
    }
  }

  checkUserFarFromHome(Position position) async {
    final cachedPosition = await readLocation();
    final distanceBetween = Geolocator.distanceBetween(
      cachedPosition[0],
      cachedPosition[1],
      position.latitude,
      position.longitude,
    );
    print('dist: ${distanceBetween}');
    BlocProvider.of<AppCubit>(context).setDistanceBetween(distanceBetween);

    if (distanceBetween > 2) {
      BlocProvider.of<AppCubit>(context).setUserFarFromHome(true);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(
                locationSettings:
                    LocationSettings(accuracy: LocationAccuracy.high))
            .listen(checkUserFarFromHome);
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My App',
      home: SplashScreen(),
      // Add your other routes here
    );
  }
}
