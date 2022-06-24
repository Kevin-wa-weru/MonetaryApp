import 'package:billingapp/keys.dart';
import 'package:billingapp/models/user_hive.dart';
import 'package:billingapp/screens/signin/signin.dart';
import 'package:billingapp/screens/signup/registration.dart';
import 'package:billingapp/services/hive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';

// FOREVER RELYING ON GOD

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserRegAdapter());
  await Hive.openBox<UserReg>('account');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    MpesaFlutterPlugin.setConsumerKey(kConsumerKey);
    MpesaFlutterPlugin.setConsumerSecret(kConsumerSecret);
    Firebase.initializeApp();
    final box = Boxes.getAccount();
    final account = box.values.toList().cast<UserReg>();
    // ignore: prefer_typing_uninitialized_variables
    late var usertoken;
    if (account.isEmpty) {
      usertoken = null;
    } else {
      usertoken = account[0].token;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: usertoken == null ? const SignUp() : const SignIn(),
    );
  }
}
