global class CdpQueryDataGraphMetadata {
	global String dataspaceName;
	global String description;
	global ConnectApi.DataGraphObjectData dgObject;
	global String extendedProperties;
	global String idDmoName;
	global String name;
	global String primaryObjectName;
	global ConnectApi.DataGraphObjectTypeEnum primaryObjectType;
	global ConnectApi.DataGraphStatus status;
	global String valuesDmoName;
	global String version;
	global CdpQueryDataGraphMetadata() { }
	global Object clone() { }
	global Boolean equals(Object obj) { }
	global Double getBuildVersion() { }
	global Integer hashCode() { }
	global String toString() { }

}