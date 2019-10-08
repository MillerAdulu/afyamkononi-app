library serializers;

import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'package:afyamkononi/src/models/auth.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  SignInResult,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
