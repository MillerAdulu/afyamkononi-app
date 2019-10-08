library auth;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth.g.dart';

abstract class SignInResult
    implements Built<SignInResult, SignInResultBuilder> {
  @BuiltValueField(wireName: 'access_token')
  String get accessToken;

  SignInResult._();
  factory SignInResult([updates(SignInResultBuilder signInResultBuilder)]) =
      _$SignInResult;
  static Serializer<SignInResult> get serializer => _$signInResultSerializer;
}

enum AuthStatus { LOGGED_OUT, LOGGED_IN }
