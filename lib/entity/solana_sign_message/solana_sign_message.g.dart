// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solana_sign_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolanaSignMessage _$SolanaSignMessageFromJson(Map<String, dynamic> json) =>
    SolanaSignMessage(
      pubkey: json['pubkey'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$SolanaSignMessageToJson(SolanaSignMessage instance) =>
    <String, dynamic>{
      'pubkey': instance.pubkey,
      'message': instance.message,
    };
