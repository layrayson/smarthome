import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smarthome/cubits/location_cubit.dart';
import 'package:smarthome/cubits/control_cubit.dart';
import 'package:smarthome/splash_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    super.initState();
    // WidgetsFlutterBinding.ensureInitialized();

    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );

    Workmanager().registerOneOffTask(
      "startStream",
      'startStream',
    );
    BlocProvider.of<LocationCubit>(context).start();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      switch (task) {
        case 'startStream':
          BlocProvider.of<LocationCubit>(context).start();
          // Position userLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          break;
      }
      return Future.value(true);
    });
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
