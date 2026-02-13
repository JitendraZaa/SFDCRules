global class TransactionPaymentUpdateRequest {
	global String gatewayReference;
	global String giftTransactionId;
	global String lastGatewayErrorMessage;
	global String lastGatewayProcessedDateTime;
	global String lastGatewayResponseCode;
	global String processorReference;
	global String transactionStatus;
	global TransactionPaymentUpdateRequest() { }
	global Object clone() { }
	global Boolean equals(Object obj) { }
	global Integer hashCode() { }
	global String toString() { }

}