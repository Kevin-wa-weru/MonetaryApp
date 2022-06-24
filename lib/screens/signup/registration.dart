import 'package:billingapp/constants.dart';
import 'package:billingapp/models/user_hive.dart';
import 'package:billingapp/screens/signin/signin.dart';
import 'package:billingapp/services/hive.dart';
import 'package:billingapp/services/misc.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final paswordController = TextEditingController();
  final businessName = TextEditingController();
  final phoneNumber = TextEditingController();
  bool obsecurepassword = true;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 50,
        centerTitle: true,
        title: const Center(
          child: Text(
            'Sign Up',
            style: TextStyle(
                fontFamily: 'AvenirNext',
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              'Moneytari',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Color(0xFF54b8a9)),
            ),
          ),
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
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: 8,
                        width: 8,
                        child: SvgPicture.asset('assets/icons/smallperson.svg',
                            color: secondaryColorfaded,
                            height: 10,
                            fit: BoxFit.fitHeight),
                      ),
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
                    hintText: 'Business name',
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
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: 8,
                        width: 8,
                        child: SvgPicture.asset('assets/icons/phone.svg',
                            color: secondaryColorfaded,
                            height: 10,
                            fit: BoxFit.fitHeight),
                      ),
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
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.transparent, width: 0),
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: 8,
                        width: 8,
                        child: SvgPicture.asset('assets/icons/mail.svg',
                            color: secondaryColorfaded,
                            height: 10,
                            fit: BoxFit.fitHeight),
                      ),
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
                    hintText: 'Email',
                    hintStyle: const TextStyle(
                      fontFamily: 'AvenirNext',
                      fontWeight: FontWeight.w600,
                    )),
                onChanged: (value) {
                  setState(() {});
                },
                controller: emailController,
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
                obscureText: obsecurepassword,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: secondaryColor, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: 8,
                        width: 8,
                        child: SvgPicture.asset('assets/icons/key.svg',
                            height: 10, fit: BoxFit.fitHeight),
                      ),
                    ),
                    suffixIcon: BouncingWidget(
                      onPressed: () {
                        setState(() {
                          obsecurepassword = !obsecurepassword;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          height: 8,
                          width: 8,
                          child: obsecurepassword == false
                              ? SvgPicture.asset('assets/icons/eyehidden.svg',
                                  height: 10, fit: BoxFit.fitHeight)
                              : SvgPicture.asset('assets/icons/eye.svg',
                                  height: 10, fit: BoxFit.fitHeight),
                        ),
                      ),
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
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                      fontFamily: 'AvenirNext',
                      fontWeight: FontWeight.w600,
                    )),
                onChanged: (value) {
                  setState(() {});
                },
                controller: paswordController,
              ),
            ),
          ),
          BouncingWidget(
            onPressed: () async {
              if (businessName.text.isEmpty ||
                  phoneNumber.text.isEmpty ||
                  emailController.text.isEmpty ||
                  paswordController.text.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Complete the form",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: primaryThree,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else if (Misc.validateEmail(emailController.text) != null) {
                Fluttertoast.showToast(
                    msg: "Email provided is not valid",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: secondaryColor,
                    textColor: primaryColor,
                    fontSize: 16.0);
              } else if (Misc.validatePhoneNumber(phoneNumber.text) != null) {
                Fluttertoast.showToast(
                    msg: "Phone number provided is not valid",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: secondaryColor,
                    textColor: primaryColor,
                    fontSize: 16.0);
              } else {
                setState(() {
                  showSpinner = true;
                });
                try {
                  Firebase.initializeApp();
                  final auth = FirebaseAuth.instance;
                  final CollectionReference usersRef =
                      FirebaseFirestore.instance.collection("users");

                  final userid = await auth.createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: paswordController.text,
                  );

                  await usersRef.doc(userid.user!.uid).set({
                    'userid': userid.user!.uid,
                    'name': businessName.text,
                    'phone': phoneNumber.text,
                    'email': emailController.text.toString(),
                    'password': paswordController.text.toString(),
                  });

                  final userdetails = UserReg()
                    ..token = userid.user!.uid
                    ..name = phoneNumber.text
                    ..email = emailController.text
                    ..phone = phoneNumber.text;

                  final box = Boxes.getAccount();

                  if (box.isEmpty) {
                    box.add(userdetails);
                  } else {
                    box.putAt(0, userdetails);
                  }

                  Fluttertoast.showToast(
                      msg: "Successfully registered",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: primaryThree,
                      textColor: Colors.white,
                      fontSize: 16.0);

                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignIn()),
                  );
                } catch (e) {
                  if (e.toString().contains(
                      'The email address is already in use by another account.')) {
                    Fluttertoast.showToast(
                        msg: "Email is already used",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: primaryThree,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
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
                          'Sign Up',
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
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignIn()),
              );
            },
            child: const Center(
              child: Text(
                'Already have an account ? Log in',
                style: TextStyle(
                    color: primaryThree,
                    fontFamily: 'AvenirNext',
                    fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
    );
  }
}
