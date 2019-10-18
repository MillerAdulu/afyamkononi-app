library medical_data;

import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';

part 'medical_data.g.dart';

abstract class MedicalData implements Built<MedicalData, MedicalDataBuilder> {
  BuiltList<MedicalRecords> get data;

  MedicalData._();
  factory MedicalData([updates(MedicalDataBuilder medicalDataBuilder)]) =
      _$MedicalData;
  static Serializer<MedicalData> get serializer => _$medicalDataSerializer;
}

abstract class MedicalRecords
    implements Built<MedicalRecords, MedicalRecordsBuilder> {
  String get author;

  int get timestamp;

  String get symptoms;

  String get diagnosis;

  @BuiltValueField(wireName: 'treatment_plan')
  String get treatmentPlan;

  @BuiltValueField(wireName: 'seen_by')
  String get seenBy;

  MedicalRecords._();
  factory MedicalRecords(
          [updates(MedicalRecordsBuilder medicalRecordsBuilder)]) =
      _$MedicalRecords;
  static Serializer<MedicalRecords> get serializer =>
      _$medicalRecordsSerializer;
}
