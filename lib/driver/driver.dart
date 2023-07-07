import 'package:analog_clock/analog_clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;

class Driver extends StatefulWidget {
  const Driver({Key? key}) : super(key: key);

  @override
  State<Driver> createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  late double screenHeight;
  late double screenWidth;
  String phoneNumber = "";
  bool ride = false;
  FocusNode myFocusNode = FocusNode();
  final loc.Location location = loc.Location();
  FocusNode myFocusNode2 = FocusNode();
  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      // Thumb icon when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.black54,
          foregroundColor: Colors.black,
          backgroundColor: Colors.yellow[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          elevation: 5,
          centerTitle: true,
          toolbarHeight: screenHeight / 5,
          title: Text('Bus Admin',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                  color: Colors.black)),
        ),
        body: SizedBox(
          width: screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: screenWidth / 2,
                height: screenWidth / 2,
                child: AnalogClock(
                  digitalClockColor: Colors.black,
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 4.0, color: Colors.orange[700]!),
                      color: Colors.transparent,
                      shape: BoxShape.circle),
                  width: screenWidth / 3,
                  isLive: true,
                  hourHandColor: Colors.grey[800]!,
                  minuteHandColor: Colors.black,
                  showSecondHand: true,
                  numberColor: Colors.black87,
                  // showNumbers: true,
                  textScaleFactor: 1.4,
                  showTicks: true, secondHandColor: Colors.red[700]!,
                  useMilitaryTime: false,
                  showDigitalClock: true,
                  datetime: DateTime.now(),
                  key: const GlobalObjectKey(3),
                ),
              ),
              Column(
                children: [
                  Switch(
                    value: ride,
                    onChanged: (bool value) async {
                      setState(() {
                        ride = value;
                      });
                      if (ride) startRide();
                    },
                  ),
                  Text(
                    "${!ride ? 'Start' : 'Stop'} Ride",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Future<void> startRide() async {
    while (ride) {
      await Future.delayed(const Duration(seconds: 3));
      try {
        final loc.LocationData _locationResult = await location.getLocation();
        await FirebaseFirestore.instance
            .collection('location')
            .doc('user1')
            .set({
          'latitude': _locationResult.latitude,
          'longitude': _locationResult.longitude,
          'name': 'Bus-No'
        }, SetOptions(merge: true));
      } catch (e) {
        print(e);
      }
    }
  }
}
