import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationState extends Equatable {
  final bool userFarFromHome;
  double? distanceBetween;
  LocationState({required this.userFarFromHome, this.distanceBetween});

  List<Object?> get props => [userFarFromHome, distanceBetween];
}

class LocationCubit extends Cubit<LocationState> {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/location.txt');
  }

  LocationCubit() : super(LocationState(userFarFromHome: false)) {}
  start() async {
    if (!(await Permission.location.isDenied)) {
      final StreamSubscription<Position> positionStream =
          Geolocator.getPositionStream(
                  locationSettings:
                      LocationSettings(accuracy: LocationAccuracy.best))
              .listen(checkUserFarFromHome);
    }
  }

  Future<File> writeLocation(String location) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$location');
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

    emit(LocationState(
        userFarFromHome: distanceBetween > 2,
        distanceBetween: distanceBetween));
  }

  setUserFarFromHome(bool data) {
    emit(LocationState(
        userFarFromHome: data, distanceBetween: state.distanceBetween));
  }

  setDistanceBetween(double data) {
    emit(LocationState(
        userFarFromHome: state.userFarFromHome, distanceBetween: data));
  }
}

enum Mode { loading, loaded, error }
