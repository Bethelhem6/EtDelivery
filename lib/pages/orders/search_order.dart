import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dboy_two/pages/orders/order_details.dart';
import 'package:dboy_two/pages/orders/orders_detail_widget.dart';
import 'package:dboy_two/pages/ppages/home_page.dart';

import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String> {
  CollectionReference ref =
      FirebaseFirestore.instance.collection("processing orders");

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
    // throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, query);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: ref.snapshots().asBroadcastStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if ((snapshot.data!.docs
              .where((QueryDocumentSnapshot<Object?> element) => element['name']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .isEmpty)) {
            return const Center(
              child: Text("No query found!"),
            );
            // }
          } else if (snapshot.hasData) {
            return ListView(
              children: [
                ...snapshot.data!.docs
                    .where((QueryDocumentSnapshot<Object?> element) =>
                        element['name']
                            .toString()
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                    .map(
                  (QueryDocumentSnapshot<Object?> data) {
                    final String name = data.get('name');
                    final String orderId = data.get('orderId');

                    return Card(
                      shadowColor: Colors.red,
                      elevation: 3,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(26, 252, 244, 244),
                              Color.fromARGB(31, 248, 243, 243)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 0),
                                    child: Container(
                                      padding: const EdgeInsets.all(13),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: Text(
                                          data['status'],
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 146, 93, 91),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "OrderId: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text: data['orderId'],
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Ordere Placed On: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text: data['orderData'],
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Address: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text: data["delivery information"]['city'],
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Payment Status: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text: data['status'],
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.pinkAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Total: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "Birr ${data['TotalPricewithDelivery']}"
                                            .toString(),
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.pinkAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderDetailsPage(
                                                      collection:
                                                          "processing orders",
                                                      orderId: orderId)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 0),
                                      child: Container(
                                        padding: const EdgeInsets.all(13),
                                        decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 82, 131, 84),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Details',
                                            style: TextStyle(
                                              color: Colors.white,
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
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("No query found!"),
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text(" search here"),
    );
  }
}
