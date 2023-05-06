// import 'package:doctor_appointment_app/main.dart';
// import 'package:doctor_appointment_app/providers/dio_provider.dart';
// import 'package:doctor_appointment_app/utils/config.dart';
// import 'package:flutter/material.dart';
// import 'package:rating_dialog/rating_dialog.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// class CommentCard extends StatefulWidget {
//   CommentCard(
//       {Key? key,
//         required this.review,
//         required this.color,
//         required this.isBooked,
//         required this.isHome})
//       : super(key: key);
//
//   final Map<String, dynamic> doctor;
//   final Color color;
//   final bool isBooked;
//   final bool isHome;
//
//   @override
//   State<CommentCard> createState() => _CommentCardState();
// }
//
// class _AppointmentCardState extends State<AppointmentCard> {
//   String? token;
//
//   Future<void> getToken() async {
//     final SharedPreferences pref = await SharedPreferences.getInstance();
//     token = pref.getString('token') ?? '';
//   }
//
//   @override
//   void initState() {
//     getToken();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: widget.color,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: <Widget>[
//                 //insert Row here
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundImage: NetworkImage(Config.base_url +
//                           widget.doctor[
//                           'doctor_profile']), //insert doctor profile
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           'Tutor: ${widget.doctor['doctor_name']}',
//                           style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(
//                           height: 2,
//                         ),
//                         Text(
//                           'Subject: ${widget.doctor['category']}',
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 14),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//                 Config.spaceSmall,
//                 //Schedule info here
//                 ScheduleCard(
//                   appointment: widget.doctor,
//                 ),
//                 Config.spaceSmall,
//                 //action button
//                 widget.isBooked
//                     ? Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.indigo),
//                         child: const Text(
//                           'Cancel',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         onPressed: () async {
//                           final cancel = await DioProvider()
//                               .cancelAppointment(
//                               widget.doctor['id'], token!);
//
//                           if (cancel == 200 && cancel != '') {
//                             print('Hello');
//                             MyApp.navigatorKey.currentState!.pushNamed(
//                                 widget.isHome ? 'appointment' : 'main');
//                           }
//                         },
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 20,
//                     ),
//                     Expanded(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white),
//                         child: const Text(
//                           'Completed',
//                           style: TextStyle(color: Colors.indigo),
//                         ),
//                         onPressed: () {
//                           showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return RatingDialog(
//                                     initialRating: 1.0,
//                                     title: const Text(
//                                       'Rate the Tutor',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         fontSize: 25,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     message: const Text(
//                                       'Please help us to rate our Tutor',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         fontSize: 15,
//                                       ),
//                                     ),
//                                     image: const FlutterLogo(
//                                       size: 100,
//                                     ),
//                                     submitButtonText: 'Submit',
//                                     commentHint: 'Your Reviews',
//                                     onSubmitted: (response) async {
//                                       final SharedPreferences prefs =
//                                       await SharedPreferences
//                                           .getInstance();
//                                       final token =
//                                           prefs.getString('token') ?? '';
//
//                                       final rating = await DioProvider()
//                                           .storeReviews(
//                                           response.comment,
//                                           response.rating,
//                                           widget.doctor['id'],
//                                           //this is appointment id
//                                           widget.doctor['doc_id'],
//                                           //this is doctor id
//                                           token);
//
//                                       //if successful, then refresh
//                                       if (rating == 200 && rating != '') {
//                                         MyApp.navigatorKey.currentState!
//                                             .pushNamed(widget.isHome
//                                             ? 'appointment'
//                                             : 'main');
//                                       }
//                                     });
//                               });
//                         },
//                       ),
//                     ),
//                   ],
//                 )
//                     : Row(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
