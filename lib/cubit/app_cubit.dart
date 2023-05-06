import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppState extends Equatable {
  final bool userFarFromHome;
  const AppState({required this.userFarFromHome});

  List<Object?> get props => [userFarFromHome];
}

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState(userFarFromHome: false));

  setUserFarFromHome(bool data) {
    emit(AppState(userFarFromHome: data));
  }
}
