@isTest
public class FSL_DetailCoverageResWrapper_Test {
     static testMethod void  testParse() {
		String json = '{'+
		'"DataArea": {'+
		'"Details": ['+
		           '{'+
		                '"DeductibleAmount": "0",'+
		                '"CampaignTravelPercentage": "0",'+
						'"Status": "Success",'+
						'"CampaignPartsPercentage": "0",'+
                        '"Message": "",'+
                        '"ComponentCode": "AV",'+
                        '"SystemCode": "FH",'+
                        '"CampaignLaborPercentage": "0",'+
                        '"CoveredTowingMiles": "0",'+
                        '"CoveredTravelMiles": "0",'+
                        '"WarrantyId": "1-608-1068",'+
                        '"CoveredMealsLodgingAmt": "0",'+
                        '"CoveredLaborHrs": "9999999",'+
                        '"CampaignOCPercentage": "0",'+
                        '"CoveredTravelLabor": "0",'+
                        '"CampaignTowingPercentage": "0",'+
                        '"PayCode": "I",'+
                        '"AccountCodeType": "CAP-Customized Assurance Plan",'+
                        '"CoveredPartsQty": "9999999",'+
                        '"CoveredTravelBaseFareAmt": "0",'+
                        '"AccountCode": "DC",'+
                        '"CertificateNumber": "DC11024342-DC1",'+
                        '"CoveredOCAmount": "9999999"'+
		             '}'+
		             '],'+
						'"AccountCodeType": "CAP-Customized Assurance Plan",'+
						'"AccountCode": "DC"'+
				     '},'+
					'"Header": {'+
					'"Status": "Success",'+
					'"ReturnCodeDescription": ""'+
					'}'+
			    '}';
		 FSL_DetailCoverageResWrapper.parse(json);
        FSL_DetailCoverageResWrapper.DataArea dt = new FSL_DetailCoverageResWrapper.DataArea();
	}

}