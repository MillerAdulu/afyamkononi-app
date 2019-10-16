library serializers;

import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_collection/built_collection.dart';

import 'package:afyamkononi/src/models/auth.dart';
import 'package:afyamkononi/src/models/consent.dart';

part 'serializers.g.dart';

@SerializersFor(const [SignInResult, ConsentResult, ConsentResults])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
