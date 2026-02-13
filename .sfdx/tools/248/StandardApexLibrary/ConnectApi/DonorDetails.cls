global class DonorDetails {
	global List<ConnectApi.CustomFieldDetails> accountCustomFields;
	global List<ConnectApi.AddressDetails> address;
	global List<ConnectApi.CustomFieldDetails> contactCustomFields;
	global String donorType;
	global String email;
	global String firstName;
	global String id;
	global String lastName;
	global String organizationName;
	global String phone;
	global Boolean updateDonorDetailsViaId;
	global Boolean updateDonorDetailsViaMatch;
	global DonorDetails() { }
	global Object clone() { }
	global Boolean equals(Object obj) { }
	global Integer hashCode() { }
	global String toString() { }

}