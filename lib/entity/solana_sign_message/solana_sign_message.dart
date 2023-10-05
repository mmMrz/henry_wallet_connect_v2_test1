import 'package:json_annotation/json_annotation.dart';

part 'solana_sign_message.g.dart';

@JsonSerializable(includeIfNull: false)
class SolanaSignMessage {
  final String pubkey;
  final String message;

  SolanaSignMessage({
    required this.pubkey,
    required this.message,
  });

  factory SolanaSignMessage.fromJson(Map<String, dynamic> json) => _$SolanaSignMessageFromJson(json);

  Map<String, dynamic> toJson() => _$SolanaSignMessageToJson(this);

  @override
  String toString() {
    return 'SolanaSignMessage(pubkey: $pubkey, message: $message)';
  }
}
