import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CopyThing extends StatefulWidget {
  String document;
  String collection;
  CopyThing({Key? key, required this.document, required this.collection})
      : super(key: key);

  @override
  State<CopyThing> createState() => _CopyThingState();
}

class _CopyThingState extends State<CopyThing> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [],
        ),
      );

  Widget buildCopy() => Builder(
        builder: (context) => Row(
          children: [
            Expanded(child: TextField(controller: controller,
            )
            ),
            IconButton(
              icon: const Icon(Icons.content_copy),
              onPressed: () async {
                await FlutterClipboard.copy(controller.text);
              },
            ),
          ],
        ),
      );
}










































































































// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapSample extends StatefulWidget {
//   const MapSample({Key? key}) : super(key: key);

//   @override
//   State<MapSample> createState() => MapSampleState();
// }

// class MapSampleState extends State<MapSample> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();

//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );

//   static const CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.hybrid,
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: const Text('To the lake!'),
//         icon: const Icon(Icons.directions_boat),
//       ),
//     );
//   }

//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }

// const LatLng currentLocation = LatLng(25.1193, 55.3773);

// class LocationPage extends StatefulWidget {
//   const LocationPage({super.key});

//   @override
//   State<LocationPage> createState() => _LocationPageState();
// }

// class _LocationPageState extends State<LocationPage> {
//   @override
//   Widget build(BuildContext context) {
//     return  const Scaffold(
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: currentLocation,
//           zoom: 14,
//           )
//         )
//     );
//   }
