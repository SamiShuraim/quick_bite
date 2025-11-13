/// Authentication Response Model
/// Data model for authentication API responses
library;

import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel {
  final bool success;
  final String message;
  final AuthDataModel? data;

  const AuthResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}

@JsonSerializable()
class AuthDataModel {
  final UserModel user;
  final TokensModel tokens;

  const AuthDataModel({
    required this.user,
    required this.tokens,
  });

  factory AuthDataModel.fromJson(Map<String, dynamic> json) =>
      _$AuthDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthDataModelToJson(this);
}

@JsonSerializable()
class TokensModel {
  final String accessToken;
  final String refreshToken;

  const TokensModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory TokensModel.fromJson(Map<String, dynamic> json) =>
      _$TokensModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokensModelToJson(this);
}

@JsonSerializable()
class ErrorResponseModel {
  final bool success;
  final String message;
  final Map<String, dynamic>? errors;

  const ErrorResponseModel({
    required this.success,
    required this.message,
    this.errors,
  });

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseModelToJson(this);
}

