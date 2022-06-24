import 'package:billingapp/constants.dart';
import 'package:billingapp/screens/createbill/successfulbill.dart';
import 'package:billingapp/screens/dashboard/homescreen.dart';
import 'package:billingapp/screens/profile/profile.dart';
import 'package:billingapp/services/firebaseserivices.dart';
import 'package:billingapp/services/misc.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CreateBill extends StatefulWidget {
  const CreateBill({Key? key}) : super(key: key);

  @override
  State<CreateBill> createState() => _CreateBillState();
}

class _CreateBillState extends State<CreateBill> {
  int maxLines = 5;
  bool formisComplete = false;
  bool showSpinner = false;
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  final businessName = TextEditingController();
  final phoneNumber = TextEditingController();
  final billcode = TextEditingController();

  final List<String> items = [
    'Daily',
    'Monthly',
    'Anually',
    'BiWeekly',
  ];
  String? selectedValue;
  String selectedDate = '';
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
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
              width: width / 4,
            ),
            const Text(
              'Create Bill',
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
                    hintText: 'Mpesa phone number',
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
                        child: SvgPicture.asset('assets/icons/uniquenumber.svg',
                            height: 10, fit: BoxFit.fitHeight),
                      ),
                    ),
                    hintText: 'Unique Invoice Number',
                    hintStyle: const TextStyle(
                      fontFamily: 'AvenirNext',
                      fontWeight: FontWeight.w600,
                    )),
                onChanged: (value) {
                  setState(() {});
                },
                controller: billcode,
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
                    hintText: 'Bill amount..',
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
              padding: const EdgeInsets.only(
                  left: defaultPadding,
                  right: defaultPadding,
                  top: defaultPadding,
                  bottom: 8),
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
          const SizedBox(
            height: 4,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Center(
              child: Text(
                'Select the billing cycle and the date of the first bill',
                style: TextStyle(
                    color: secondaryColor,
                    fontSize: 12,
                    fontFamily: 'AvenirNext',
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Row(children: [
            const SizedBox(width: 15),
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                hint: Row(
                  children: const [
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        'Select Cycle',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: secondaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: items
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: secondaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;
                  });
                },
                icon: const Icon(
                  Icons.arrow_downward,
                ),
                iconSize: 14,
                iconEnabledColor: primaryThree,
                iconDisabledColor: Colors.grey,
                buttonHeight: 40,
                buttonWidth: 160,
                buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white,
                  ),
                  color: Colors.white,
                ),
                buttonElevation: 2,
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 14, right: 14),
                dropdownMaxHeight: 200,
                dropdownWidth: 200,
                dropdownPadding: null,
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                ),
                dropdownElevation: 8,
                scrollbarRadius: const Radius.circular(40),
                scrollbarThickness: 6,
                scrollbarAlwaysShow: true,
                offset: const Offset(-20, 0),
              ),
            ),
            const SizedBox(width: 10),
            BouncingWidget(
              onPressed: () {
                showDatePicker();
              },
              child: Card(
                elevation: 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SizedBox(
                  height: 40,
                  width: 150,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      selectedDate.isEmpty
                          ? const Text(
                              'Pick Date',
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600),
                            )
                          : Text(
                              '${DateTime.parse(selectedDate).toLocal().day.toString()}/${DateTime.parse(selectedDate).toLocal().month.toString()}/${DateTime.parse(selectedDate).toLocal().year.toString()}',
                              style: const TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'AvenirNext',
                                  fontWeight: FontWeight.w600),
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset(
                          'assets/icons/date.svg',
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  )),
                ),
              ),
            )
          ]),
          const SizedBox(height: 15),
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
                    backgroundColor: primaryThree,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else if (selectedDate.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Pick date",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: primaryThree,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else if (selectedValue == null) {
                Fluttertoast.showToast(
                    msg: "Pick billing cycle",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: primaryThree,
                    textColor: Colors.white,
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
                  final CollectionReference billRef =
                      FirebaseFirestore.instance.collection("bills");

                  var response = await billRef.add({
                    'name': businessName.text,
                    'phone': int.parse(phoneNumber.text),
                    'invoicenumber': billcode.text,
                    'amount': int.parse(amountController.text.toString()),
                    'description': descriptionController.text.toString(),
                    'cycle': selectedValue,
                    'status': 0,
                    'year':
                        DateTime.parse(selectedDate).toLocal().year.toString(),
                    'month':
                        DateFormat("MMMM").format(DateTime.now()).toString(),
                    'date':
                        '${DateTime.parse(selectedDate).toLocal().day.toString()}/${DateTime.parse(selectedDate).toLocal().month.toString()}/${DateTime.parse(selectedDate).toLocal().year.toString()}',
                    'userid': FirebaseServices().getUserId()
                  });

                  billRef.doc(response.id).update({'docid': response.id});

                  Fluttertoast.showToast(
                      msg: "Successfully created a bill",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: primaryThree,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SuccesfulBill(
                              billId: response.id,
                            )),
                  );

                  businessName.clear();
                  phoneNumber.clear();
                  billcode.clear();
                  amountController.clear();
                  descriptionController.clear();

                  setState(() {
                    showSpinner = false;
                  });
                } catch (e) {
                  // ignore: avoid_print
                  print(e);
                }
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
                          'Create Bill',
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
