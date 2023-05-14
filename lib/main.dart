import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smarthome/cubits/location_cubit.dart';
import 'package:smarthome/cubits/control_cubit.dart';
import 'package:smarthome/splash_screen.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => LocationCubit()),
    BlocProvider(create: (context) => ControlCubit())
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<LocationCubit>(context).start();
    super.initState();
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
