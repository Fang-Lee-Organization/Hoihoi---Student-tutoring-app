import 'package:doctor_appointment_app/main.dart';
import 'package:doctor_appointment_app/providers/dio_provider.dart';
import 'package:doctor_appointment_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentCard extends StatefulWidget {
  CommentCard({Key? key, required this.review, required this.color})
      : super(key: key);

  final Map<String, dynamic> review;
  final Color color;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
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
          borderRadius: BorderRadius.circular(5),
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                //insert Row here
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          Config.base_url + widget.review['user_profile']),
                      //insert doctor profile
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(children: [
                          Text(
                            '${widget.review['user_name']}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          for (int i = 0; i < widget.review['ratings']; i++)
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 14,
                            )
                        ]),
                        const SizedBox(
                          height: 5,
                        ),
                        //action button
                        Text(widget.review['reviews'])
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
