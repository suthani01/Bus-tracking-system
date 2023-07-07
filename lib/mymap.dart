import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_map_live/driver/login.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class MyMap extends StatefulWidget {
  final String busNo;
  final String userId;
  MyMap({required this.userId, required this.busNo});
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final loc.Location location = loc.Location();
  late double screenHeight;
  late double screenWidth;
  late GoogleMapController _controller;
  bool _added = false;
  String address = "";
  List currentLocation = [];
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('location').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (_added) {
          mymap(snapshot);
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return Stack(
          children: [
            GoogleMap(
              markers: {
                Marker(
                    position: LatLng(
                      snapshot.data!.docs.singleWhere(
                          (element) => element.id == widget.userId)['latitude'],
                      snapshot.data!.docs.singleWhere((element) =>
                          element.id == widget.userId)['longitude'],
                    ),
                    markerId: MarkerId('id'),
                    icon: BitmapDescriptor.defaultMarker),
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                    snapshot.data!.docs.singleWhere(
                        (element) => element.id == widget.userId)['latitude'],
                    snapshot.data!.docs.singleWhere(
                        (element) => element.id == widget.userId)['longitude'],
                  ),
                  zoom: 19),
              onMapCreated: (GoogleMapController controller) async {
                setState(() {
                  _controller = controller;
                  _added = true;
                });
              },
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: screenWidth,
                height: screenHeight / 5.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(
                              radius: 30.0,
                              // backgroundImage:
                              //     NetworkImage('https://via.placeholder.com/150'),
                              backgroundColor: Colors.black,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: screenWidth / 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Velumurugan",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "Driver",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                            DropdownButton<String>(
                              items: <String>["Login"].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (_) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              },
                            )
                          ]),
                    ),
                    Container(
                        width: screenWidth,
                        color: Colors.orangeAccent[700],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Bus Number ${widget.busNo}: Thudiyalur - Mettupalayam",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        )),
                  ],
                ),
              ),
            )
          ],
        );
      },
    ));
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.userId)['latitude'],
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.userId)['longitude'],
            ),
            zoom: 19)));
  }
}
