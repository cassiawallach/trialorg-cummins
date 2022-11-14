/*
 * Test Class for Apex Controller - FSL_CL_MROMessageData
 * Author - Piyush Rani
 */
@isTest
public class FSL_CL_MROMessageData_Test {
    @isTest static void testParse() {
        String json = '{'+
            '  \"DataArea\": {'+
            '    \"Status\": \"SUCCESS\",'+
            '    \"CustomerCode\": 3220141,'+
            '    \"ReturnCodeDescription\": \"Request processed successfully\",'+
            '    \"MessageDetails\": ['+
            '      {'+
            '        \"Priority\": 1,'+
            '        \"TextDetails\": ['+
            '          {'+
            '            \"LnNo\": 1,'+
            '            \"MessageText\": \"***Banking Details***\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 2,'+
            '            \"MessageText\": \"Cummins South Pacific Pty Ltd\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 3,'+
            '            \"MessageText\": \"Australia and New Zealand Banking Group Limited (ANZ)\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 4,'+
            '            \"MessageText\": \"Level 4, 100 Queen Street, Melbourne, VIC 3000\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 5,'+
            '            \"MessageText\": \"Account No: 836551902   BSB: 013 479\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 6,'+
            '            \"MessageText\": \"Swift Code: ANZBAU3M\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 7,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 8,'+
            '            \"MessageText\": \"Please include in the payment reference the account\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 9,'+
            '            \"MessageText\": \"number and invoice number being paid\"'+
            '          }'+
            '        ],'+
            '        \"MessageID\": 16509'+
            '      },'+
            '      {'+
            '        \"Priority\": 5,'+
            '        \"TextDetails\": ['+
            '          {'+
            '            \"LnNo\": 1,'+
            '            \"MessageText\": \"CHANGE ENVIRO LEVY IN COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 2,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 3,'+
            '            \"MessageText\": \"This engine serial number is in the Mid Range engine\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 4,'+
            '            \"MessageText\": \"family and attracts a $15 Enviromental Levy fee for Retail\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 5,'+
            '            \"MessageText\": \"invoice.\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 6,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 7,'+
            '            \"MessageText\": \"Change the Enviro Levy to $15 in COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 8,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 9,'+
            '            \"MessageText\": \"Use Panel Sequence YZ31 or select option 13 from COS100\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 10,'+
            '            \"MessageText\": \"screen\"'+
            '          }'+
            '        ],'+
            '        \"MessageID\": 4597'+
            '      },'+
            '      {'+
            '        \"Priority\": 5,'+
            '        \"TextDetails\": ['+
            '          {'+
            '            \"LnNo\": 1,'+
            '            \"MessageText\": \"CHANGE ENVIRO LEVY IN COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 2,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 3,'+
            '            \"MessageText\": \"This engine serial number is in the High Horse Power engine\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 4,'+
            '            \"MessageText\": \"family and attracts a $45 Enviromental Levy fee for Retail\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 5,'+
            '            \"MessageText\": \"invoice.\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 6,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 7,'+
            '            \"MessageText\": \"Change the Enviro Levy to $45 in COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 8,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 9,'+
            '            \"MessageText\": \"Use Panel Sequence YZ31 or select option 13 from COS100\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 10,'+
            '            \"MessageText\": \"screen\"'+
            '          }'+
            '        ],'+
            '        \"MessageID\": 4598'+
            '      },'+
            '      {'+
            '        \"Priority\": 5,'+
            '        \"TextDetails\": ['+
            '          {'+
            '            \"LnNo\": 1,'+
            '            \"MessageText\": \"CHANGE ENVIRO LEVY IN COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 2,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 3,'+
            '            \"MessageText\": \"This engine serial number is in the High Horse Power engine\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 4,'+
            '            \"MessageText\": \"family and attracts a $45 Enviromental Levy fee for Retail\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 5,'+
            '            \"MessageText\": \"invoice.\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 6,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 7,'+
            '            \"MessageText\": \"Change the Enviro Levy to $45 in COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 8,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 9,'+
            '            \"MessageText\": \"Use Panel Sequence YZ31 or select option 13 from COS100\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 10,'+
            '            \"MessageText\": \"screen\"'+
            '          }'+
            '        ],'+
            '        \"MessageID\": 4599'+
            '      },'+
            '      {'+
            '        \"Priority\": 5,'+
            '        \"TextDetails\": ['+
            '          {'+
            '            \"LnNo\": 1,'+
            '            \"MessageText\": \"CHANGE ENVIRO LEVY IN COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 2,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 3,'+
            '            \"MessageText\": \"This engine serial number is in the Mid Range engine\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 4,'+
            '            \"MessageText\": \"family and attracts a $15 Enviromental Levy fee for Retail\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 5,'+
            '            \"MessageText\": \"invoice.\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 6,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 7,'+
            '            \"MessageText\": \"Change the Enviro Levy to $15 in COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 8,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 9,'+
            '            \"MessageText\": \"Use Panel Sequence YZ31 or select option 13 from COS100\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 10,'+
            '            \"MessageText\": \"screen\"'+
            '          }'+
            '        ],'+
            '        \"MessageID\": 4600'+
            '      },'+
            '      {'+
            '        \"Priority\": 5,'+
            '        \"TextDetails\": ['+
            '          {'+
            '            \"LnNo\": 1,'+
            '            \"MessageText\": \"CHANGE ENVIRO LEVY IN COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 2,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 3,'+
            '            \"MessageText\": \"This engine serial number is in the Mid Range engine\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 4,'+
            '            \"MessageText\": \"family and attracts a $15 Enviromental Levy fee for Retail\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 5,'+
            '            \"MessageText\": \"invoice.\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 6,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 7,'+
            '            \"MessageText\": \"Change the Enviro Levy to $15 in COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 8,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 9,'+
            '            \"MessageText\": \"Use Panel Sequence YZ31 or select option 13 from COS100\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 10,'+
            '            \"MessageText\": \"screen\"'+
            '          }'+
            '        ],'+
            '        \"MessageID\": 4601'+
            '      },'+
            '      {'+
            '        \"Priority\": 5,'+
            '        \"TextDetails\": ['+
            '          {'+
            '            \"LnNo\": 1,'+
            '            \"MessageText\": \"ISF Engines in Foton vehicles will have a worldwide coverage\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 2,'+
            '            \"MessageText\": \"certificate applied to align the engine with the vehicle\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 3,'+
            '            \"MessageText\": \"coverage.\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 4,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 5,'+
            '            \"MessageText\": \"For coverage detail go to http://wwec.cummins.com\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 6,'+
            '            \"MessageText\": \"and enter the engine number.\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 7,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 8,'+
            '            \"MessageText\": \"The certificate and program detail must be included in the\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 9,'+
            '            \"MessageText\": \"warranty text for any covered repair beyond the ISF base\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 10,'+
            '            \"MessageText\": \"engine coverage. Please also update the engine prospect with\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 11,'+
            '            \"MessageText\": \"coverage certificate &amp; program details. If an engine does\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 12,'+
            '            \"MessageText\": \"not have a coverage certificate please e-mail (TPD) with the\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 13,'+
            '            \"MessageText\": \"engine detail to be escalated to BFCEC &amp; Foton.\"'+
            '          }'+
            '        ],'+
            '        \"MessageID\": 9199'+
            '      },'+
            '      {'+
            '        \"Priority\": 5,'+
            '        \"TextDetails\": ['+
            '          {'+
            '            \"LnNo\": 1,'+
            '            \"MessageText\": \"ISF Engines in Foton vehicles will have a worldwide coverage\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 2,'+
            '            \"MessageText\": \"certificate applied to align the engine with the vehicle\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 3,'+
            '            \"MessageText\": \"coverage.\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 4,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 5,'+
            '            \"MessageText\": \"For coverage detail go to http://wwec.cummins.com\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 6,'+
            '            \"MessageText\": \"and enter the engine number.\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 7,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 8,'+
            '            \"MessageText\": \"The certificate and program detail must be included in the\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 9,'+
            '            \"MessageText\": \"warranty text for any covered repair beyond the ISF base\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 10,'+
            '            \"MessageText\": \"engine coverage. Please also update the engine prospect with\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 11,'+
            '            \"MessageText\": \"coverage certificate &amp; program details. If an engine does\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 12,'+
            '            \"MessageText\": \"not have a coverage certificate please e-mail (TPD) with the\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 13,'+
            '            \"MessageText\": \"engine detail to be escalated to BFCEC &amp; Foton.\"'+
            '          }'+
            '        ],'+
            '        \"MessageID\": 9200'+
            '      },'+
            '      {'+
            '        \"Priority\": 5,'+
            '        \"TextDetails\": ['+
            '          {'+
            '            \"LnNo\": 1,'+
            '            \"MessageText\": \"Prior to commencing any works on ISF engines in Foton\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 2,'+
            '            \"MessageText\": \"Application please contact:\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 3,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 4,'+
            '            \"MessageText\": \"Tim Williams\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 5,'+
            '            \"MessageText\": \"National Service Manager\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 6,'+
            '            \"MessageText\": \"FOTON TRUCKS AUSTRALIA\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 7,'+
            '            \"MessageText\": \"862-874 Elizabeth St, Waterloo NSW 2017\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 8,'+
            '            \"MessageText\": \"Locked Bag 5018, Alexandria NSW 2015\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 9,'+
            '            \"MessageText\": \"Tel: +61 2 8577 8037\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 10,'+
            '            \"MessageText\": \"Fax: +61 2 8577 8199\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 11,'+
            '            \"MessageText\": \"Mob: +61 4 5887 7731\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 12,'+
            '            \"MessageText\": \"Email: twilliams@ateco.com.au\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 13,'+
            '            \"MessageText\": \"www.fotontrucks.com.au\"'+
            '          }'+
            '        ],'+
            '        \"MessageID\": 9712'+
            '      }'+
            '    ]'+
            '  },'+
            '  \"Header\": {'+
            '    \"Sender\": {'+
            '      \"ServiceName\": \"GetMROMessages\",'+
            '      \"SenderID\": \"CSS\",'+
            '      \"MessageID\": \"c5d2e11a-653e-40f1-baf8-ddd125c3dd40\"'+
            '    },'+
            '    \"Status\": \"\",'+
            '    \"Target\": {'+
            '      \"TargetID\": \"MOVEX\"'+
            '    },'+
            '    \"ReturnCodeDescription\": \"\",'+
            '    \"Location\": {'+
            '      \"LocationID\": \"05340-05351\"'+
            '    }'+
            '  }'+
            '}';
        FSL_CL_MROMessageData obj = FSL_CL_MROMessageData.parse(json);
        System.debug('::: JSON Obj DataAread - '+obj.DataArea);
        System.debug('::: JSON Obj MessageDetails - '+obj.DataArea.MessageDetails);
        System.assert(obj != null);
    }
    
}