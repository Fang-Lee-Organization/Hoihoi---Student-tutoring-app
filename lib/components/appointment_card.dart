import 'package:doctor_appointment_app/main.dart';
import 'package:doctor_appointment_app/providers/dio_provider.dart';
import 'package:doctor_appointment_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_model.dart';

class AppointmentCard extends StatefulWidget {
  AppointmentCard(
      {Key? key,
      required this.app,
      required this.color,
      required this.isBooked})
      : super(key: key);

  final Map<String, dynamic> app;
  final Color color;
  final bool isBooked;

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  String? token;

  Future<void> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString('token') ?? '';
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                //insert Row here
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(Config.base_url +
                          widget.app['doctor_profile']), //insert doctor profile
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Tutor: ${widget.app['doctor_name']}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          'Subject: ${widget.app['category']}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        )
                      ],
                    ),
                  ],
                ),
                Config.spaceSmall,
                //Schedule info here
                ScheduleCard(
                  appointment: widget.app,
                ),
                Config.spaceSmall,
                //action button
                widget.isBooked
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                final cancel = await DioProvider()
                                    .cancelAppointment(
                                        widget.app['id'], token!);

                                //if successful, then refresh
                                if (context.mounted) {
                                  Provider.of<AuthModel>(context, listen: false)
                                      .refreshAppointment(token!);
                                }
                                // if (cancel == 200 && cancel != '') {
                                //   MyApp.navigatorKey.currentState!
                                //       .pushNamed('main');
                                // }
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white),
                              child: const Text(
                                'Completed',
                                style: TextStyle(color: Colors.indigo),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return RatingDialog(
                                          initialRating: 1.0,
                                          title: const Text(
                                            'Rate the Tutor',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          message: const Text(
                                            'Please help us to rate our Tutor',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          image: Image.asset("assets/logo.png",
                                              width: 100, height: 100),
                                          submitButtonText: 'Submit',
                                          commentHint: 'Your Reviews',
                                          onSubmitted: (response) async {
                                            final SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            final token =
                                                prefs.getString('token') ?? '';

                                            final rating = await DioProvider()
                                                .storeReviews(
                                                    response.comment,
                                                    response.rating.toDouble(),
                                                    widget.app['id'],
                                                    //this is appointment id
                                                    widget.app['doc_id'],
                                                    //this is doctor id
                                                    token);
                                            //if successful, then refresh
                                            if (context.mounted) {
                                              Provider.of<AuthModel>(context,
                                                      listen: false)
                                                  .refreshAppointment(token);
                                              Provider.of<AuthModel>(context,
                                                      listen: false)
                                                  .refreshReview(token);
                                            }

                                            // if (rating == 200 && rating != '') {
                                            //   MyApp.navigatorKey.currentState!
                                            //       .pushNamed('appointment');
                                            // }
                                          });
                                    });
                              },
                            ),
                          ),
                        ],
                      )
                    : Row(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Schedule Widget
class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key, required this.appointment}) : super(key: key);
  final Map<String, dynamic> appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   color: Color.fromRGBO(255, 227, 179, 1),
      //   borderRadius: BorderRadius.circular(10),
      // ),
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            '${appointment['day']}, ${appointment['date']}',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(
            width: 18,
          ),
          const Icon(
            Icons.access_alarm,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
              child: Text(
            appointment['time'],
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ))
        ],
      ),
    );
  }
}
