import 'package:doctor_appointment_app/providers/dio_provider.dart';
import 'package:doctor_appointment_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../components/appointment_card.dart';
import '../models/auth_model.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  List<String> statusList = ['Booked', 'Complete', 'Cancel'];
  String status = 'Booked'; //initial status
  Alignment _alignment = Alignment.centerLeft;

  //get appointments details

  // @override
  // void initState() {
  //   getAppointments();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    List<dynamic> filteredAppointments =
        Provider.of<AuthModel>(context, listen: false).getFilteredAppointments;

    return SafeArea(
      child: Consumer<AuthModel>(builder: (context, auth, child) {
        return Padding(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Appointment Schedule',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Config.spaceSmall,
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //this is the filter tabs
                        for (var filter in statusList)
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (filter == 'Booked') {
                                    _alignment = Alignment.centerLeft;
                                  } else if (filter == 'Complete') {
                                    _alignment = Alignment.center;
                                  } else if (filter == 'Cancel') {
                                    _alignment = Alignment.centerRight;
                                  }
                                  status = filter;
                                  // Use the status variable to synchronize with the text of AnimatedAlign at line 105
                                  auth.setFilteredAppointments(
                                      status.toLowerCase());
                                });
                              },
                              child: Center(
                                child: Text(filter),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  AnimatedAlign(
                    alignment: _alignment,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Config.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Config.spaceSmall,
              Expanded(
                  child: ListView.builder(
                itemCount: auth.getFilteredAppointments.length,
                itemBuilder: ((context, index) {
                  var app = auth.getFilteredAppointments[index];
                  // print((app).runtimeType);

                  return AppointmentCard(
                    app: app,
                    color: Config.primaryColor,
                    isBooked: app['status'] == 'booked',
                  );
                }),
              )),
            ],
          ),
        );
      }),
    );
  }
}
