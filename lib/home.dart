import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarthome/caliberate.dart';
import 'package:smarthome/cubit/app_cubit.dart';
import 'dart:convert' as convert;

import 'package:smarthome/icons/bulb_icon.dart';
import 'package:smarthome/icons/fan_icon.dart';
import 'package:smarthome/icons/loading_spinner_icon.dart';
import 'package:smarthome/icons/socket_icon.dart';
import 'package:smarthome/utils/spinning_widget.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool bulbState = false;
  bool _oldBulbState = false;

  bool fanState = false;
  bool _oldFanState = false;

  bool socketState = false;
  bool _oldSocketState = false;

  bool allState = false;
  bool _oldAllState = false;

  bool loading = false;
  final dio = Dio();
  CancelToken cancelToken = CancelToken();

  String get writeAPIKey => 'NPP769B2M1CGHPTS';
  String get writeBaseUrl =>
      'https://api.thingspeak.com/update?api_key=$writeAPIKey';
  ValueNotifier<String> _payload = ValueNotifier<String>("");
  String _oldPayload = "";

  void initState() {
    super.initState();

    _payload.addListener(_handlePayloadUpdated);
  }

  _handlePayloadUpdated() async {
    print(_payload.value);
    await updateThingSpeakChannel();
  }

  updateThingSpeakChannel() async {
    cancelToken.cancel('cancelled');
    cancelToken = CancelToken();
    try {
      setState(() {
        loading = true;
      });
      final response = await dio.get(writeBaseUrl + _payload.value,
          cancelToken: cancelToken);
      print(response);
      setState(() {
        _oldBulbState = bulbState;
        _oldFanState = fanState;
        _oldSocketState = socketState;
        _oldAllState = allState;
        _oldPayload = _payload.value;
        loading = false;
      });
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) {
        print('Request cancelled: ${e.message}');
      } else {
        setState(() {
          bulbState = _oldBulbState;
          fanState = _oldFanState;
          socketState = _oldSocketState;
          allState = _oldAllState;
          loading = false;
        });
        _payload.value = _oldPayload;
        print('normal error');
      }
    }
  }

  updatePayload(String fieldNumber, bool state) {
    final String field = '&field${fieldNumber}=';

    bool payloadContainsFieldNumber = _payload.value.contains(field);
    if (payloadContainsFieldNumber) {
      int indexOfField = _payload.value.indexOf(field);

      _payload.value = _payload.value.replaceRange(
          indexOfField + 8, indexOfField + 9, (state ? '1' : '0'));
    } else {
      _payload.value += field + (state ? '1' : '0');
    }
  }

  toggleAll({bool? state}) {
    setState(() {
      allState = state ?? !allState;
      bulbState = fanState = socketState = allState;

      updatePayload('1', bulbState);
      updatePayload('2', fanState);
      updatePayload('3', socketState);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Control Panel',
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
      drawer: Drawer(
          backgroundColor: Colors.blue[900],
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.home_outlined,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Home',
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CaliberateLocation()));
                        },
                        leading: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Calibrate',
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
      body: SafeArea(
        child: BlocListener<AppCubit, AppState>(
          listener: (context, state) {
            print('change: ${state.distanceBetween}');
            if (state.userFarFromHome) toggleAll(state: false);
          },
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Welcome, Olalere',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    loading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: SpinKitRing(
                              color: Colors.white,
                              size: 15.0,
                              lineWidth: 2,
                              duration: Duration(milliseconds: 700),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    crossAxisCount: 2,
                    children: [
                      Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[900],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            setState(() {
                              bulbState = !bulbState;
                            });
                            updatePayload('1', bulbState);
                          },
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: BulbIcon(
                                    color: !bulbState
                                        ? Colors.grey[500] ?? Colors.white
                                        : Colors.yellow[700] ?? Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[900],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            setState(() {
                              fanState = !fanState;
                              updatePayload('2', fanState);
                            });
                          },
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                !fanState
                                    ? const SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: FanIcon(
                                          color: Colors.white70,
                                        ),
                                      )
                                    : const SpinningWidget(
                                        child: SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: FanIcon(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[900],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            setState(() {
                              socketState = !socketState;
                              updatePayload('3', socketState);
                            });
                          },
                          child: Stack(
                            children: [
                              socketState
                                  ? Align(
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        margin: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Colors.red[700],
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: const Text(
                                          'ON',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                      ),
                                      alignment: Alignment.topRight,
                                    )
                                  : const SizedBox(),
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: const SocketIcon(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[900],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            toggleAll();
                          },
                          child: Center(
                              child: Text(
                            'ALL ${allState ? "ON" : "OFF"}',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
                Center(
                  child: BlocBuilder<AppCubit, AppState>(
                    builder: (context, state) {
                      return Text(
                        '${state.distanceBetween}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 32),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
