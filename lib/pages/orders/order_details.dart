// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dboy_two/pages/orders/orders_detail_widget.dart';
import 'package:dboy_two/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';

// ignore: must_be_immutable
class OrderDetailsPage extends StatefulWidget {
  String collection;
  String orderId;
  OrderDetailsPage({
    Key? key,
    required this.collection,
    required this.orderId,
  }) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();

  String uid = "";
  String phoneNumber = "";

  void _getData() async {
    print(widget.orderId);
    try {
      final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("completed orders")
        .doc(widget.orderId)
        .get();

    setState(() {
      uid = doc["customer information"]["userId"];
      phoneNumber = doc["customer information"]["phoneNumber"];
    });
    } catch (e) {
      print(e);
    }
    
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void paymentPhoto() async {
    imgXFile = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgXFile;
    });
  }

  late String lat;
  late String long;
  String locationMessage = 'Current Location of Delivery person';

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service is diasabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, can not request');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();

      setState(() {
        locationMessage = 'Latitude: $lat, Longitude: $long';
      });
    });
  }

  Future<void> _openMap(String lat, String long) async {
    String googleURL =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';

    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : throw 'Could not launch $googleURL';
  }

  TextEditingController controller = TextEditingController();

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to Exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Orders Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 44, 90, 46),
      ),
      body: ListView(padding: const EdgeInsets.all(6), children: [
        detailCard(),
        // paymentimageCard(),
      ]),
      bottomSheet: BottomSheet(
          onClosing: () {},
          builder: (context) {
            return GestureDetector(
              onTap: () {
                deliverOrder(
                  orderId: widget.orderId,
                  phoneNumber: phoneNumber,
                  uid: uid,
                );
                Navigator.pop(context);
              },
              child: Container(
                height: 70,
                margin:
                    const EdgeInsets.symmetric(horizontal: 85.5, vertical: 10),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 108, 155, 109),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 3, 5, 0),
                    child: ListTile(
                      leading: Icon(
                        Icons.check_circle_outline_outlined,
                        size: 35,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Delivered',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget detailCard() => StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection(widget.collection)
          .doc(widget.orderId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var doc = snapshot.data!;
          return Card(
            shadowColor: Colors.red,
            elevation: 3,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(26, 207, 88, 88),
                    Color.fromARGB(31, 218, 160, 160)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 0),
                          child: Container(
                            padding: const EdgeInsets.all(13),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                doc['status'],
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 146, 93, 91),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RichTextWidget(text1: "Order Id: ", text2: widget.orderId),
                  const SizedBox(height: 10),
                  RichTextWidget(
                      text1: 'Ordere Placed On: ', text2: doc['orderData']),
                  const SizedBox(height: 10),
                  RichTextWidget(
                      text1: 'Name: ',
                      text2: doc["customer information"]['name']),

                  const SizedBox(height: 10),
                  RichTextWidget(
                    text1: 'Phone No.: ',
                    text2:
                        (doc["customer information"]['phoneNumber']).toString(),
                  ),
                  // const SizedBox(height: 10),
                  // RichTextWidget(
                  //     text1: 'Address: ',
                  //     text2: doc["delivery information"]['city']),
                  const SizedBox(height: 10),
                  RichTextWidget(
                      text1: 'Payment Status: ', text2: doc['status']),
                  const SizedBox(height: 10),
                  RichTextWidget(
                    text1: 'Total: ',
                    text2: "Birr ${doc["TotalPricewithDelivery"].toString()}",
                  ),

                  const SizedBox(height: 15),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue),
                      const Text(
                        'Address: ',
                        style: TextStyle(
                          letterSpacing: 1.0,
                          color: Color.fromARGB(255, 41, 104, 155),
                        ),
                      ),
                      SelectableText(
                        "${doc['delivery information']['city']}, ${doc['delivery information']['subCity']}, ${doc['delivery information']['street']}",
                        style: const TextStyle(
                            fontSize: 15, overflow: TextOverflow.ellipsis),
                        toolbarOptions: const ToolbarOptions(
                          copy: true,
                          selectAll: true,
                        ),
                        // showCursor: true,
                        // cursorWidth: 10,
                        // cursorColor: Colors.green,
                      )
                    ],
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    'Turn on Location',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),

                  //click
                  ElevatedButton(
                      onPressed: () {
                        _getCurrentLocation().then((value) {
                          lat = '${value.latitude}';
                          long = '${value.longitude}';
                          setState(() {
                            locationMessage =
                                'Latitude : $lat, Longitude: $long';
                          });
                          _liveLocation();
                        });
                      },
                      child: const Text('Get Current Location')),
                  const SizedBox(height: 5),
                  Row(
                    children: const [
                      Text(
                        'Next',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      Icon(
                        Icons.arrow_downward_sharp,
                        color: Colors.blue,
                      )
                    ],
                  ),

                  //open google map
                  ElevatedButton(
                    onPressed: () {
                      _openMap(lat, long);
                    },
                    child: const Text('Open Google Map'),
                  ),

                  const SizedBox(height: 20),
                  OrdersDetail(
                      document: widget.orderId, collection: widget.collection),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }
        return Container();
      });
}

void deliverOrder(
    {required orderId, required phoneNumber, required uid}) async {
  var doc = await FirebaseFirestore.instance
      .collection("completed orders")
      .doc(orderId)
      .get();

  try {
    await FirebaseFirestore.instance
        .collection('delivered orders')
        .doc(orderId)
        .set({
      "customer information": {
        'userId': uid,
        'name': doc["customer information"]["name"],
        'email': doc["customer information"]["email"],
        'phoneNumber': phoneNumber,
      },
      "delivery information": {
        'city': doc["delivery information"]["city"],
        'subCity': doc["delivery information"]["subCity"],
        'street': doc["delivery information"]["street"],
      },
      "ordered products": doc["ordered products"],
      "TotalPricewithDelivery": doc["TotalPricewithDelivery"],
      "deliveryFee": doc["deliveryFee"],
      "subtotal": doc["subtotal"],
      "orderData": doc["orderData"],
      "orderId": doc["orderId"],
      'name': doc["name"],
      'status': "delivered"
    });
    await FirebaseFirestore.instance
        .collection("completed orders")
        .doc(orderId)
        .delete();

    print("deleted");
  } catch (e) {
    print(e);
  }
}
