import 'package:doctor_appointment_app/components/button.dart';
import 'package:doctor_appointment_app/components/comment_card.dart';
import 'package:doctor_appointment_app/models/auth_model.dart';
import 'package:doctor_appointment_app/providers/dio_provider.dart';
import 'package:doctor_appointment_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components//custom_appbar.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({Key? key, required this.doctor, required this.isFav})
      : super(key: key);
  final Map<String, dynamic> doctor;
  final bool isFav;

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  Map<String, dynamic> doctor = {};
  bool isFav = false;

  @override
  void initState() {
    doctor = widget.doctor;
    isFav = widget.isFav;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Doctor Details',
        icon: const FaIcon(Icons.arrow_back_ios_new),
        actions: [
          //Favorite Button
          IconButton(
            //press this button to add/remove favorite doctor
            onPressed: () async {
              //get latest favorite list from auth model
              final list =
                  Provider.of<AuthModel>(context, listen: false).getFav;

              //if doc id is already exist, mean remove the doc id
              if (list.contains(doctor['doc_id'])) {
                list.removeWhere((id) => id == doctor['doc_id']);
              } else {
                //else, add new doctor to favorite list
                list.add(doctor['doc_id']);
              }

              //update the list into auth model and notify all widgets
              Provider.of<AuthModel>(context, listen: false).setFavList(list);

              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              final token = prefs.getString('token') ?? '';

              if (token.isNotEmpty && token != '') {
                //update the favorite list into database
                final response = await DioProvider().storeFavDoc(token, list);
                //if insert successfully, then change the favorite status

                if (response == 200) {
                  setState(() {
                    isFav = !isFav;
                  });
                }
              }
            },
            icon: FaIcon(
              isFav ? Icons.favorite_rounded : Icons.favorite_outline,
              color: Colors.red,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AboutDoctor(
              doctor: doctor,
            ),
            DetailBody(
              doctor: doctor,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Button(
                width: double.infinity,
                title: 'Book Appointment',
                onPressed: () {
                  Navigator.of(context).pushNamed('booking_page',
                      arguments: {"doctor_id": doctor['doc_id']});
                },
                disable: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutDoctor extends StatelessWidget {
  const AboutDoctor({Key? key, required this.doctor}) : super(key: key);

  final Map<dynamic, dynamic> doctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 65.0,
            backgroundImage: NetworkImage(
              Config.base_url + doctor['doctor_profile'],
            ),
            backgroundColor: Colors.white,
          ),
          Config.spaceSmall,
          Text(
            "Tutor ${doctor['doctor_name']}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'MBBS (International Medical University, Malaysia), MRCP (Royal College of Physicians, United Kingdom)',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'VKU',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({Key? key, required this.doctor}) : super(key: key);
  final Map<dynamic, dynamic> doctor;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Config.spaceSmall,
          DoctorInfo(
              patients: doctor['patients'],
              exp: doctor['experience'],
              rating: doctor['doctor_rating'].toDouble()),
          Config.spaceMedium,
          const Text(
            'About Tutor',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          Config.spaceSmall,
          Text(
            '${doctor['doctor_name']} is an experience ${doctor['category']} Tutor, graduated since 2008, and completed his/her training at Tutor Academy.',
            style: const TextStyle(
              // fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            softWrap: true,
            textAlign: TextAlign.justify,
          ),
          Config.spaceSmall,
          const Text(
            'Reviews',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          Config.spaceSmall,
          Consumer<AuthModel>(builder: (context, auth, child) {
            return SizedBox(
                height: 100,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: auth.getFilteredReviews.length,
                    itemBuilder: ((context, index) {
                      var review = auth.getFilteredReviews[index];
                      return CommentCard(review: review, color: Colors.white);
                    })));
          })
        ],
      ),
    );
  }
}

class DoctorInfo extends StatelessWidget {
  const DoctorInfo(
      {Key? key,
      required this.patients,
      required this.exp,
      required this.rating})
      : super(key: key);

  final int patients;
  final int exp;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InfoCard(
          label: 'Patients',
          value: '$patients',
        ),
        const SizedBox(
          width: 15,
        ),
        InfoCard(
          label: 'Experiences',
          value: '$exp years',
        ),
        const SizedBox(
          width: 15,
        ),
        InfoCard(
          label: 'Rating',
          value: '$rating',
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({Key? key, required this.label, required this.value})
      : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Config.primaryColor,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: Column(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
