import 'package:billingapp/models/user_hive.dart';
import 'package:hive_flutter/adapters.dart';

class Boxes{
  static Box<UserReg> getAccount() => Hive.box('account');
}

