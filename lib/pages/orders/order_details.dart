// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dboy_two/pages/orders/orders_detail_widget.dart';
import 'package:dboy_two/widgets.dart';
import 'package:flutter/material.dart';
// import 'dart:io';

import 'package:image_picker/image_picker.dart';

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

  // String SelectedImagePath = "";

  void paymentPhoto() async {
    imgXFile = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgXFile;
    });
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
        backgroundColor: const Color.fromARGB(255, 44, 90, 46),
      ),
      body: ListView(padding: const EdgeInsets.all(6), children: [
        detailCard(),
        paymentimageCard(),
      ]),
      bottomSheet: BottomSheet(
          onClosing: () {},
          builder: (context) {
            return GestureDetector(
                onTap: () {
                  paymentPhoto();
                },
                child: Container(
                  height: 70,
                  // padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: ListTile(
                        leading: Icon(
                          Icons.camera_alt,
                          size: 38,
                        ),
                        title: Text(
                          'Take Payment',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ));
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
                              color: Color.fromARGB(255, 241, 64, 51),
                            ),
                            child: Center(
                              child: Text(
                                doc['status'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
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
                  // const SizedBox(height: 10),
                  // RichTextWidget(
                  //     text1: 'Email: ',
                  //     text2: doc["customer information"]['email']),
                  const SizedBox(height: 10),
                  RichTextWidget(
                    text1: 'Phone No.: ',
                    text2:
                        (doc["customer information"]['phoneNumber']).toString(),
                  ),
                  const SizedBox(height: 10),
                  RichTextWidget(
                      text1: 'Address: ',
                      text2: doc["delivery information"]['city']),
                  const SizedBox(height: 40),
                  RichTextWidget(
                      text1: 'Payment Status: ', text2: doc['status']),
                  const SizedBox(height: 20),
                  RichTextWidget(
                    text1: 'Total: ',
                    text2: "Birr ${doc["TotalPricewithDelivery"].toString()}",
                  ),
                  const SizedBox(height: 20),
                  OrdersDetail(
                      document: widget.orderId, collection: widget.collection),
                ],
              ),
            ),
          );
        }

        return Container();
      });

  Widget paymentimageCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 18, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Payment Photo'),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}


              //Accept
              //   Padding(
              //     padding: const EdgeInsets.all(0),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         GestureDetector(
              //           onTap: () {
              //             Navigator.pushNamed(context, '/');
              //           },
              //           child: Padding(
              //             padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
              //             child: Container(
              //               padding: const EdgeInsets.all(25),
              //               decoration: BoxDecoration(
              //                 color: const Color.fromARGB(255, 84, 168, 73),
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //               child: const Center(
              //                 child: Text(
              //                   'Accept',
              //                   style: TextStyle(
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),

              //         //Reject
              //         Padding(
              //           padding: const EdgeInsets.all(0),
              //           child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //               children: [
              //                 GestureDetector(
              //                   onTap: () {
              //                     Navigator.pushNamed(context, '/reasons_page');
              //                   },
              //                   child: Padding(
              //                     padding:
              //                         const EdgeInsets.fromLTRB(20, 20, 10, 10),
              //                     child: Container(
              //                       padding: const EdgeInsets.all(25),
              //                       decoration: BoxDecoration(
              //                         color: Colors.red,
              //                         borderRadius: BorderRadius.circular(10),
              //                       ),
              //                       child: const Center(
              //                         child: Text(
              //                           'Reject',
              //                           style: TextStyle(
              //                             color: Colors.white,
              //                             fontWeight: FontWeight.bold,
              //                             fontSize: 15,
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ]),
              //         ),
              //       ],
              //     ),
              //   ),
              // ],
            
