import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_map_live/mymap.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.yellow[800]!,
          onPrimary: Colors.white,
          secondary: Colors.white,
          onSecondary: Colors.white,
          background: Colors.white,
          onBackground: Colors.white,
          surface: Colors.black,
          onSurface: Colors.black,
          error: Colors.red,
          onError: Colors.red,
        ),
      ),
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final loc.Location location = loc.Location();
  late double screenHeight;
  late double screenWidth;
  StreamSubscription<loc.LocationData>? _locationSubscription;
  @override
  void initState() {
    super.initState();
    _requestPermission();
    // location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    // location.enableBackgrsoundMode(enable: true);
  }

  _requestPermission() async {
    var perm = Permission.location;
    print("aijiajsi");
    if (!await perm.isGranted) {
      print("ojaojdj");
      var status = await perm.request();

      if (status.isGranted) {
        await location.changeSettings(
          accuracy: loc.LocationAccuracy.high,
          interval: 1000,
        );
        print('done');
      } else if (status.isDenied) {
        print(status.name);
        _requestPermission();
      } else if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        elevation: 5,
        shadowColor: Colors.black54,
        centerTitle: true,
        toolbarHeight: screenHeight / 5,
        title: Text('College Bus Tracker',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 28,
                color: Colors.black)),
      ),
      body: Column(
        children: [
          // TextButton(
          //     onPressed: () {
          //       _getLocation();
          //     },
          //     child: Text('add my location')),
          // TextButton(
          //     onPressed: () {
          //       _listenLocation();
          //     },
          //     child: Text('enable live location')),
          // TextButton(
          //     onPressed: () {
          //       _stopListening();
          //     },
          //     child: Text('stop live location')),
          Expanded(
              child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('location').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MyMap(
                                busNo: "${index + 1}",
                                userId: snapshot.data!.docs[0].id)));
                      },
                      title: Text(snapshot.data!.docs[0]['name'].toString() +
                          " ${index + 1}"),
                      subtitle: Row(
                        children: [
                          Text(snapshot.data!.docs[0]['latitude'].toString()),
                          SizedBox(
                            width: 20,
                          ),
                          Text(snapshot.data!.docs[0]['longitude'].toString()),
                        ],
                      ),
                      trailing: Icon(Icons.directions),
                    );
                  });
            },
          )),
        ],
      ),
    );
  }

  // _getLocation() async {
  //   try {
  //     final loc.LocationData _locationResult = await location.getLocation();
  //     await FirebaseFirestore.instance.collection('location').doc('user1').set({
  //       'latitude': _locationResult.latitude,
  //       'longitude': _locationResult.longitude,
  //       'name': 'Bus-No'
  //     }, SetOptions(merge: true));
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> _listenLocation() async {
  //   _locationSubscription = location.onLocationChanged.handleError((onError) {
  //     print(onError);
  //     _locationSubscription?.cancel();
  //     setState(() {
  //       _locationSubscription = null;
  //     });
  //   }).listen((loc.LocationData currentlocation) async {
  //     await FirebaseFirestore.instance.collection('location').doc('user1').set({
  //       'latitude': currentlocation.latitude,
  //       'longitude': currentlocation.longitude,
  //       'name': 'Bus-No'
  //     }, SetOptions(merge: true));
  //   });
  // }

  // _stopListening() {
  //   _locationSubscription?.cancel();
  //   setState(() {
  //     _locationSubscription = null;
  //   });
  // }
}
