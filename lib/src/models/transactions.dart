library transactions;

import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';

part 'transactions.g.dart';

abstract class TransactionParent
    implements Built<TransactionParent, TransactionParentBuilder> {
  TransactionData get data;

  TransactionParent._();
  factory TransactionParent(
          [updates(TransactionParentBuilder transactionParentBuilder)]) =
      _$TransactionParent;
  static Serializer<TransactionParent> get serializer =>
      _$transactionParentSerializer;
}

abstract class TransactionData
    implements Built<TransactionData, TransactionDataBuilder> {
  @BuiltValueField(wireName: 'query_hash')
  String get queryHash;

  @BuiltValueField(wireName: 'transactions_page_response')
  TransactionsPageResponse get transactionsPageResponse;

  TransactionData._();
  factory TransactionData(
          [updates(TransactionDataBuilder transactionDataBuilder)]) =
      _$TransactionData;
  static Serializer<TransactionData> get serializer =>
      _$transactionDataSerializer;
}

abstract class TransactionsPageResponse
    implements
        Built<TransactionsPageResponse, TransactionsPageResponseBuilder> {
  @BuiltValueField(wireName: 'all_transactions_size')
  int get allTransactionsSize;

  BuiltList<Transactions> get transactions;

  TransactionsPageResponse._();
  factory TransactionsPageResponse(
      [updates(
          TransactionsPageResponseBuilder
              transactionsPageResponseBuilder)]) = _$TransactionsPageResponse;
  static Serializer<TransactionsPageResponse> get serializer =>
      _$transactionsPageResponseSerializer;
}

abstract class Transactions
    implements Built<Transactions, TransactionsBuilder> {
  String get action;

  Data get data;

  @BuiltValueField(wireName: 'creator_account_id')
  String get creatorAccountId;

  @BuiltValueField(wireName: 'created_time')
  int get createdTime;

  int get quorum;

  BuiltList<Signatures> get signatures;

  Transactions._();
  factory Transactions([updates(TransactionsBuilder transactionsBuilder)]) =
      _$Transactions;
  static Serializer<Transactions> get serializer => _$transactionsSerializer;
}

abstract class Data implements Built<Data, DataBuilder> {
  @nullable
  @BuiltValueField(wireName: 'account_id')
  String get accountId;

  @nullable
  @BuiltValueField(wireName: 'account_name')
  String get accountName;

  @nullable
  String get key;

  @nullable
  String get value;

  @nullable
  @BuiltValueField(wireName: 'domain_id')
  String get domainId;

  @nullable
  @BuiltValueField(wireName: 'public_key')
  String get publicKey;

  @nullable
  @BuiltValueField(wireName: 'role_name')
  String get roleName;

  @nullable
  int get permission;

  Data._();
  factory Data([updates(DataBuilder dataBuilder)]) = _$Data;
  static Serializer<Data> get serializer => _$dataSerializer;
}

abstract class Signatures implements Built<Signatures, SignaturesBuilder> {
  @BuiltValueField(wireName: 'public_key')
  String get publicKey;

  String get signature;

  Signatures._();
  factory Signatures([updates(SignaturesBuilder signaturesBuilder)]) =
      _$Signatures;
  static Serializer<Signatures> get serializer => _$signaturesSerializer;
}
