library consent;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'consent.g.dart';

abstract class ConsentResult
    implements Built<ConsentResult, ConsentResultBuilder> {
  BuiltList<ConsentResults> get data;

  ConsentResult._();
  factory ConsentResult([updates(ConsentResultBuilder consentResultBuilder)]) =
      _$ConsentResult;
  static Serializer<ConsentResult> get serializer => _$consentResultSerializer;
}

abstract class ConsentResults
    implements Built<ConsentResults, ConsentResultsBuilder> {
  int get id;

  @BuiltValueField(wireName: 'requestor_id')
  String get requestorId;

  @BuiltValueField(wireName: 'requestor_name')
  String get requestorName;

  @BuiltValueField(wireName: 'grantor_id')
  String get grantorId;

  @BuiltValueField(wireName: 'grantor_name')
  String get grantorName;

  String get permission;

  String get status;

  @BuiltValueField(wireName: 'created_at')
  String get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  String get updatedAt;

  ConsentResults._();
  factory ConsentResults(
          [updates(ConsentResultsBuilder consentResultsBuilder)]) =
      _$ConsentResults;
  static Serializer<ConsentResults> get serializer =>
      _$consentResultsSerializer;
}
