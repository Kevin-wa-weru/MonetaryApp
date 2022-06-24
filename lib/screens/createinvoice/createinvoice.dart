import 'package:billingapp/constants.dart';
import 'package:billingapp/screens/createinvoice/succesfulinvoice.dart';
import 'package:billingapp/screens/dashboard/homescreen.dart';
import 'package:billingapp/screens/profile/profile.dart';
import 'package:billingapp/services/firebaseserivices.dart';
import 'package:billingapp/services/misc.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CreateInvoice extends StatefulWidget {
  const CreateInvoice({Key? key}) : super(key: key);

  @override
  State<CreateInvoice> createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  int maxLines = 5;
  bool formisComplete = false;
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  final businessName = TextEditingController();
  final phoneNumber = TextEditingController();
  bool showSpinner = false;
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
              width: width / 6,
            ),
            const Text(
              'Create Invoice',
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
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: TextFormField(
                style: const TextStyle(
                    fontFamily: 'AvenirNext', fontWeight: FontWeight.w600),
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.transparent, width: 0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: secondaryColor, width: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: primaryThree, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    filled: true,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: 8,
                        width: 8,
                        child: SvgPicture.asset('assets/icons/smallperson.svg',
                            height: 10, fit: BoxFit.fitHeight),
                      ),
                    ),
                    hintText: 'Clients name',
                    hintStyle: const TextStyle(
                      fontFamily: 'AvenirNext',
                      fontWeight: FontWeight.w600,
                    )),
                onChanged: (value) {
                  setState(() {});
                },
                controller: businessName,
              ),
            ),
          ),
          SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: TextFormField(
                style: const TextStyle(
                    fontFamily: 'AvenirNext', fontWeight: FontWeight.w600),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.transparent, width: 0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: secondaryColor, width: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: primaryThree, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    filled: true,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: 8,
                        width: 8,
                        child: SvgPicture.asset('assets/icons/phone.svg',
                            height: 10, fit: BoxFit.fitHeight),
                      ),
                    ),
                    hintText: 'Phone number',
                    hintStyle: const TextStyle(
                      fontFamily: 'AvenirNext',
                      fontWeight: FontWeight.w600,
                    )),
                onChanged: (value) {
                  setState(() {});
                },
                controller: phoneNumber,
              ),
            ),
          ),
          SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: TextFormField(
                style: const TextStyle(
                    fontFamily: 'AvenirNext', fontWeight: FontWeight.w600),
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: 8,
                        width: 8,
                        child: SvgPicture.asset('assets/icons/amount.svg',
                            height: 10, fit: BoxFit.fitHeight),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: secondaryColor, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: secondaryColor, width: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: primaryThree, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    filled: true,
                    hintText: 'Amount',
                    hintStyle: const TextStyle(
                      fontFamily: 'AvenirNext',
                      fontWeight: FontWeight.w600,
                    )),
                onChanged: (value) {
                  setState(() {});
                },
                controller: amountController,
              ),
            ),
          ),
          SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: SizedBox(
                height: maxLines * 24.0,
                child: TextFormField(
                  maxLines: maxLines,
                  style: const TextStyle(
                      fontFamily: 'AvenirNext', fontWeight: FontWeight.w600),
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: secondaryColor, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: secondaryColor, width: 0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: primaryThree, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      filled: true,
                      hintText: 'Description',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          height: 8,
                          width: 8,
                          child: SvgPicture.asset(
                              'assets/icons/description.svg',
                              height: 10,
                              fit: BoxFit.fitHeight),
                        ),
                      ),
                      hintStyle: const TextStyle(
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      )),
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: descriptionController,
                ),
              ),
            ),
          ),
          BouncingWidget(
            onPressed: () async {
              if (businessName.text.isEmpty ||
                  phoneNumber.text.isEmpty ||
                  descriptionController.text.isEmpty ||
                  amountController.text.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Complete the form",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: primaryThree,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else if (Misc.validatePhoneNumber(phoneNumber.text) != null) {
                Fluttertoast.showToast(
                    msg: "Phone number provided is not valid",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: cardyColor,
                    textColor: primaryThree,
                    fontSize: 16.0);
              } else {
                setState(() {
                  formisComplete == true;
                });
                setState(() {
                  showSpinner = true;
                });
                try {
                  Firebase.initializeApp();
                  final CollectionReference invoiceRef =
                      FirebaseFirestore.instance.collection("invoices");

                  var response = await invoiceRef.add({
                    'name': businessName.text,
                    'phone': phoneNumber.text,
                    'amount': int.parse(amountController.text.toString()),
                    'description': descriptionController.text.toString(),
                    'userid': FirebaseServices().getUserId(),
                    'dateadded': DateTime.now().toString(),
                    'status': 0,
                    'date':
                        '${DateTime.now().day}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}',
                    'year': DateTime.parse(DateTime.now().toString())
                        .toLocal()
                        .year
                        .toString(),
                    'month':
                        DateFormat("MMMM").format(DateTime.now()).toString(),
                  });

                  invoiceRef.doc(response.id).update({'docid': response.id});

                  Fluttertoast.showToast(
                      msg: "Successfully created invoice",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: primaryThree,
                      textColor: Colors.white,
                      fontSize: 16.0);

                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SuccefulInvoice(invoiceId: response.id)),
                  );

                  businessName.clear();
                  phoneNumber.clear();
                  amountController.clear();
                  descriptionController.clear();
                } catch (e) {
                  // ignore: avoid_print
                  print(e);
                }

                setState(() {
                  showSpinner = false;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                          'Create Invoice',
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
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
