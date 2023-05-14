import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'location_cubit.dart';

class ControlState extends Equatable {
  bool? previousBulbState;
  final bool bulbState;

  bool? previousFanState;
  final bool fanState;

  bool? previousSocketState;
  final bool socketState;

  bool? previousAllState;
  final bool allState;

  final Mode mode;

  ControlState(
      {required this.bulbState,
      required this.fanState,
      required this.socketState,
      required this.allState,
      required this.mode,
      this.previousBulbState,
      this.previousFanState,
      this.previousSocketState,
      this.previousAllState});

  List<Object?> get props => [
        bulbState,
        fanState,
        socketState,
        allState,
        mode,
      ];
}

class ControlCubit extends Cubit<ControlState> {
  final dio = Dio();
  CancelToken cancelToken = CancelToken();

  String get writeAPIKey => 'NPP769B2M1CGHPTS';
  String get writeBaseUrl =>
      'https://api.thingspeak.com/update?api_key=$writeAPIKey';
  ControlCubit()
      : super(ControlState(
          bulbState: false,
          previousBulbState: false,
          fanState: false,
          previousFanState: false,
          socketState: false,
          previousSocketState: false,
          allState: false,
          previousAllState: false,
          mode: Mode.loaded,
        ));

  int convertToBinary(bool value) {
    return value ? 1 : 0;
  }

  setComponentState(
      {bool? bulbState,
      bool? fanState,
      bool? socketState,
      bool? allState}) async {
    emit(ControlState(
        bulbState: allState ?? bulbState ?? state.bulbState,
        fanState: allState ?? fanState ?? state.fanState,
        socketState: allState ?? socketState ?? state.socketState,
        allState: allState ?? state.allState,
        mode: state.mode));
    await updateThingSpeakChannel();
  }

  updateThingSpeakChannel() async {
    cancelToken.cancel('cancelled');

    cancelToken = CancelToken();
    try {
      emit(ControlState(
          bulbState: state.bulbState,
          fanState: state.fanState,
          socketState: state.socketState,
          allState: state.allState,
          mode: Mode.loading));
      final url =
          '$writeBaseUrl&field1=${convertToBinary(state.bulbState)}&field2=${convertToBinary(state.fanState)}&field3=${convertToBinary(state.socketState)}';
      print(url);
      final response = await dio.get(url, cancelToken: cancelToken);
      emit(ControlState(
          bulbState: state.bulbState,
          previousBulbState: state.previousBulbState,
          fanState: state.fanState,
          previousFanState: state.previousFanState,
          socketState: state.socketState,
          previousSocketState: state.previousSocketState,
          allState: state.allState,
          previousAllState: state.previousAllState,
          mode: Mode.loaded));
      print(response);
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) {
        print('Request cancelled: ${e.message}');
      } else {
        print('normal error');
        emit(ControlState(
            bulbState: state.previousBulbState ?? false,
            fanState: state.previousFanState ?? false,
            socketState: state.previousSocketState ?? false,
            allState: state.previousAllState ?? false,
            mode: Mode.error));
      }
    }
  }
}
