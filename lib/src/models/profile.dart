library profile;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'profile.g.dart';

abstract class UserProfile implements Built<UserProfile, UserProfileBuilder> {
  String get creator;
  ProfileData get data;

  UserProfile._();
  factory UserProfile([updates(UserProfileBuilder userProfileBuilder)]) =
      _$UserProfile;
  static Serializer<UserProfile> get serializer => _$userProfileSerializer;
}

abstract class ProfileData implements Built<ProfileData, ProfileDataBuilder> {
  String get name;

  String get email;

  @BuiltValueField(wireName: 'gov_id')
  String get govId;

  @BuiltValueField(wireName: 'phone_number')
  String get phoneNumber;

  ProfileData._();
  factory ProfileData([updates(ProfileDataBuilder profileDataBuilder)]) =
      _$ProfileData;
  static Serializer<ProfileData> get serializer => _$profileDataSerializer;
}
