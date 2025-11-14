// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) =>
    AuthResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : AuthDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthResponseModelToJson(AuthResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

AuthDataModel _$AuthDataModelFromJson(Map<String, dynamic> json) =>
    AuthDataModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      tokens: TokensModel.fromJson(json['tokens'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthDataModelToJson(AuthDataModel instance) =>
    <String, dynamic>{'user': instance.user, 'tokens': instance.tokens};

TokensModel _$TokensModelFromJson(Map<String, dynamic> json) => TokensModel(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
);

Map<String, dynamic> _$TokensModelToJson(TokensModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

ErrorResponseModel _$ErrorResponseModelFromJson(Map<String, dynamic> json) =>
    ErrorResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      errors: json['errors'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ErrorResponseModelToJson(ErrorResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'errors': instance.errors,
    };
