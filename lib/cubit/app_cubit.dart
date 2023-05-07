import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppState extends Equatable {
  final bool userFarFromHome;
  double? distanceBetween;
  AppState({required this.userFarFromHome, this.distanceBetween});

  List<Object?> get props => [userFarFromHome, distanceBetween];
}

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState(userFarFromHome: false));

  setUserFarFromHome(bool data) {
    emit(AppState(
        userFarFromHome: data, distanceBetween: state.distanceBetween));
  }

  setDistanceBetween(double data) {
    emit(AppState(
        userFarFromHome: state.userFarFromHome, distanceBetween: data));
  }
}

enum Mode { loading, loaded, error }
