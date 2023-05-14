import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarthome/caliberate.dart';
import 'package:smarthome/cubits/location_cubit.dart';
import 'package:smarthome/cubits/control_cubit.dart';
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
  ControlCubit get cubit => BlocProvider.of<ControlCubit>(context);

  void initState() {
    super.initState();
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
        child: BlocListener<LocationCubit, LocationState>(
          listenWhen: (previous, current) {
            return (previous.userFarFromHome == false) &&
                (current.userFarFromHome == true);
          },
          listener: (context, state) {
            print('change: ${state.distanceBetween}');
            if (state.userFarFromHome) cubit.setComponentState(allState: false);
          },
          child: BlocBuilder<ControlCubit, ControlState>(
              builder: (context, state) {
            return Container(
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
                      state.mode == Mode.loading
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
                              cubit.setComponentState(
                                  bulbState: !state.bulbState);
                            },
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: BulbIcon(
                                      color: !state.bulbState
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
                              cubit.setComponentState(
                                  fanState: !state.fanState);
                            },
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  !state.fanState
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
                              cubit.setComponentState(
                                  socketState: !state.socketState);
                            },
                            child: Stack(
                              children: [
                                state.socketState
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
                              cubit.setComponentState(
                                  allState: !state.allState);
                            },
                            child: Center(
                                child: Text(
                              'ALL ${state.allState ? "ON" : "OFF"}',
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
                    child: BlocBuilder<LocationCubit, LocationState>(
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
            );
          }),
        ),
      ),
    );
  }
}
