// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';

part 'user_hive.g.dart';

@HiveType(typeId: 0)
class UserReg extends HiveObject {
  @HiveField(1)
  late String token;
  @HiveField(2)
  late String name;
  @HiveField(3)
  late String email;
  @HiveField(4)
  late String phone;
}
