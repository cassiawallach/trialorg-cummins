@IsTest
public class CSS_WPR_SBL_GetTechInfoResJSONTest {
	
	static testMethod void testParse() {
		/*String json = '{'+
		'  \"DataArea\": ['+
		'    {'+
		'      \"PROMOTION_ID_FLAG\": \"Y\",'+
		'      \"SP_CERTIFICATION\": ['+
		'        {'+
		'          \"SMN\": \"ISB CM2150\",'+
		'          \"OEM_NAME\": \"PETERBILT OF CANADA LTD\",'+
		'          \"START_DATE\": \"\",'+
		'          \"END_DATE\": \"\"'+
		'        },'+
		'        {'+
		'          \"SMN\": \"ISC CM2150\",'+
		'          \"OEM_NAME\": \"PETERBILT OF CANADA LTD\",'+
		'          \"START_DATE\": \"\",'+
		'          \"END_DATE\": \"\"'+
		'        },'+
		'        {'+
		'          \"SMN\": \"ISC CM554\",'+
		'          \"OEM_NAME\": \"PETERBILT OF CANADA LTD\",'+
		'          \"START_DATE\": \"\",'+
		'          \"END_DATE\": \"\"'+
		'        },'+
		'        {'+
		'          \"SMN\": \"ISC CM850\",'+
		'          \"OEM_NAME\": \"PETERBILT OF CANADA LTD\",'+
		'          \"START_DATE\": \"\",'+
		'          \"END_DATE\": \"\"'+
		'        },'+
		'        {'+
		'          \"SMN\": \"ISL CM2150\",'+
		'          \"OEM_NAME\": \"PETERBILT OF CANADA LTD\",'+
		'          \"START_DATE\": \"\",'+
		'          \"END_DATE\": \"\"'+
		'        },'+
		'        {'+
		'          \"SMN\": \"ISL CM554\",'+
		'          \"OEM_NAME\": \"PETERBILT OF CANADA LTD\",'+
		'          \"START_DATE\": \"\",'+
		'          \"END_DATE\": \"\"'+
		'        },'+
		'        {'+
		'          \"SMN\": \"ISL CM850\",'+
		'          \"OEM_NAME\": \"PETERBILT OF CANADA LTD\",'+
		'          \"START_DATE\": \"\",'+
		'          \"END_DATE\": \"\"'+
		'        },'+
		'        {'+
		'          \"SMN\": \"ISM CM570\",'+
		'          \"OEM_NAME\": \"PETERBILT OF CANADA LTD\",'+
		'          \"START_DATE\": \"\",'+
		'          \"END_DATE\": \"\"'+
		'        },'+
		'        {'+
		'          \"SMN\": \"ISM CM570/870\",'+
		'          \"OEM_NAME\": \"PETERBILT OF CANADA LTD\",'+
		'          \"START_DATE\": \"\",'+
		'          \"END_DATE\": \"\"'+
		'        },'+
		'        {'+
		'          \"SMN\": \"ISM CM876\",'+
		'          \"OEM_NAME\": \"PETERBILT OF CANADA LTD\",'+
		'          \"START_DATE\": \"\",'+
		'          \"END_DATE\": \"\"'+
		'        },'+
		'        {'+
		'          \"SMN\": \"ISX CM570\",'+
		'          \"OEM_NAME\": \"PETERBILT OF CANADA LTD\",'+
		'          \"START_DATE\": \"\",'+
		'          \"END_DATE\": \"\"'+
		'        },'+
		'        {'+
		'          \"SMN\": \"ISX CM870\",'+
		'          \"OEM_NAME\": \"PETERBILT OF CANADA LTD\",'+
		'          \"START_DATE\": \"\",'+
		'          \"END_DATE\": \"\"'+
		'        },'+
		'        {'+
		'          \"SMN\": \"ISX CM871\",'+
		'          \"OEM_NAME\": \"PETERBILT OF CANADA LTD\",'+
		'          \"START_DATE\": \"\",'+
		'          \"END_DATE\": \"\"'+
		'        },'+
		'        {'+
		'          \"SMN\": \"L10 CELECT\",'+
		'          \"OEM_NAME\": \"PETERBILT OF CANADA LTD\",'+
		'          \"START_DATE\": \"\",'+
		'          \"END_DATE\": \"\"'+
		'        },'+
		'        {'+
		'          \"SMN\": \"M11 CELECT PLUS\",'+
		'          \"OEM_NAME\": \"PETERBILT OF CANADA LTD\",'+
		'          \"START_DATE\": \"\",'+
		'          \"END_DATE\": \"\"'+
		'        },'+
		'        {'+
		'          \"SMN\": \"N14 CELECT\",'+
		'          \"OEM_NAME\": \"PETERBILT OF CANADA LTD\",'+
		'          \"START_DATE\": \"\",'+
		'          \"END_DATE\": \"\"'+
		'        }'+
		'      ],'+
		'      \"SP_CODE\": 23456,'+
		'      \"PRODUCT_CERTIFICATION_FLAG\": \"Y\",'+
		'      \"CERTIFICATIONENDDATE\": \"2016-04-20T00:00:00.000-05:00\",'+
		'      \"WARRANTYTRAININGSTATUS\": \"Red\",'+
		'      \"TERRITORY\": \"CANADA\",'+
		'      \"WRNTY_TRAINING_CERTIFICATION\": \"Y\",'+
		'      \"REGION\": \"NORTH AMERICA\",'+
		'      \"SPPROFILESTATUS\": \"Cancelled\",'+
		'      \"TECH_CERTIFICATION\": {'+
		'        \"SMNDETAILS\": ['+
        '        {'+
		'          \"SMN\": \"\",'+
		'          \"QUAL_PASS_DT\": \"\"'+
		'        },'+
        '        {'+
		'          \"SMN\": \"\",'+
		'          \"QUAL_PASS_DT\": \"\"'+
		'        }'+
        '       ],' +
		'        \"TechFName\": \"\",'+
		'        \"TechPromoID\": \"\",'+
		'        \"TechLogin\": \"\",'+
		'        \"TechLName\": \"\"'+
		'      }'+
		'    },'+
		'    {'+
		'      \"PROMOTION_ID_FLAG\": \"Y\",'+
		'      \"SP_CERTIFICATION\": {'+
		'        \"SMN\": \"\",'+
		'        \"OEM_NAME\": \"\",'+
		'        \"START_DATE\": \"\",'+
		'        \"END_DATE\": \"\"'+
		'      },'+
		'      \"SP_CODE\": 30432,'+
		'      \"PRODUCT_CERTIFICATION_FLAG\": \"N\",'+
		'      \"CERTIFICATIONENDDATE\": \"2016-04-20T00:00:00.000-05:00\",'+
		'      \"WARRANTYTRAININGSTATUS\": \"Green\",'+
		'      \"TERRITORY\": \"UNITED STATES\",'+
		'      \"WRNTY_TRAINING_CERTIFICATION\": \"N\",'+
		'      \"REGION\": \"NORTH AMERICA\",'+
		'      \"SPPROFILESTATUS\": \"Active\",'+
		'      \"TECH_CERTIFICATION\": ['+
		'        {'+
		'          \"SMNDETAILS\": {'+
		'            \"SMN\": \"\",'+
		'            \"QUAL_PASS_DT\": \"\"'+
		'          },'+
		'          \"TechFName\": \"Larry\",'+
		'          \"TechPromoID\": 1112825,'+
		'          \"TechLogin\": 1112825,'+
		'          \"TechLName\": \"Doyle\"'+
		'        },'+
		'        {'+
		'          \"SMNDETAILS\": {'+
		'            \"SMN\": \"\",'+
		'            \"QUAL_PASS_DT\": \"\"'+
		'          },'+
		'          \"TechFName\": \"Billy\",'+
		'          \"TechPromoID\": 1117200,'+
		'          \"TechLogin\": 1117200,'+
		'          \"TechLName\": \"Burgess\"'+
		'        },'+
		'        {'+
		'          \"SMNDETAILS\": {'+
		'            \"SMN\": \"\",'+
		'            \"QUAL_PASS_DT\": \"\"'+
		'          },'+
		'          \"TechFName\": \"Aaron\",'+
		'          \"TechPromoID\": 1117201,'+
		'          \"TechLogin\": 1117201,'+
		'          \"TechLName\": \"Ellis\"'+
		'        },'+
		'        {'+
		'          \"SMNDETAILS\": {'+
		'            \"SMN\": \"\",'+
		'            \"QUAL_PASS_DT\": \"\"'+
		'          },'+
		'          \"TechFName\": \"David\",'+
		'          \"TechPromoID\": 1117202,'+
		'          \"TechLogin\": 1117202,'+
		'          \"TechLName\": \"Estes\"'+
		'        },'+
		'        {'+
		'          \"SMNDETAILS\": {'+
		'            \"SMN\": \"\",'+
		'            \"QUAL_PASS_DT\": \"\"'+
		'          },'+
		'          \"TechFName\": \"Josef\",'+
		'          \"TechPromoID\": 1117208,'+
		'          \"TechLogin\": 1117208,'+
		'          \"TechLName\": \"Baker\"'+
		'        },'+
		'        {'+
		'          \"SMNDETAILS\": {'+
		'            \"SMN\": \"\",'+
		'            \"QUAL_PASS_DT\": \"\"'+
		'          },'+
		'          \"TechFName\": \"Brad\",'+
		'          \"TechPromoID\": 1117233,'+
		'          \"TechLogin\": 1117233,'+
		'          \"TechLName\": \"Bible\"'+
		'        },'+
		'        {'+
		'          \"SMNDETAILS\": {'+
		'            \"SMN\": \"\",'+
		'            \"QUAL_PASS_DT\": \"\"'+
		'          },'+
		'          \"TechFName\": \"Scott\",'+
		'          \"TechPromoID\": 1120866,'+
		'          \"TechLogin\": 1120866,'+
		'          \"TechLName\": \"Diggs\"'+
		'        },'+
		'        {'+
		'          \"SMNDETAILS\": {'+
		'            \"SMN\": \"\",'+
		'            \"QUAL_PASS_DT\": \"\"'+
		'          },'+
		'          \"TechFName\": \"David\",'+
		'          \"TechPromoID\": 1122599,'+
		'          \"TechLogin\": 1122599,'+
		'          \"TechLName\": \"Grimes\"'+
		'        },'+
		'        {'+
		'          \"SMNDETAILS\": {'+
		'            \"SMN\": \"\",'+
		'            \"QUAL_PASS_DT\": \"\"'+
		'          },'+
		'          \"TechFName\": \"Travis\",'+
		'          \"TechPromoID\": 1131023,'+
		'          \"TechLogin\": 1131023,'+
		'          \"TechLName\": \"Daniels\"'+
		'        },'+
		'        {'+
		'          \"SMNDETAILS\": {'+
		'            \"SMN\": \"\",'+
		'            \"QUAL_PASS_DT\": \"\"'+
		'          },'+
		'          \"TechFName\": \"Michael\",'+
		'          \"TechPromoID\": \"A414027\",'+
		'          \"TechLogin\": \"a414027\",'+
		'          \"TechLName\": \"Davis\"'+
		'        }'+
		'      ]'+
		'    }'+
		'  ],'+
		'  \"Header\": {'+
		'    \"ReturnCodeDescription\": \"\",'+
		'    \"Status\": \"Success\",'+
		'    \"ReturnCode\": \"\",'+
		'    \"MessageIdentifier\": \"2017-06-04\"'+
		'  }'+
		'}';*/
        string json ='{ "DataArea": [{ "SP_CODE": 23456, "SPPROFILESTATUS": "Cancelled", "TECH_CERTIFICATION":[ { "SMNDETAILS": [ { "SMN": "" } ], "TechFName": "", "TechPromoID": "", "TechLogin": "", "TechLName": "" }] }], "Header": { "ReturnCodeDescription": "", "Status": "Success", "ReturnCode": "", "MessageIdentifier": "2017-06-04" } }';
		CSS_WPR_SBL_GetTechInfoResJSON obj = CSS_WPR_SBL_GetTechInfoResJSON.parse(json);
		System.assert(obj != null);
        system.debug('obj >>'+obj);
	}
}