@IsTest
public class CSS_getBasicCoverageResponseJ2A_Test {
    /*
    static testMethod void testParse() {
        String json = '{'+
        '   \"Header\": {'+
        '       \"MessageIdentifier\": \"Identifier from MW\",'+
        '       \"ReturnCode\": \"<MessageCode from Siebel>\",'+
        '       \"ReturnCodeDescription\": \"<Message from Siebel>\",'+
        '       \"Status\": \"Success\"'+
        '   },'+
        '   \"DataArea\": {'+
        '       \"SystemCode\": \"IR\",'+
        '       \"ComponentCode\": \"TC\",'+
        '       \"AccountCode\": \"65\",'+
        '       \"AccountCodeType\": \"CMP-Campaign / Recalls\",'+
        '       \"PayCode\": \"R\",'+
        '       \"CertificateNumber\": \"89798798\",'+
        '       \"CoveredLaborHrs\": 30,'+
        '       \"CoveredMealsLodgingAmt\": 20,'+
        '       \"CoveredOCAmount\": 200,'+
        '       \"CoveredPartsQty\": 10,'+
        '       \"CoveredTowingMiles\": 500,'+
        '       \"CoveredTravelLabor\": 40,'+
        '       \"CoveredTravelMiles\": 8,'+
        '       \"DeductibleAmount\": 500,'+
        '       \"CampaignLaborPercentage\": 100,'+
        '       \"CampaignOCPercentage\": 100,'+
        '       \"CampaignPartsPercentage\": 100,'+
        '       \"CampaignTowingPercentage\": 100,'+
        '       \"CampaignTravelPercentage\": 100,'+
        '       \"Message\": \"Coverage Not Found/This ESN is ineligible for this Campaign\",'+
        '       \"Status\": \"Success/Error\",'+
        '       \"WarrantyId\": \"1-HJGT\"'+
        '   }'+
        '}';
       CSS_getBasicCoverageResponseJ2A obj = CSS_getBasicCoverageResponseJ2A.parse(json);
        System.assert(obj != null);
    }*/
    static testMethod void testParse() {
		String json = '{'+
		'   \"Header\":    {'+
		'      \"ReturnCodeDescription\": \"\",'+
		'      \"Status\": \"Success\"'+
		'   },'+
		'   \"BasicCoverageResponseHeader\": {\"Response\":    {'+
		'      \"ListOfCoverageDetails\": {\"CoverageDetails\":       [	'+
		'                  {'+
		'            \"ListOfCoverageComponentList\": {\"CoverageComponentList\":             ['+
		'                              {'+
		'                  \"MegawattHours\": \"1000\",'+
		'                  \"CoverageMaxMonths\": \"30\",'+
		'                  \"CoverageComponentTypeCode\": \"EMISSIONS-CA\",'+
		'                  \"CoverageMinMonths\": \"20\",'+
		'                  \"CoverageHours\": \"100\",'+
		'                  \"CoverageDefenitionType\": \"BASE\",'+
		'                  \"CoverageMiles\": \"10\"'+
		'               },'+
		'                              {'+
		'                  \"MegawattHours\": \"123\",'+
		'                  \"CoverageMaxMonths\": \"234\",'+
		'                  \"CoverageComponentTypeCode\": \"BELTS/HOSES\",'+
		'                  \"CoverageMinMonths\": \"56\",'+
		'                  \"CoverageHours\": \"123\",'+
		'                  \"CoverageDefenitionType\": \"BASE\",'+
		'                  \"CoverageMiles\": \"123\"'+
		'               }'+
		'            ]},'+
		'            \"WarrantyManualURL\": \"www.test.com/ems\",'+
		'            \"CoverageType\": \"EMS-Emissions Warranty\",'+
		'            \"ListOfCoverageDedutibles\": {\"CoverageDedutibles\": []},'+
		'            \"ProcedureNumber\": \"ProcEMS\"'+
		'         },'+
		'                  {'+
		'            \"ListOfCoverageComponentList\": {\"CoverageComponentList\":             ['+
		'                              {'+
		'                  \"MegawattHours\": \"0\",'+
		'                  \"CoverageMaxMonths\": \"120\",'+
		'                  \"CoverageComponentTypeCode\": \"EMISSIONS-CA\",'+
		'                  \"CoverageMinMonths\": \"0\",'+
		'                  \"CoverageHours\": \"100000\",'+
		'                  \"CoverageDefenitionType\": \"BASE\",'+
		'                  \"CoverageMiles\": \"100000\"'+
		'               },'+
		'                              {'+
		'                  \"MegawattHours\": \"0\",'+
		'                  \"CoverageMaxMonths\": \"60\",'+
		'                  \"CoverageComponentTypeCode\": \"EMISSIONS\",'+
		'                  \"CoverageMinMonths\": \"0\",'+
		'                  \"CoverageHours\": \"0\",'+
		'                  \"CoverageDefenitionType\": \"BASE\",'+
		'                  \"CoverageMiles\": \"100000\"'+
		'               }'+
		'            ]},'+
		'            \"WarrantyManualURL\": \"\",'+
		'            \"CoverageType\": \"NEW-New Engine Warranty\",'+
		'            \"ListOfCoverageDedutibles\": {\"CoverageDedutibles\": []},'+
		'            \"ProcedureNumber\": \"\"'+
		'         }'+
		'      ]},'+
		'      \"ListOfExtendedCoverageDetails\": {\"ExtendedCoverageDetails\":       ['+
		'                  {'+
		'            \"ListOfExtCoverageDedutibles\": {\"ExtendedCoverageDedutibles\": []},'+
		'            \"WarrantyManualURL\": \"\",'+
		'            \"BeginMiles\": \"0\",'+
		'            \"EndMiles\": \"500000\",'+
		'            \"ProcedureNumber\": \"\",'+
		'            \"CertificateNumber\": \"TP41000811\",'+
		'            \"ProgramID\": \"TP4\",'+
		'            \"BeginHours\": \"0\",'+
		'            \"EndHours\": \"0\",'+
		'            \"EndDate\": \"09/21/2015\",'+
		'            \"StartDate\": \"09/21/2010\",'+
		'            \"Months\": \"60\",'+
		'            \"CAPCoverageID\": \"CRT\"'+
		'         },'+
		'                  {'+
		'            \"ListOfExtCoverageDedutibles\": {\"ExtendedCoverageDedutibles\": []},'+
		'            \"WarrantyManualURL\": \"\",'+
		'            \"BeginMiles\": \"0\",'+
		'            \"EndMiles\": \"300000\",'+
		'            \"ProcedureNumber\": \"\",'+
		'            \"CertificateNumber\": \"TP41000811\",'+
		'            \"ProgramID\": \"TP4\",'+
		'            \"BeginHours\": \"0\",'+
		'            \"EndHours\": \"0\",'+
		'            \"EndDate\": \"09/21/2013\",'+
		'            \"StartDate\": \"09/21/2010\",'+
		'            \"Months\": \"36\",'+
		'            \"CAPCoverageID\": \"APT\"'+
		'         }'+
		'      ]}'+
		'   }}'+
		'}';
		CSS_getBasicCoverageResponseJ2A obj = CSS_getBasicCoverageResponseJ2A.parse(json);
        CSS_getBasicCoverageResponseJ2A obj1 = new CSS_getBasicCoverageResponseJ2A();
		System.assert(obj != null);
	}
}