// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logged_in_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoggedInModelAdapter extends TypeAdapter<LoggedInModel> {
  @override
  final typeId = 2;

  @override
  LoggedInModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoggedInModel(identifier: fields[0] as String);
  }

  @override
  void write(BinaryWriter writer, LoggedInModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.identifier);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoggedInModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
