@IsTest
public class CSS_GetJobInfoResWrapper_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'	\"Header\": {'+
		'		\"ServiceName\": \"GetJobInfo\",'+
		'		\"ServiceVersion\": \"1.0\",'+
		'		\"Status\": \"Success\",'+
		'		\"ReturnCode\": \"CSS00\",'+
		'		\"ReturnCodeDescription\": \"message_ifany\"'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"CSSJobId\": \"CSS-00023456\",'+
		'		\"PSN\": \"78464621\",'+
		'		\"SERVICEMODELNAME\": \"ISB_CM2150\",'+
		'		\"MAKE\": \"KENWORTH\",'+
		'		\"MODEL\": \"T800\",'+
		'		\"CUSTOMERNAME\": \"FDNY\",'+
		'		\"SHOPWO\": \"WO123456\",'+
		'		\"DATEAVAILSERVICE\": \"2017-01-06\",'+
		'		\"FAULTDETAILS\": [{'+
		'			\"Count\": \"123\",'+
		'			\"FaultCodeText\": \"123\",'+
		'			\"FaultCode\": \"123\",'+
		'			\"FaultCodeType\": \"123\",'+
		'			\"PrimaryFC\": \"123\",'+
		'			\"RelatedFC\": \"234,546\",'+
		'			\"RelatedFC_Text\": \"123\"'+
		'		}, {'+
		'			\"Count\": \"123\",'+
		'			\"FaultCodeText\": \"123\",'+
		'			\"FaultCode\": \"123\",'+
		'			\"FaultCodeType\": \"123\",'+
		'			\"PrimaryFC\": \"123\",'+
		'			\"RelatedFC\": \"234,546\",'+
		'			\"RelatedFC_Text\": \"123\"'+
		'		}],'+
		'		\"SolutionData\": [{'+
		'			\"SolDescriptions\": \"Most Likely the Solution\",'+
		'			\"Comments\": \"Looks like the solution\"'+
		'		}, {'+
		'			\"SolDescriptions\": \"Most Likely the Solution\",'+
		'			\"Comments\": \"Looks like the solution\"'+
		'		}],'+
		'		\"RepairData\": [{'+
		'			\"SolutionDescription\": \"Intake manifold pressure sensor supply\",'+
		'			\"RepairComments\": \"It was old\",'+
		'			\"Components\": [{'+
		'				\"ComponentID\": \"F20000\",'+
		'				\"ComponentName\": \"Pressure Sensor\",'+
		'				\"Action\": \"Repaired\"'+
		'			}, {'+
		'				\"ComponentID\": \"F42000\",'+
		'				\"ComponentName\": \"<Component Name>\",'+
		'				\"Action\": \"Replaced\"'+
		'			}]'+
		'		}, {'+
		'			\"SolutionDescription\": \"K231456\",'+
		'			\"RepairComments\": \"It was old and dirty\",'+
		'			\"Components\": [{'+
		'				\"ComponentID\": \"F20000\",'+
		'				\"ComponentName\": \"Pressure Sensor\",'+
		'				\"Action\": \"Repaired\"'+
		'			}, {'+
		'				\"ComponentID\": \"F42000\",'+
		'				\"ComponentName\": \"<Component Name>\",'+
		'				\"Action\": \"Replaced\"'+
		'			}]'+
		'		}],'+
		'		\"CUST_DATA\": {'+
		'			\"CustomerID\": \"123456\",'+
		'			\"CustomerName\": \"TestCustomer\",'+
		'			\"ContactName\": \"DealerContact1\",'+
		'			\"AddressLine1\": \"Sample Avenue\",'+
		'			\"AddressLine2\": \"Test Street\",'+
		'			\"City\": \"COLUMBUS\",'+
		'			\"StateProvince\": \"IN\",'+
		'			\"Country\": \"USA\"'+
		'		},'+
		'		\"UNIT_DATA\": {'+
		'			\"Application\": \"Automotive\",'+
		'			\"UnitNumber\": \"638839\",'+
		'			\"ESN\": \"79464646\",'+
		'			\"ServiceModel\": \"ISB_CM2150\",'+
		'			\"Make\": \"TATA\",'+
		'			\"Model\": \"NOVUS\",'+
		'			\"VIN\": \"2ST55SF09FS285\",'+
		'			\"FailureDate\": \"2017-01-06\",'+
		'			\"WarrStartDate\": \"2017-01-06\",'+
		'			\"MileageOrKms\": \"20000\",'+
		'			\"MileageMeasure\": \"<Miles/KM>\",'+
		'			\"Hours\": \"40\",'+
		'			\"FailurePoint\": \"TestFailurePoint\"'+
		'		}'+
		'	}'+
		'}';
		CSS_GetJobInfoResWrapper obj = CSS_GetJobInfoResWrapper.parse(json);
		System.assert(obj != null);
	}
}