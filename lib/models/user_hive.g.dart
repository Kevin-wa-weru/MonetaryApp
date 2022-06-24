// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserRegAdapter extends TypeAdapter<UserReg> {
  @override
  final int typeId = 0;

  @override
  UserReg read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserReg()
      ..token = fields[1] as String
      ..name = fields[2] as String
      ..email = fields[3] as String
      ..phone = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, UserReg obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.token)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRegAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
