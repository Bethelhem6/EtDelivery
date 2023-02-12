import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dboy_two/widgets.dart';
import 'package:flutter/material.dart';

class DeliveredPage extends StatefulWidget {
  const DeliveredPage({super.key});

  @override
  State<DeliveredPage> createState() => _DeliveredPageState();
}

class _DeliveredPageState extends State<DeliveredPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Delivered Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,elevation: 0,
        backgroundColor: const Color.fromARGB(255, 44, 90, 46),
      ),
      body: ListView(padding: const EdgeInsets.all(6), children: [
        deliveredCard("delivered orders"),
      ]),
    );
  }

  Widget deliveredCard(String collection) => StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection(collection).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DocumentSnapshot<Map<String, dynamic>>> documents =
              snapshot.data!.docs;

          return Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    height: 710,
                    child: ListView(
                        children: documents
                            .map((doc) => Card(
                                  shadowColor: Colors.red,
                                  elevation: 3,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(26, 29, 150, 18),
                                          Color.fromARGB(31, 17, 104, 29)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, '/');
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 5.0,
                                                      vertical: 0),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            13),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        doc['status'],
                                                        style: const TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                        RichTextWidget(
                                            text1: "Order Id: ",
                                            text2: doc["orderId"]),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        RichTextWidget(
                                            text1: "Order Placed On:",
                                            text2: doc["orderData"]),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        RichTextWidget(
                                            text1: "Payment Status: ",
                                            text2: doc["status"]),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        RichTextWidget(
                                          text1: "Total: ",
                                          text2:
                                              "Birr ${doc["TotalPricewithDelivery"]}",
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                            .toList()),
                  ),
                  const SizedBox(
                    height: 150,
                  )
                ],
              ));
        }
        return Container();
      });
}
