import 'package:billingapp/constants.dart';
import 'package:billingapp/screens/dashboard/homescreen.dart';
import 'package:billingapp/services/firebaseserivices.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:searchfield/searchfield.dart';

class SinglePayment extends StatefulWidget {
  const SinglePayment({
    Key? key,
    required this.docid,
  }) : super(key: key);
  final String docid;
  @override
  State<SinglePayment> createState() => _SinglePaymentState();
}

class _SinglePaymentState extends State<SinglePayment>
    with SingleTickerProviderStateMixin {
  bool showBillingContainer = false;
  String selectedValue = '.';
  List<SearchFieldListItem> options = [];

  String? name;
  String? phone;
  num? amount;
  String? paymentref;
  String? paymentcode;
  String? allocation;
  List<Map<dynamic, dynamic>> invoices = [];
  List<Map<dynamic, dynamic>> billers = [];

  bool appisLoading = false;
  bool showSpinner = false;

  Future getspecificPay() async {
    setState(() {
      appisLoading = true;
    });

    var response = await FirebaseFirestore.instance
        .collection("payments")
        .doc(widget.docid.replaceAll(" ", ""))
        .get();

    setState(() {
      name = response.data()!['name'];
      phone = response.data()!['phone'].toString();
      amount = response.data()!['amount'];
      paymentref = response.data()!['paymentref'];
      paymentcode = response.data()!['paymentcode'];
      allocation = response.data()!['allocation'];
    });

    setState(() {
      appisLoading = false;
    });
  }

  Future getAllocationItems() async {
    setState(() {
      appisLoading = true;
    });
    await getInvoices();
    await getBills();
    // ignore: prefer_typing_uninitialized_variables
    var invoice;
    // ignore: prefer_typing_uninitialized_variables, unused_local_variable
    var name;
    // ignore: prefer_typing_uninitialized_variables, unused_local_variable
    var billcode;

    for (invoice in billers) {
      setState(() {
        options
            .add(SearchFieldListItem('${invoice['invoicenumber']}->    Bill'));
        options.add(SearchFieldListItem('${invoice['name']}->     Bill'));
      });
    }

    // ignore: prefer_typing_uninitialized_variables
    var bill;
    // ignore: prefer_typing_uninitialized_variables, unused_local_variable
    var name2;
    // ignore: prefer_typing_uninitialized_variables, unused_local_variable
    var billcode2;

    for (bill in invoices) {
      setState(() {
        options.add(SearchFieldListItem('${bill['name']}->  Invoice'));
      });
    }

    setState(() {
      appisLoading = false;
    });
  }

  getInvoices() async {
    final CollectionReference invoiceRef =
        FirebaseFirestore.instance.collection("invoices");
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

  getBills() async {
    final CollectionReference billsRef =
        FirebaseFirestore.instance.collection("bills");
    // ignore: prefer_typing_uninitialized_variables
    var bill;
    var bills = await billsRef
        .where('userid', isEqualTo: FirebaseServices().getUserId())
        .get();
    var billss = bills.docs;

    setState(() {
      for (bill in billss) {
        billers.add(bill.data());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getspecificPay();
    getAllocationItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appisLoading == false
            ? AppBar(
                leading: showBillingContainer == false
                    ? IconButton(
                        icon: SizedBox(
                          height: 15,
                          width: 15,
                          child: SizedBox(
                            height: 15,
                            width: 15,
                            child: SvgPicture.asset('assets/icons/cancel.svg',
                                color: Colors.black54,
                                height: 10,
                                fit: BoxFit.fitHeight),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    : Container(),
                leadingWidth: 50,
                centerTitle: true,
                automaticallyImplyLeading: false,
                title: Text(
                  name.toString(),
                  style: const TextStyle(
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
                              height: 15,
                            ),
                            Text.rich(TextSpan(
                                text: 'Amount :  ksh ',
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: amount.toString(),
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
                                text: 'Paymet ref :  ',
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: paymentref,
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
                                text: 'Payment code :  ',
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <InlineSpan>[
                                  allocation == 'allocated'
                                      ? TextSpan(
                                          text: paymentcode,
                                          style: const TextStyle(
                                            color: primaryThree,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      : const TextSpan(
                                          text: 'Unallocated',
                                          style: TextStyle(
                                            color: Colors.red,
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
                allocation == 'unallocated'
                    ? Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Container(
                          width: 400,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: SearchField(
                              marginColor: primaryThree,
                              hint: 'Select invoice or bill to allocate',
                              searchInputDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: secondaryColor, width: 0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: secondaryColor, width: 0.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: primaryThree, width: 2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                filled: true,
                              ),
                              itemHeight: 50,
                              maxSuggestionsInViewPort: 4,
                              suggestionsDecoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              onSuggestionTap: (value) {
                                setState(() {
                                  selectedValue = value.searchKey;
                                });
                              },
                              suggestions: options),
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                BouncingWidget(
                  onPressed: () async {
                    if (selectedValue == '.') {
                      Fluttertoast.showToast(
                          msg: "Select an item from the given list to Allocate",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: primaryThree,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                    if (allocation == 'allocated') {
                      Fluttertoast.showToast(
                          msg: "Payment has already been allocated",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: primaryThree,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }

                    if (allocation == 'unallocated') {
                      // ALLOCATING PAYMENT TO BILLS
                      if (selectedValue.toString().contains('Bill')) {
                        setState(() {
                          showSpinner = true;
                        });
                        var searchbyInvoienumber = billers.where((element) =>
                            element['invoicenumber'] ==
                            selectedValue.substring(
                                0, selectedValue.indexOf('-')));
                        // ignore: prefer_typing_uninitialized_variables
                        var elementTwo;

                        if (searchbyInvoienumber.isNotEmpty) {
                          final CollectionReference billsRef =
                              FirebaseFirestore.instance.collection("bills");

                          final billidToAllocate = await billsRef
                              .where('invoicenumber',
                                  isEqualTo: selectedValue.substring(
                                      0, selectedValue.indexOf('-')))
                              .get();

                          int billAmount =
                              billidToAllocate.docs.first['amount'];

                          if (billAmount == 0) {
                            Fluttertoast.showToast(
                                msg: "That bill has been fully paid",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: primaryThree,
                                textColor: Colors.white,
                                fontSize: 16.0);

                            setState(() {
                              showSpinner = false;
                            });
                          } else {
                            final CollectionReference paysRef =
                                FirebaseFirestore.instance
                                    .collection("payments");

                            await paysRef.doc(widget.docid).update({
                              'paymentcode':
                                  searchbyInvoienumber.first['invoicenumber'],
                              'allocation': 'allocated',
                            });

                            final bilidToAllocate = await billsRef
                                .where('invoicenumber',
                                    isEqualTo: selectedValue.substring(
                                        0, selectedValue.indexOf('-')))
                                .get();

                            var bilid = bilidToAllocate.docs.first.id;

                            int bilAmont = bilidToAllocate.docs.first['amount'];

                            await billsRef.doc(bilid).update({
                              'amount': bilAmont - amount!,
                              'allocation': 'allocated',
                            });

                            final bdToAllocate = await billsRef
                                .where('invoicenumber',
                                    isEqualTo: selectedValue.substring(
                                        0, selectedValue.indexOf('-')))
                                .get();

                            var bid = bdToAllocate.docs.first.id;

                            int bAmont = bdToAllocate.docs.first['amount'];

                            if (bAmont < 1) {
                              await billsRef.doc(bid).update({'status': 2});
                            } else {
                              await billsRef.doc(bid).update({'status': 1});
                            }

                            setState(() {
                              showSpinner = false;
                            });

                            setState(() {
                              showBillingContainer = true;
                            });

                            setState(() {
                              allocation == 'unallocated';
                            });
                          }
                        } else {
                          // Search bills by name if by invoicenumber has not found anything
                          setState(() {
                            elementTwo = billers.where((element) =>
                                element['name'] ==
                                selectedValue.substring(
                                    0, selectedValue.indexOf('-')));
                          });

                          if (elementTwo.isNotEmpty) {
                            final CollectionReference billsRef =
                                FirebaseFirestore.instance.collection("bills");

                            final billidToAllocate = await billsRef
                                .where('name',
                                    isEqualTo: selectedValue.substring(
                                        0, selectedValue.indexOf('-')))
                                .get();

                            int billAmount =
                                billidToAllocate.docs.first['amount'];

                            if (billAmount == 0) {
                              setState(() {
                                showSpinner = false;
                              });
                              Fluttertoast.showToast(
                                  msg: "That bill has been fully paid",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: primaryThree,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              final CollectionReference paysRef =
                                  FirebaseFirestore.instance
                                      .collection("payments");

                              await paysRef.doc(widget.docid).update({
                                'paymentcode':
                                    elementTwo.first['invoicenumber'],
                                'allocation': 'allocated',
                              });

                              final bilidToAllocate = await billsRef
                                  .where('name',
                                      isEqualTo: selectedValue.substring(
                                          0, selectedValue.indexOf('-')))
                                  .get();

                              var bilid = bilidToAllocate.docs.first.id;

                              int bilAmont =
                                  bilidToAllocate.docs.first['amount'];

                              await billsRef.doc(bilid).update({
                                'amount': bilAmont - amount!,
                                'allocation': 'allocated',
                              });

                              final bidToAllocate = await billsRef
                                  .where('name',
                                      isEqualTo: selectedValue.substring(
                                          0, selectedValue.indexOf('-')))
                                  .get();

                              var bid = bidToAllocate.docs.first.id;

                              int bAmont = bidToAllocate.docs.first['amount'];

                              if (bAmont < 1) {
                                await billsRef.doc(bid).update({'status': 2});
                              } else {
                                await billsRef.doc(bid).update({'status': 1});
                              }

                              setState(() {
                                showSpinner = false;
                              });

                              setState(() {
                                showBillingContainer = true;
                              });

                              setState(() {
                                allocation == 'unallocated';
                              });
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "There was a problem in allocating the pay",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: primaryThree,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        }
                      }

                      //   ALLOCATING PAYMENT TO INVOICE

                      if (selectedValue.toString().contains('Invoice')) {
                        var allocateItemOne = invoices.where((element) =>
                            element['name'] ==
                            selectedValue.substring(
                                0, selectedValue.indexOf('-')));
                        // ignore: prefer_typing_uninitialized_variables

                        if (allocateItemOne.isNotEmpty) {
                          setState(() {
                            showSpinner = true;
                          });

                          final CollectionReference invoicesRef =
                              FirebaseFirestore.instance.collection("invoices");

                          final invoiceidToAllocate = await invoicesRef
                              .where('name',
                                  isEqualTo: selectedValue.substring(
                                      0, selectedValue.indexOf('-')))
                              .get();

                          var invoiceid = invoiceidToAllocate.docs.first.id;

                          int invoiceAmount =
                              invoiceidToAllocate.docs.first['amount'];

                          if (invoiceAmount == 0) {
                            Fluttertoast.showToast(
                                msg: "That invoice has been fully paid",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: primaryThree,
                                textColor: Colors.white,
                                fontSize: 16.0);

                            setState(() {
                              showSpinner = false;
                            });
                          } else {
                            final CollectionReference paysRef =
                                FirebaseFirestore.instance
                                    .collection("payments");

                            await paysRef.doc(widget.docid).update({
                              'paymentcode':
                                  '${allocateItemOne.first['name']} (Invoice)',
                              'allocation': 'allocated',
                            });
                            await invoicesRef.doc(invoiceid).update({
                              'amount': invoiceAmount - amount!,
                              'allocation': 'allocated',
                            });

                            final invoiceidToAllocate = await invoicesRef
                                .where('name',
                                    isEqualTo: selectedValue.substring(
                                        0, selectedValue.indexOf('-')))
                                .get();

                            var invid = invoiceidToAllocate.docs.first.id;

                            int invAmont =
                                invoiceidToAllocate.docs.first['amount'];

                            if (invAmont < 1) {
                              await invoicesRef
                                  .doc(invid)
                                  .update({'status': 2});
                            } else {
                              await invoicesRef
                                  .doc(invid)
                                  .update({'status': 1});
                            }

                            setState(() {
                              showSpinner = false;
                            });

                            setState(() {
                              showBillingContainer = true;
                            });

                            setState(() {
                              allocation == 'unallocated';
                            });
                          }
                        } else {
                          setState(() {
                            showSpinner = false;
                          });
                          Fluttertoast.showToast(
                              msg: "There was a problem in allocating the pay",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: primaryThree,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }
                    }
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
                      child: Center(
                        child: showSpinner == false
                            ? const Text(
                                'Allocate payment ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'AvenirNext',
                                    fontWeight: FontWeight.w600),
                              )
                            : const SizedBox(
                                height: 30.0,
                                width: 30.0,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                showBillingContainer == true
                    ? InkWell(
                        onTap: () {
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
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Center(
                              child: Text(
                                'Back to Dashboard',
                                style: TextStyle(
                                    color: primaryThree,
                                    fontFamily: 'AvenirNext',
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                showBillingContainer == true
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          const Center(
                              child: Text(
                            'Payment has been allocated ',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: primaryThree,
                                fontFamily: 'AvenirNext'),
                          )),
                          const SizedBox(
                            height: 16,
                          ),
                          Center(
                              child: SizedBox(
                            height: 50,
                            width: 50,
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: SvgPicture.asset('assets/icons/check.svg',
                                  color: primaryThree,
                                  height: 10,
                                  fit: BoxFit.fitHeight),
                            ),
                          )),
                        ],
                      )
                    : Container(),
              ])
            : const Center(
                child: CircularProgressIndicator(
                  color: primaryThree,
                  strokeWidth: 2,
                ),
              ));
  }
}
