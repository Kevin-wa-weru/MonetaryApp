import 'package:billingapp/constants.dart';
import 'package:billingapp/services/firebaseserivices.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool appisLoading = false;
  String? name;
  String? phone;
  String? email;
  Future getUserDetails() async {
    setState(() {
      appisLoading = true;
    });
    var response = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseServices().getUserId())
        .get();

    setState(() {
      name = response.data()!['name'];
      phone = response.data()!['phone'];
      email = response.data()!['email'];
    });

    setState(() {
      appisLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appisLoading == false
            ? AppBar(
                leading: IconButton(
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
                ),
                leadingWidth: 50,
                centerTitle: false,
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
            ? ListView(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: BouncingWidget(
                      onPressed: () {},
                      child: Card(
                        elevation: 2,
                        color: cardyColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: SizedBox(
                          width: 80,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 45,
                                width: 45,
                                child: SvgPicture.asset(
                                  'assets/icons/person.svg',
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  Text(name.toString(),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'AvenirNext',
                                      )),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(email.toString(),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'AvenirNext',
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('0704122812',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'AvenirNext',
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  BouncingWidget(
                    onPressed: () {
                      Fluttertoast.showToast(
                          msg: "To be added",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: primaryThree,
                          textColor: Colors.white,
                          fontSize: 16.0);
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
                        child: const Center(
                          child: Text(
                            'Update Profile',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'AvenirNext',
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const Scaffold(
                body: Center(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: primaryThree,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ));
  }
}
