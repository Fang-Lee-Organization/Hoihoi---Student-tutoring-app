import 'package:Hoihoi/components/button.dart';
import 'package:Hoihoi/components/custom_appbar.dart';
import 'package:Hoihoi/main.dart';
import 'package:Hoihoi/models/booking_datetime_converted.dart';
import 'package:Hoihoi/providers/dio_provider.dart';
import 'package:Hoihoi/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

import '../models/auth_model.dart';

class BookingPage extends StatefulWidget {
  BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();

  // int? _currentIndex;
  TimeOfDay? selectedTime = TimeOfDay.now();
  TimeOfDay _currentTime = TimeOfDay.now();
  bool _isWeekend = false;
  bool _dateSelected = true;

  // bool _timeSelected = false;

  late GoogleMapController mapController;
  static const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(15.975468446307751, 108.25243010186809), zoom: 16);
  Set<Marker> markersList = {};
  String _currentLocation = 'Đại học Việt - Hàn';

  String? token; //get token for insert booking date and time into database

  Future<void> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    final tutor = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Appointment',
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: <Widget>[
                  // SearchMapPlaceWidget(
                  //     apiKey: 'AIzaSyD1sRLh3eYI2svfLJ0hreKM5Yr7gEjOUxA',
                  //     placeType: PlaceType.address,
                  //     placeholder: 'Search location',
                  //     onSelected: (Place place) async {
                  //       geolocation = (await place.geolocation)!;
                  //     }),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                              'Location: ${_currentLocation.length > 20 ? _currentLocation.substring(0, 20) : _currentLocation}...',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                          ElevatedButton(
                              onPressed: _searchLocation,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Config.primaryColor,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 10)),
                              child: const Text("Search")),
                        ],
                      )),
                  SizedBox(
                    height: 250,
                    child: GoogleMap(
                      initialCameraPosition: initialCameraPosition,
                      markers: markersList,
                      zoomControlsEnabled: false,
                      mapType: MapType.normal,
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                    ),
                  ),
                  _tableCalendar(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Appointment Time: ${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Config.primaryColor,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 10)),
                            onPressed: () async {
                              selectedTime = await showTimePicker(
                                context: context,
                                initialTime: _currentTime,
                                builder: (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                },
                              );
                              setState(() {
                                if (selectedTime != null) {
                                  _currentTime = selectedTime!;
                                }
                              });
                            },
                            child: const Text('Select',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // if (_isWeekend)
          //   SliverToBoxAdapter(
          //     child: Container(
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          //       alignment: Alignment.center,
          //       child: const Text(
          //         'Weekend is not available, please select another day',
          //         style: TextStyle(
          //           fontSize: 18,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.grey,
          //         ),
          //       ),
          //     ),
          //   ),
          // : SliverGrid(
          //     delegate: SliverChildBuilderDelegate(
          //       (context, index) {
          //         return InkWell(
          //           splashColor: Colors.transparent,
          //           onTap: () {
          //             setState(() {
          //               _currentIndex = index;
          //               _timeSelected = true;
          //             });
          //           },
          //           child: Container(
          //             margin: const EdgeInsets.all(5),
          //             decoration: BoxDecoration(
          //               border: Border.all(
          //                 color: _currentIndex == index
          //                     ? Colors.white
          //                     : Colors.black,
          //               ),
          //               borderRadius: BorderRadius.circular(15),
          //               color: _currentIndex == index
          //                   ? Config.primaryColor
          //                   : null,
          //             ),
          //             alignment: Alignment.center,
          //             child: Text(
          //               '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}',
          //               style: TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 color:
          //                     _currentIndex == index ? Colors.white : null,
          //               ),
          //             ),
          //           ),
          //         );
          //       },
          //       childCount: 8,
          //     ),
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //         crossAxisCount: 4, childAspectRatio: 1.5),
          //   ),

          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: SizedBox(
                height: 40,
                child: Button(
                  width: double.infinity,
                  title: 'Make Appointment',
                  onPressed: () async {
                    //convert date/day/time into string first
                    final getDate = DateConverted.getDate(_currentDay);
                    final getDay = DateConverted.getDay(_currentDay.weekday);
                    final getTime =
                        '${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}';
                    //https://api.flutter.dev/flutter/dart-core/String/padLeft.html

                    final booking = await DioProvider().bookAppointment(
                        getDate,
                        getDay,
                        getTime,
                        _currentLocation,
                        tutor['doctor_id'],
                        // _currentLocation,
                        token!);

                    //if booking return status code 200, then redirect to success booking page

                    if (booking == 200) {
                      Provider.of<AuthModel>(context, listen: false)
                          .refreshAppointment(token!);

                      MyApp.navigatorKey.currentState!
                          .pushNamed('success_booking');
                    }
                  },
                  disable: _dateSelected ? false : true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchLocation() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: googleApiKey,
        onError: onError,
        mode: Mode.overlay,
        // language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                // borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
        components: [
          Component(Component.country, "vn")
        ]); //filter country of results

    displayPrediction(p!);
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error',
          message: response.errorMessage!,
          contentType: ContentType.failure,
        )));
  }

  Future<void> displayPrediction(Prediction p) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: googleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {
      _currentLocation = detail.result.name;
    });

    mapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16));
  }

  //table calendar
  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2023, 12, 31),
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 45,
      calendarStyle: const CalendarStyle(
        todayDecoration:
            BoxDecoration(color: Config.primaryColor, shape: BoxShape.circle),
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: ((selectedDay, focusedDay) {
        setState(() {
          _currentDay = selectedDay;
          _focusDay = focusedDay;
          _dateSelected = true;

          //check if weekend is selected
          if (selectedDay.weekday == 7) {
            _isWeekend = true;
            _dateSelected = false;
            // _timeSelected = false;
            // _currentIndex = null;
          } else {
            _isWeekend = false;
          }
        });
      }),
    );
  }
}
