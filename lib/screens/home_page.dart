import 'dart:convert';

import 'package:Hoihoi/components/appointment_card.dart';
import 'package:Hoihoi/components/tutor_card.dart';
import 'package:Hoihoi/models/auth_model.dart';
import 'package:Hoihoi/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/dio_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> user = {};
  Map<String, dynamic> bookedAppointment = {};
  List<dynamic> favList = [];
  List<Map<String, dynamic>> subjects = [
    {
      "icon": FontAwesomeIcons.calculator,
      "category": "Math",
    },
    {
      "icon": FontAwesomeIcons.code,
      "category": "Programming",
    },
    {
      "icon": FontAwesomeIcons.bullhorn,
      "category": "Marketing",
    },
    {
      "icon": FontAwesomeIcons.plane,
      "category": "Tourism",
    },
    {
      "icon": FontAwesomeIcons.coins,
      "category": "Finance",
    },
    {
      "icon": FontAwesomeIcons.paintbrush,
      "category": "Design",
    },
  ];

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    user = Provider.of<AuthModel>(context, listen: false).getUser;
    bookedAppointment =
        Provider.of<AuthModel>(context, listen: false).getFirstAppointment;
    favList = Provider.of<AuthModel>(context, listen: false).getFav;

    return Scaffold(
      //if user is empty, then return progress indicator
      body: user.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            user['name'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(user[
                                            'profile_photo_url'] ==
                                        null
                                    ? Config.base_url +
                                        user['profile_photo_url']
                                    : 'https://img.icons8.com/ultraviolet/80/test-account.png')),
                          )
                        ],
                      ),
                      Config.spaceMedium,
                      const Text(
                        'Subject',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.spaceSmall,
                      SizedBox(
                        height: Config.heightSize * 0.05,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children:
                              List<Widget>.generate(subjects.length, (index) {
                            return Card(
                              margin: const EdgeInsets.only(right: 20),
                              color: Config.primaryColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    FaIcon(
                                      subjects[index]['icon'],
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      subjects[index]['category'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Config.spaceSmall,
                      const Text(
                        'Appointment Booked',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.spaceSmall,
                      Consumer<AuthModel>(builder: (context, auth, child) {
                        var app = auth.getFirstAppointment;
                        if (app.isNotEmpty) {
                          return AppointmentCard(
                              app: app,
                              color: Config.primaryColor,
                              isBooked: true);
                        }
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'No Appointment Booked',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      Config.spaceSmall,
                      const Text(
                        'Top Tutors',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.spaceSmall,
                      Consumer<AuthModel>(builder: (context, auth, child) {
                        return Column(
                          children: List.generate(auth.getUser['doctor'].length,
                              (index) {
                            return DoctorCard(
                              doctor: auth.getUser['doctor'][index],
                              //if lates fav list contains particular doctor id, then show fav icon
                              isFav: favList.contains(
                                      auth.getUser['doctor'][index]['doc_id'])
                                  ? true
                                  : false,
                            );
                          }),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
