class UKWCTransaction {
  final String from;
  final String to;
  final String? nonce;
  final String? gasPrice;
  final String? maxFeePerGas;
  final String? maxPriorityFeePerGas;
  final String? gas;
  final String? gasLimit;
  final String value;
  final String? data;
  Map? decodedData;

  UKWCTransaction({
    required this.from,
    required this.to,
    required this.value,
    this.nonce,
    this.gasPrice,
    this.maxFeePerGas,
    this.maxPriorityFeePerGas,
    this.gas,
    this.gasLimit,
    this.data,
  });

  factory UKWCTransaction.fromJson(Map<String, dynamic> json) => _walletConnectTransactionFromJson(json);
  Map<String, dynamic> toJson() => walletConnectTransactionToJson(this);

  @override
  String toString() {
    return 'WCEthereumTransaction(from: $from, to: $to, nonce: $nonce, gasPrice: $gasPrice, gas: $gas, gasLimit: $gasLimit, value: $value, data: $data)';
  }

  static UKWCTransaction _walletConnectTransactionFromJson(Map<String, dynamic> json) => UKWCTransaction(
        from: json['from'] as String,
        to: json['to'] as String,
        nonce: json['nonce'] as String?,
        gasPrice: json['gasPrice'] as String?,
        maxFeePerGas: json['maxFeePerGas'] as String?,
        maxPriorityFeePerGas: json['maxPriorityFeePerGas'] as String?,
        gas: json['gas'] as String?,
        gasLimit: json['gasLimit'] as String?,
        value: json['value'] as String,
        data: json['data'] as String?,
      );

  Map<String, dynamic> walletConnectTransactionToJson(UKWCTransaction instance) => <String, dynamic>{
        'from': instance.from,
        'to': instance.to,
        'nonce': instance.nonce,
        'gasPrice': instance.gasPrice,
        'maxFeePerGas': instance.maxFeePerGas,
        'maxPriorityFeePerGas': instance.maxPriorityFeePerGas,
        'gas': instance.gas,
        'gasLimit': instance.gasLimit,
        'value': instance.value,
        'data': instance.data,
      };
}
