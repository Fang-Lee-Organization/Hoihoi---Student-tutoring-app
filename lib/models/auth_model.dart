import 'dart:convert';
import 'package:doctor_appointment_app/screens/appointment_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/dio_provider.dart';

class AuthModel extends ChangeNotifier {
  bool _isLogin = false;
  Map<String, dynamic> user = {}; //update user details when login

  Map<String, dynamic> firstAppointment =
      {}; //update upcoming appointment when login

  List<Map<String, dynamic>> favDoc = []; //get latest favorite doctor
  List<dynamic> _fav = []; //get all fav doctor id in list

  List<dynamic> appointments = [];
  List<dynamic> filteredAppointments = [];

  List<dynamic> reviews = [];
  List<dynamic> filteredReviews = [];

  bool get isLogin {
    return _isLogin;
  }

  List<dynamic> get getFav {
    return _fav;
  }

  Map<String, dynamic> get getUser {
    return user;
  }

  Map<String, dynamic> get getFirstAppointment {
    return firstAppointment;
  }

//this is to update latest favorite list and notify all widgets
  void setFavList(List<dynamic> list) {
    _fav = list;
    notifyListeners();
  }

//and this is to return latest favorite doctor list
  List<Map<String, dynamic>> get getFavDoc {
    favDoc.clear(); //clear all previous record before get latest list

    //list out doctor list according to favorite list
    for (var num in _fav) {
      for (var doc in user['doctor']) {
        if (num == doc['doc_id']) {
          favDoc.add(doc);
        }
      }
    }
    return favDoc;
  }

  List<dynamic> get getAppointments {
    return appointments;
  }

  void setFilteredAppointments([String status = 'booked']) {
    filteredAppointments = appointments.where((var app) {
      return app['status'] == status;
    }).toList();

    notifyListeners();
  }

  List<dynamic> get getFilteredAppointments {
    return filteredAppointments;
  }

  void setFilteredReviews(int id) {
    filteredReviews = reviews.where((var review) {
      return review['doc_id'] == id;
    }).toList();

    notifyListeners();
  }

  List<dynamic> get getFilteredReviews {
    return filteredReviews;
  }

//when login success, update the status
  void loginSuccess(Map<String, dynamic> userData, String token) {
    _isLogin = true;
    //update all these data when login
    user = userData;
    if (user['details']['fav'] != null) {
      _fav = json.decode(user['details']['fav']);
    }
    refreshAppointment(token);
    refreshReview(token);

    notifyListeners();
  }

  Future<void> refreshAppointment(String token) async {
    var encodedAppointments = await DioProvider().getAppointments(token);
    appointments = json.decode(encodedAppointments);
    firstAppointment = {};

    for (var app in appointments) {
      if (app['status'] == 'booked') {
        firstAppointment = app;
        break;
      }
    }
    setFilteredAppointments();

    notifyListeners();
  }

  Future<void> refreshReview(String token) async {
    var encodedReviews = await DioProvider().getReviews(token);
    reviews = json.decode(encodedReviews);

    notifyListeners();
  }
}
