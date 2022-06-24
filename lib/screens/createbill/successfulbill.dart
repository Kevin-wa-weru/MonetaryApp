import 'package:billingapp/constants.dart';
import 'package:billingapp/screens/dashboard/homescreen.dart';
import 'package:billingapp/services/firebaseserivices.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class SuccesfulBill extends StatefulWidget {
  const SuccesfulBill({Key? key, required this.billId}) : super(key: key);
  final String billId;
  @override
  State<SuccesfulBill> createState() => _SuccesfulBillState();
}

class _SuccesfulBillState extends State<SuccesfulBill>
    with SingleTickerProviderStateMixin {
  FirebaseServices firebaseServices = FirebaseServices();
  String? name;
  String? phone;
  String? invoicenumber;
  num? amount;
  String? description;
  String? cycle;
  String? date;
  bool appisLoading = false;
  Future getspecificBill() async {
    // ignore: avoid_print
    print(widget.billId);
    setState(() {
      appisLoading = true;
    });
    //  await FirebaseFirestore.instance.collection("invoices").where('userid', isEqualTo: FirebaseServices().getUserId()).get().then((value) => null);
    var response = await FirebaseFirestore.instance
        .collection("bills")
        .doc(widget.billId)
        .get();

    setState(() {
      name = response.data()!['name'];
      phone = response.data()!['phone'].toString();
      invoicenumber = response.data()!['invoicenumber'];
      amount = response.data()!['amount'];
      description = response.data()!['description'];
      cycle = response.data()!['cycle'];
      date = response.data()!['date'];
    });

    setState(() {
      appisLoading = false;
    });
  }

  @override
  void initState() {
    getspecificBill();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appisLoading == false
            ? AppBar(
                // leading: IconButton(
                //   icon: SizedBox(
                //     height: 15,
                //     width: 15,
                //     child: SizedBox(
                //       height: 15,
                //       width: 15,
                //       child: SvgPicture.asset('assets/icons/cancel.svg',
                //           color: Colors.black,
                //           height: 10,
                //           fit: BoxFit.fitHeight),
                //     ),
                //   ),
                //   onPressed: () => Navigator.of(context).pop(),
                // ),
                leadingWidth: 50,
                centerTitle: true,
                automaticallyImplyLeading: false,
                title: const Text(
                  'Succesfully Billed',
                  style: TextStyle(
                      fontFamily: 'AvenirNext',
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
              )
            : AppBar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
        body: appisLoading == false
            ? ListView(children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BouncingWidget(
                    onPressed: () {},
                    child: Card(
                      elevation: 2,
                      color: cardyColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SizedBox(
                        width: 200,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                                child: SizedBox(
                              height: 50,
                              width: 50,
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: SvgPicture.asset(
                                    'assets/icons/check.svg',
                                    color: primaryThree,
                                    height: 10,
                                    fit: BoxFit.fitHeight),
                              ),
                            )),
                            const SizedBox(
                              height: 15,
                            ),
                            Text.rich(TextSpan(
                                text: 'Name :  ',
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: name,
                                    style: const TextStyle(
                                      color: secondaryColor,
                                      fontFamily: 'AvenirNext',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ])),
                            const SizedBox(
                              height: 15,
                            ),
                            Text.rich(TextSpan(
                                text: 'Phone :  ',
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: phone,
                                    style: const TextStyle(
                                      color: secondaryColor,
                                      fontFamily: 'AvenirNext',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ])),
                            const SizedBox(
                              height: 15,
                            ),
                            Text.rich(TextSpan(
                                text: 'Description :  ',
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: description,
                                    style: const TextStyle(
                                      color: secondaryColor,
                                      fontFamily: 'AvenirNext',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ])),
                            const SizedBox(
                              height: 15,
                            ),
                            Text.rich(TextSpan(
                                text: 'Bill code :  ',
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: invoicenumber,
                                    style: const TextStyle(
                                      color: secondaryColor,
                                      fontFamily: 'AvenirNext',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ])),
                            const SizedBox(
                              height: 15,
                            ),
                            Text.rich(TextSpan(
                                text: 'Amount :  ',
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: 'Ksh ${amount.toString()}',
                                    style: const TextStyle(
                                      color: secondaryColor,
                                      fontFamily: 'AvenirNext',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ])),
                            const SizedBox(
                              height: 15,
                            ),
                            Text.rich(TextSpan(
                                text: 'Bill type :  ',
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: cycle,
                                    style: const TextStyle(
                                      color: secondaryColor,
                                      fontFamily: 'AvenirNext',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ])),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                BouncingWidget(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Dashboard()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      width: 400,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: primaryThree,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: const Center(
                        child: Text(
                          'Back to Dashboard',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ])
            : const Center(
                child: CircularProgressIndicator(
                  color: primaryThree,
                  strokeWidth: 2,
                ),
              ));
  }
}
