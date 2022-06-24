import 'package:billingapp/constants.dart';
import 'package:billingapp/screens/dashboard/homescreen.dart';
import 'package:billingapp/screens/profile/profile.dart';
import 'package:billingapp/screens/viewpayments/singlepayment.dart';
import 'package:billingapp/services/firebaseserivices.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Pay extends StatefulWidget {
  const Pay({Key? key}) : super(key: key);

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  String? phone;
  String fromDate = '';
  String todate = '';
  bool filter = false;
  bool foundFilteredBills = false;
  bool appisLoading = false;
  List<Map<dynamic, dynamic>> filterPayments = [];
  List<Map<dynamic, dynamic>> pay = [];

  List<Map<dynamic, dynamic>> filterCreatedBills(fromdate, todate) {
    List<Map<dynamic, dynamic>> results = [];

    if (fromdate.isEmpty && todate.isEmpty) {
      setState(() {});
      results = pay;
    } else {
      // ignore: avoid_print
      print(fromdate);
      // ignore: avoid_print
      print(todate);
      for (var i = 0; i < pay.length; i += 1) {
        var date = (pay[i]['date']);

        // ignore: avoid_print
        print('Hello, this is date');
        // ignore: avoid_print
        print(date);

        if (date.compareTo(fromdate) >= 0 && date.compareTo(todate) <= 0) {
          results.add(pay[i]);
        }
      }
    }
    setState(() {
      filterPayments = results;
    });

    return results;
  }

  getPayments() async {
    final CollectionReference paysRef =
        FirebaseFirestore.instance.collection("payments");
    // ignore: prefer_typing_uninitialized_variables
    var payment;
    var payments = await paysRef
        .where('userid', isEqualTo: FirebaseServices().getUserId())
        .get();
    var paymentss = payments.docs;

    setState(() {
      for (payment in paymentss) {
        pay.add(payment.data());
      }
    });
  }

  @override
  void initState() {
    filterPayments = pay;
    getPayments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            BouncingWidget(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              },
              child: SizedBox(
                height: 35,
                width: 35,
                child: SvgPicture.asset(
                  'assets/icons/person.svg',
                ),
              ),
            ),
            SizedBox(
              width: width / 5.6,
            ),
            const Text(
              'View payments',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'AvenirNext',
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: <Widget>[
          PopupMenuButton(
            elevation: 2,
            icon: SizedBox(
              height: 25,
              width: 25,
              child: SvgPicture.asset(
                'assets/icons/threedots.svg',
                color: Colors.black,
              ),
            ),
            itemBuilder: (ctx) => [
              buildPopupMenuItem(context, 'Logout'),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: pay.isNotEmpty
          ? Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.17,
                      ),
                      BouncingWidget(
                        onPressed: () {
                          showfromDatePicker();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(18)),
                              border: Border.all(
                                  color: secondaryColorfaded, width: 3)),
                          child: SizedBox(
                            height: 25,
                            child: Center(
                                child: Row(
                              children: [
                                const SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: SvgPicture.asset(
                                    'assets/icons/date.svg',
                                    color: successcolor,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                fromDate.isEmpty
                                    ? const Text(
                                        'From Date',
                                        style: TextStyle(
                                            fontSize: 8,
                                            color: secondaryColor,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    : Text(
                                        '${DateTime.parse(fromDate).toLocal().day.toString()}/${DateTime.parse(fromDate).toLocal().month.toString()}/${DateTime.parse(fromDate).toLocal().year.toString()}',
                                        style: const TextStyle(
                                            color: secondaryColor,
                                            fontFamily: 'AvenirNext',
                                            fontSize: 8,
                                            fontWeight: FontWeight.w900),
                                      ),
                                const SizedBox(
                                  width: 8,
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      BouncingWidget(
                        onPressed: () {
                          showtoDatePicker();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(18)),
                              border: Border.all(
                                  color: secondaryColorfaded, width: 3)),
                          child: SizedBox(
                            height: 25,
                            child: Center(
                                child: Row(
                              children: [
                                const SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: SvgPicture.asset(
                                    'assets/icons/date.svg',
                                    color: successcolor,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                todate.isEmpty
                                    ? const Text(
                                        'To Date',
                                        style: TextStyle(
                                            fontSize: 8,
                                            color: secondaryColor,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    : Text(
                                        '${DateTime.parse(todate).toLocal().day.toString()}/${DateTime.parse(todate).toLocal().month.toString()}/${DateTime.parse(todate).toLocal().year.toString()}',
                                        style: const TextStyle(
                                            color: secondaryColor,
                                            fontFamily: 'AvenirNext',
                                            fontSize: 8,
                                            fontWeight: FontWeight.w600),
                                      ),
                                const SizedBox(
                                  width: 8,
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      BouncingWidget(
                        onPressed: () {
                          if (fromDate.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Select from date",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.white,
                                textColor: altColor,
                                fontSize: 16.0);
                          } else if (todate.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Select to date",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.white,
                                textColor: altColor,
                                fontSize: 16.0);
                          } else {
                            setState(() {
                              filter = true;
                              var response = filterCreatedBills(
                                  '${DateTime.parse(fromDate).toLocal().day.toString()}/${DateTime.parse(fromDate).toLocal().month.toString()}/${DateTime.parse(fromDate).toLocal().year.toString()}',
                                  '${DateTime.parse(todate).toLocal().day.toString()}/${DateTime.parse(todate).toLocal().month.toString()}/${DateTime.parse(todate).toLocal().year.toString()}');
                              if (response.isEmpty) {
                                Fluttertoast.showToast(
                                    msg:
                                        "No payments exist for that date range",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.white,
                                    textColor: altColor,
                                    fontSize: 16.0);
                              } else {
                                setState(() {
                                  foundFilteredBills = true;
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(18)),
                              border: Border.all(
                                  color: secondaryColorfaded, width: 3)),
                          child: SizedBox(
                            height: 25,
                            child: Center(
                                child: Row(
                              children: [
                                const SizedBox(
                                  width: 4,
                                ),
                                SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: SvgPicture.asset(
                                    'assets/icons/filter.svg',
                                    color: successcolor,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  'Filter',
                                  style: TextStyle(
                                      fontSize: 8,
                                      color: secondaryColor,
                                      fontFamily: 'AvenirNext',
                                      fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: filterPayments.isNotEmpty
                      ? ListView.builder(
                          itemCount: filterPayments.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SinglePayment(
                                            docid: filterPayments[index]
                                                ['docid'],
                                          )),
                                );
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 14.0, right: 16),
                                    child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Container(
                                            height: 38,
                                            width: 38,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color: primaryColoryfaded,
                                            ),
                                            child: Center(
                                                child: Text(
                                              filterPayments[index]['name']
                                                  .substring(0, 2),
                                              style: const TextStyle(
                                                  color: secondaryColor,
                                                  fontFamily: 'AvenirNext',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                            )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            // color: Colors.red,
                                            width: 100,
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    filterPayments[index]
                                                        ['name'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: secondaryColor,
                                                        fontFamily:
                                                            'AvenirNext',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    filterPayments[index]
                                                        ['name'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color:
                                                            secondaryColorfaded,
                                                        fontFamily:
                                                            'AvenirNext',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: SizedBox(
                                                    height: 50,
                                                    width: 300,
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        SizedBox(
                                                          width: 300,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Text(
                                                              '+ KSH.${filterPayments[index]['amount'].toString()}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  color:
                                                                      secondaryColor,
                                                                  fontFamily:
                                                                      'AvenirNext',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 15),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        SizedBox(
                                                          width: 300,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Text(
                                                              filterPayments[
                                                                      index]
                                                                  ['date'],
                                                              style: const TextStyle(
                                                                  color:
                                                                      secondaryColorfaded,
                                                                  fontFamily:
                                                                      'AvenirNext',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 10),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ))),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            );
                          })
                      : ListView.builder(
                          itemCount: pay.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => SinglePayment(
                                //             amount: createdpaymnets[index].amount,
                                //             name: createdpaymnets[index].name,
                                //             paymentstatus:
                                //                 createdpaymnets[index].paymentstatus,
                                //             payref: createdpaymnets[index].paymentref,
                                //             phoneNumber: createdpaymnets[index].phone,
                                //           )),
                                // );
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 14.0, right: 16),
                                    child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Container(
                                            height: 38,
                                            width: 38,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color: primaryColoryfaded,
                                            ),
                                            child: Center(
                                                child: Text(
                                              pay[index]['name']
                                                  .substring(0, 2),
                                              style: const TextStyle(
                                                  color: secondaryColor,
                                                  fontFamily: 'AvenirNext',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                            )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            // color: Colors.red,
                                            width: 100,
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    pay[index]['name'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: secondaryColor,
                                                        fontFamily:
                                                            'AvenirNext',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    pay[index]['phone'],
                                                    style: const TextStyle(
                                                        color:
                                                            secondaryColorfaded,
                                                        fontFamily:
                                                            'AvenirNext',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: SizedBox(
                                                    height: 50,
                                                    width: 300,
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        SizedBox(
                                                          width: 300,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Text(
                                                              '+ KSH.${pay[index]['amount'].toString()}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  color:
                                                                      secondaryColor,
                                                                  fontFamily:
                                                                      'AvenirNext',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 15),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        SizedBox(
                                                          width: 300,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Text(
                                                              pay[index]
                                                                  ['date'],
                                                              style: const TextStyle(
                                                                  color:
                                                                      secondaryColorfaded,
                                                                  fontFamily:
                                                                      'AvenirNext',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 10),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ))),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            );
                          }),
                ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: BouncingWidget(
                //     onPressed: () {},
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //       child: Container(
                //         width: 150,
                //         height: 30,
                //         decoration: const BoxDecoration(
                //           color: secondaryColor,
                //           borderRadius: BorderRadius.all(Radius.circular(10)),
                //         ),
                //         child: const Center(
                //           child: Text(
                //             'Download payments',
                //             style: TextStyle(
                //                 color: Colors.white,
                //                 fontFamily: 'AvenirNext',
                //                 fontWeight: FontWeight.w600),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            )
          : Center(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3.6,
                  ),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: SvgPicture.asset(
                      'assets/images/empty.svg',
                      color: primaryThree,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'No payment has been processed',
                    style: TextStyle(
                        fontFamily: 'AvenirNext',
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
    );
  }

  void showtoDatePicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                // ignore: unrelated_type_equality_checks, unnecessary_null_comparison
                if (value != null && value != todate) {
                  setState(() {
                    todate = value.toString();
                  });
                }
              },
              initialDateTime: DateTime.now(),
              minimumYear: 2019,
              maximumYear: 2026,
            ),
          );
        });
  }

  void showfromDatePicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                // ignore: unrelated_type_equality_checks, unnecessary_null_comparison
                if (value != null && value != fromDate) {
                  setState(() {
                    fromDate = value.toString();
                  });
                }
              },
              initialDateTime: DateTime.now(),
              minimumYear: 2019,
              maximumYear: 2026,
            ),
          );
        });
  }
}
