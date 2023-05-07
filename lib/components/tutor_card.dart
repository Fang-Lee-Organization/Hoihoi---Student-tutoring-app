import 'package:doctor_appointment_app/main.dart';
import 'package:doctor_appointment_app/screens/tutor_details.dart';
import 'package:doctor_appointment_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth_model.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    Key? key,
    required this.doctor,
    required this.isFav,
  }) : super(key: key);

  final Map<String, dynamic> doctor;
  final bool isFav;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: Config.widthSize * 0.33,
                child: Image.network(
                  Config.base_url + doctor['doctor_profile'],
                  fit: BoxFit.fill,
                ),
              ),
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Tutor ${doctor['doctor_name']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${doctor['category']}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("${doctor['doctor_rating']}"),
                          Spacer(
                            flex: 1,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 16,
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Text('Reviews'),
                          Spacer(
                            flex: 1,
                          ),
                          Text("(${doctor['doctor_review']})"),
                          Spacer(
                            flex: 7,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Provider.of<AuthModel>(context, listen: false)
              .setFilteredReviews(doctor['doc_id']);
          //pass the details to detail page
          MyApp.navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (_) => DoctorDetails(
                    doctor: doctor,
                    isFav: isFav,
                  )));
        },
      ),
    );
  }
}
