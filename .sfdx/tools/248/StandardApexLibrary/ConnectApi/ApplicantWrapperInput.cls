global class ApplicantWrapperInput {
	global ConnectApi.applicantInput applicant;
	global List<ConnectApi.partyExpenseInputRepresentation> partyExpenseWrapper;
	global List<ConnectApi.partyFinancialLiabilityInputRepresentation> partyFinancialLiabilityWrapper;
	global List<ConnectApi.partyIncomeInputRepresentation> partyIncomeWrapper;
	global ConnectApi.partyProfileInput partyProfile;
	global List<ConnectApi.personEmploymentInputRepresentation> personEmploymentWrapper;
	global applicantWrapperInput() { }
	global Object clone() { }
	global Boolean equals(Object obj) { }
	global Integer hashCode() { }
	global String toString() { }

}