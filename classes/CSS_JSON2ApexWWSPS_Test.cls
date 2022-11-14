@IsTest
public class CSS_JSON2ApexWWSPS_Test {
	
static testMethod void testParse() {
			String json = '{'+
		'   \"DataArea\": {\"ProductCertifications\":    ['+
		'            {'+
		'         \"DistributorCode\": \"10580\",'+
		'         \"CerificationFlag\": \"Y\",'+
		'         \"CerificationDate\": \"2015-05-28T00:00:00.000-04:00\",'+
		'         \"ProfileStatus\": \"ACTIVE\",'+
		'         \"CertificationExpiryDate\": \"2016-08-17T00:00:00.000-04:00\",'+
		'         \"DistributorFlag\": \"N\",'+
		'         \"ProductDetails\":          ['+
		'                        {'+
		'               \"ServiceModel\": \"6C8.3\",'+
		'               \"ProductCertificationStatus\": \"G\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"628\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISB6.7 CM2250\",'+
		'               \"ProductCertificationStatus\": \"G\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"1381\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISC CM554\",'+
		'               \"ProductCertificationStatus\": \"Y\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"677\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISM CM570\",'+
		'               \"ProductCertificationStatus\": \"G\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"635\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"NH/NT 855\",'+
		'               \"ProductCertificationStatus\": \"G\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"635\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISL CM554\",'+
		'               \"ProductCertificationStatus\": \"Y\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"677\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"L10 CELECT\",'+
		'               \"ProductCertificationStatus\": \"G\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"635\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"M11 CELECT PLUS\",'+
		'               \"ProductCertificationStatus\": \"G\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"635\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"N14 CELECT\",'+
		'               \"ProductCertificationStatus\": \"R\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"1585\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISB CM850\",'+
		'               \"ProductCertificationStatus\": \"Y\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"653\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISC CM850\",'+
		'               \"ProductCertificationStatus\": \"Y\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"677\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISL CM850\",'+
		'               \"ProductCertificationStatus\": \"Y\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"677\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISX CM570\",'+
		'               \"ProductCertificationStatus\": \"Y\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"622\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISX CM871\",'+
		'               \"ProductCertificationStatus\": \"Y\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"1198\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISB CM2150\",'+
		'               \"ProductCertificationStatus\": \"G\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"1206\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISC CM2150\",'+
		'               \"ProductCertificationStatus\": \"G\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"1207\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISL CM2150\",'+
		'               \"ProductCertificationStatus\": \"G\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"1207\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"6B5.9\",'+
		'               \"ProductCertificationStatus\": \"G\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"627\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISX15 CM2250\",'+
		'               \"ProductCertificationStatus\": \"G\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"1390\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISC8.3 CM2250\",'+
		'               \"ProductCertificationStatus\": \"G\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"1382\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISL9 CM2250\",'+
		'               \"ProductCertificationStatus\": \"G\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"1382\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISB6.7 CM2350 B101\",'+
		'               \"ProductCertificationStatus\": \"G\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"1526\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISL9 CM2350 L101\",'+
		'               \"ProductCertificationStatus\": \"G\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"1527\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISX15 CM2350 X101\",'+
		'               \"ProductCertificationStatus\": \"G\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"1524\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'                        {'+
		'               \"ServiceModel\": \"ISB CM550\",'+
		'               \"ProductCertificationStatus\": \"Y\",'+
		'               \"TechIDs\": {\"TechID\":                ['+
		'                  \"619\",'+
		'                  \"DUMMY\",'+
		'                  \"DUMMY\"'+
		'               ]},'+
		'               \"MarketingModel\": \"Automotive\"'+
		'            },'+
		'            {\"ServiceModel\": \"DUMMY\"},'+
		'            {\"ServiceModel\": \"DUMMY\"}'+
		'         ]'+
		'      },'+
		'            {'+
		'         \"DistributorCode\": \"10027\",'+
		'         \"ProfileStatus\": \"CANCELLED\",'+
		'         \"CertificationExpiryDate\": \"2007-11-05T00:00:00.000-05:00\",'+
		'         \"DistributorFlag\": \"N\",'+
		'         \"ProductDetails\":          ['+
		'            {\"ServiceModel\": \"DUMMY\"},'+
		'            {\"ServiceModel\": \"DUMMY\"}'+
		'         ]'+
		'      }'+
		'   ]},'+
		'   \"Header\":    {'+
		'      \"ReturnCodeDescription\": \"SUCCESS\",'+
		'      \"Status\": \"OK\",'+
		'      \"ReturnCode\": 200,'+
		'      \"MessageIdentifier\": \"2016-10-11T13:10:20.079-04:00\"'+
		'   }'+
		'}';


		CSS_JSON2ApexWWSPS obj = CSS_JSON2ApexWWSPS.parse(json);
		System.assert(obj != null);
	}
}