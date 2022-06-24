// ignore_for_file: avoid_print

import 'package:billingapp/constants.dart';
import 'package:billingapp/screens/createinvoice/createinvoice.dart';
import 'package:billingapp/screens/dashboard/homescreen.dart';
import 'package:billingapp/screens/profile/profile.dart';
import 'package:billingapp/screens/viewinvoices/singleinvoice.dart';
import 'package:billingapp/services/firebaseserivices.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewInvoices extends StatefulWidget {
  const ViewInvoices({Key? key}) : super(key: key);

  @override
  State<ViewInvoices> createState() => _ViewInvoicesState();
}

class _ViewInvoicesState extends State<ViewInvoices> {
  final CollectionReference invoiceRef =
      FirebaseFirestore.instance.collection("invoices");

  String selectedDate = '';
  bool filter = false;
  bool foundFilteredBills = false;
  List<Map<dynamic, dynamic>> filterInvoices = [];
  List<Map<dynamic, dynamic>> invoices = [];

  List<dynamic> itemsData = [];

  List<Map<dynamic, dynamic>> filterCreatedBills(date) {
    List<Map<dynamic, dynamic>> results = [];

    if (date.isEmpty) {
      setState(() {});
      results = invoices;
    } else {
      results = invoices.where((element) => element['date'] == date).toList();
      print(results);
    }
    setState(() {
      filterInvoices = results;
    });
    return results;
  }

  getInvoices() async {
    // ignore: prefer_typing_uninitialized_variables
    var invoice;
    var invoiced = await invoiceRef
        .where('userid', isEqualTo: FirebaseServices().getUserId())
        .get();
    var invoicess = invoiced.docs;

    setState(() {
      for (invoice in invoicess) {
        invoices.add(invoice.data());
      }
    });
  }

  @override
  void initState() {
    filterInvoices = invoices;
    getInvoices();
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
              width: width / 5,
            ),
            const Text(
              'View Invoices',
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
      body: invoices.isNotEmpty
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
                        width: foundFilteredBills == false
                            ? width * 0.24
                            : width * 0.19,
                      ),
                      foundFilteredBills == true
                          ? BouncingWidget(
                              onPressed: () {
                                setState(() {
                                  foundFilteredBills = false;
                                  filterInvoices = invoices;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(18)),
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
                                        height: 10,
                                        width: 10,
                                        child: SvgPicture.asset(
                                          'assets/icons/eye.svg',
                                          color: successcolor,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      const Text(
                                        'All bills',
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
                            )
                          : Container(),
                      const SizedBox(
                        width: 10,
                      ),
                      BouncingWidget(
                        onPressed: () {
                          showDatePicker();
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
                                selectedDate.isEmpty
                                    ? const Text(
                                        'Pick Date',
                                        style: TextStyle(
                                            fontSize: 8,
                                            color: secondaryColor,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    : Text(
                                        '${DateTime.parse(selectedDate).toLocal().day.toString()}/${DateTime.parse(selectedDate).toLocal().month.toString()}/${DateTime.parse(selectedDate).toLocal().year.toString()}',
                                        style: const TextStyle(
                                            color: secondaryColor,
                                            fontFamily: 'AvenirNext',
                                            fontSize: 8,
                                            fontWeight: FontWeight.w900),
                                      ),
                                const SizedBox(
                                  width: 4,
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
                          if (selectedDate.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Select a date to filter",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: primaryColor,
                                textColor: altColor,
                                fontSize: 16.0);
                          } else {
                            setState(() {
                              filter = true;
                              var response = filterCreatedBills(
                                  '${DateTime.parse(selectedDate).toLocal().day.toString()}/${DateTime.parse(selectedDate).toLocal().month.toString()}/${DateTime.parse(selectedDate).toLocal().year.toString()}');
                              if (response.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "No bills exist for that date ",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: primaryColor,
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
                                  height: 10,
                                  width: 10,
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
                  height: 10,
                ),
                Expanded(
                    child: filterInvoices.isNotEmpty
                        ? ListView.builder(
                            itemCount: filterInvoices.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SingleInvoices(
                                              docid: filterInvoices[index]
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                                filterInvoices[index]['name']
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
                                            Container(
                                              // color: Colors.red,
                                              color: Colors.white,
                                              width: 100,
                                              child: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Container(
                                                    color: Colors.white,
                                                    width: 100,
                                                    child: Text(
                                                      filterInvoices[index]
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
                                                  Container(
                                                    color: Colors.white,
                                                    width: 100,
                                                    child: Text(
                                                      filterInvoices[index]
                                                          ['phone'],
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
                                                    child: Container(
                                                      color: Colors.white,
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
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: Text(
                                                                '+ KSH.${filterInvoices[index]['amount'].toString()}',
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
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          SizedBox(
                                                            width: 300,
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: Text(
                                                                '${DateTime.parse(
                                                                  filterInvoices[
                                                                          index]
                                                                      [
                                                                      'dateadded'],
                                                                ).toLocal().day.toString()}/${DateTime.parse(
                                                                  filterInvoices[
                                                                          index]
                                                                      [
                                                                      'dateadded'],
                                                                ).toLocal().month.toString()}/${DateTime.parse(
                                                                  filterInvoices[
                                                                          index]
                                                                      [
                                                                      'dateadded'],
                                                                ).toLocal().year.toString()}',
                                                                style: const TextStyle(
                                                                    color:
                                                                        secondaryColorfaded,
                                                                    fontFamily:
                                                                        'AvenirNext',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        10),
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
                            itemCount: invoices.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SingleInvoices(
                                              docid: invoices[index]['docid'],
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                                invoices[index]['name']
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
                                            Container(
                                              // color: Colors.red,
                                              color: Colors.white,
                                              width: 100,
                                              child: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Container(
                                                    color: Colors.white,
                                                    width: 100,
                                                    child: Text(
                                                      invoices[index]['name'],
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
                                                  Container(
                                                    color: Colors.white,
                                                    width: 100,
                                                    child: Text(
                                                      invoices[index]['phone'],
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
                                                    child: Container(
                                                      color: Colors.white,
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
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: Text(
                                                                '+ KSH.${invoices[index]['amount'].toString()}',
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
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          SizedBox(
                                                            width: 300,
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: Text(
                                                                invoices[index]
                                                                    ['date'],
                                                                style: const TextStyle(
                                                                    color:
                                                                        secondaryColorfaded,
                                                                    fontFamily:
                                                                        'AvenirNext',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        10),
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
                            }))
              ],
            )
          : Center(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3.6,
                  ),
                  const Text(
                    'Empty invoices',
                    style: TextStyle(
                        fontFamily: 'AvenirNext',
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateInvoice()),
                      );
                    },
                    child: const Text(
                      'Create a new invoice',
                      style: TextStyle(
                          fontFamily: 'AvenirNext',
                          fontSize: 15,
                          color: primaryThree,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void showDatePicker() {
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
                if (value != null && value != selectedDate) {
                  setState(() {
                    selectedDate = value.toString();
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
