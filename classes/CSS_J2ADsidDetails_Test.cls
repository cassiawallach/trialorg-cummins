@isTest
public class CSS_J2ADsidDetails_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"details\": {'+
		'    \"id\": \"DSBDT4730\",'+
		'    \"status\": \"Open\",'+
		'    \"name\": \"TITLE value\",'+
		'    \"title\": \"TITLE value\",'+
		'    \"details\": ['+
		'      {'+
		'        \"name\": \"DSID\",'+
		'        \"caption\": \"Session ID\",'+
		'        \"value\": \"DSBDT4730\",'+
		'        \"editable\": false'+
		'      },'+
		'      {'+
		'        \"name\": \"WORKORDER\",'+
		'        \"caption\": \"Ticket\",'+
		'        \"editable\": true'+
		'      },'+
		'      {'+
		'        \"name\": \"CREATED\",'+
		'        \"caption\": \"Creation Date\",'+
		'        \"value\": \"22-APR-2016 15:28:22 EDT\",'+
		'        \"editable\": false'+
		'      },'+
		'      {'+
		'        \"name\": \"LAST_UPDATED\",'+
		'        \"caption\": \"Last updated on\",'+
		'        \"value\": \"05-MAY-2016 15:49:30 EDT\",'+
		'        \"editable\": false'+
		'      },'+
		'      {'+
		'        \"name\": \"STATUS\",'+
		'        \"caption\": \"Status\",'+
		'        \"value\": \"Open\",'+
		'        \"editable\": false'+
		'      },'+
		'      {'+
		'        \"name\": \"OWNER\",'+
		'        \"caption\": \"Owner\",'+
		'        \"value\": \"scharette\",'+
		'        \"editable\": true'+
		'      },'+
		'      {'+
		'        \"name\": \"TITLE\",'+
		'        \"caption\": \"Title\",'+
		'        \"value\": \"TITLE value\",'+
		'        \"editable\": false'+
		'      },'+
		'      {'+
		'        \"name\": \"APPLIANCE_MODEL\",'+
		'        \"caption\": \"Model\",'+
		'        \"value\": \"ISC CM2150\",'+
		'        \"editable\": false'+
		'      },'+
		'      {'+
		'        \"name\": \"SERIAL_NUMBER\",'+
		'        \"caption\": \"Serial Number\",'+
		'        \"value\": \"46783622\",'+
		'        \"editable\": false'+
		'      },'+
		'      {'+
		'        \"name\": \"application\",'+
		'        \"caption\": \"label_application\",'+
		'        \"value\": \"Automotive [130]\",'+
		'        \"editable\": false'+
		'      },'+
		'      {'+
		'        \"name\": \"failurePoint\",'+
		'        \"caption\": \"label_failurepoint\",'+
		'        \"value\": \"2222 HR\",'+
		'        \"editable\": true'+
		'      },'+
		'      {'+
		'        \"name\": \"unitNumber\",'+
		'        \"caption\": \"label_unitnumber\",'+
		'        \"value\": \"12345678\",'+
		'        \"editable\": true'+
		'      },'+
		'      {'+
		'        \"name\": \"EQUIPMENT_DETAILS\",'+
		'        \"caption\": \"label.equipment-details\",'+
		'        \"value\": \"AGCO,6195,,B\",'+
		'        \"editable\": true'+
		'      }'+
		'    ],'+
		'    \"actions\": ['+
		'      {'+
		'        \"name\": \"CONTINUE\",'+
		'        \"caption\": \"Continue\",'+
		'        \"status\": \"enable\",'+
		'        \"editable\": false'+
		'      },'+
		'      {'+
		'        \"name\": \"VIEW_READ_ONLY\",'+
		'        \"caption\": \"View Read-Only\",'+
		'        \"status\": \"enable\",'+
		'        \"editable\": false'+
		'      }'+
		'    ],'+
		'    \"canEdit\": true,'+
		'    \"canDownload\": true'+
		'  },'+
		'  \"attachments\": ['+
		'    {'+
		'      \"user\": \"scharette\",'+
		'      \"comment\": \"attachment\",'+
		'      \"time\": \"28-APR-2016 17:03:56 EDT\",'+
		'      \"link\": \"/skdservice/rest/api/cmi_diagnostic_sessions/DSBDT4730/attachments/979604\",'+
		'      \"fileName\": \"Lighthouse.jpg\"'+
		'    }'+
		'  ],'+
		'  \"auditTrial\": ['+
		'    {'+
		'      \"date\": \"22-APR-2016 \",'+
		'      \"times\": ['+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 1,'+
		'          \"time\": \"15:28:22 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"STARTED NEW SESSION\",'+
		'              \"id\": 1'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 2,'+
		'          \"time\": \"15:28:24 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Initialized the search\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"Engine Serial Number: 46783622<br/>Service Model Name: ISC CM2150\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 3,'+
		'          \"time\": \"15:28:25 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"action_equipment_details\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"label.equipment-details: STERLING, L8500</br>\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 4,'+
		'          \"time\": \"17:33:19 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"EXITED THE SESSION\",'+
		'              \"id\": 1'+
		'            }'+
		'          ]'+
		'        }'+
		'      ],'+
		'      \"solo\": \"online\",'+
		'      \"id\": 1,'+
		'      \"user\": \"scharette\"'+
		'    },'+
		'    {'+
		'      \"date\": \"28-APR-2016 \",'+
		'      \"times\": ['+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 1,'+
		'          \"time\": \"10:43:05 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Reassigned\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"Reassigning to: il204\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 2,'+
		'          \"time\": \"10:44:09 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Reassigned\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"Reassigning to: scharette\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 3,'+
		'          \"time\": \"10:46:06 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"action.changeDsProperty\",'+
		'              \"id\": 1'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 4,'+
		'          \"time\": \"15:55:29 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"CONTINUED THE SESSION\",'+
		'              \"id\": 1'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 5,'+
		'          \"time\": \"15:55:42 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"User Description/Search:\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"<i>white smoke</i><br/>Service Model Name: ISC CM2150<br/>Engine Serial Number: 46783622<br/>Exhaust Smoke Color:  White Smoke\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 6,'+
		'          \"time\": \"15:55:45 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Guided search\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"<i>white smoke</i><br/>Service Model Name: ISC CM2150<br/>Engine Serial Number: 46783622<br/>Exhaust Smoke Color:  White Smoke<br/>Fault Codes:  124\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 7,'+
		'          \"time\": \"15:55:47 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Solution Viewed\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"(#1) - /skdservice/rest/api/cmi_solution/K81518775?caseposition=1&DSID=DSBDT4730 - Stuck in-range intake manifold pressure sensor\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 8,'+
		'          \"time\": \"15:57:05 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Yes, this could be the solution.\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"(#1) - /skdservice/rest/api/cmi_solution/K81518775?caseposition=1&DSID=DSBDT4730 - Stuck in-range intake manifold pressure sensor<br/>Comment: test\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 9,'+
		'          \"time\": \"15:57:11 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Successful, problem solved.\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"(#1) - /skdservice/rest/api/cmi_solution/K81518775?caseposition=1&DSID=DSBDT4730 - Stuck in-range intake manifold pressure sensor<br/>Comment: test\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 10,'+
		'          \"time\": \"15:57:14 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"action_selectComponents\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"<span>label.for-solutionK81518775:</span><br/><span>Intake Manifold Pressure/Temperature Sensor</span><br>\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 11,'+
		'          \"time\": \"17:03:56 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Added an attachment.\",'+
		'              \"id\": 1'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 12,'+
		'          \"time\": \"19:04:09 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"EXITED THE SESSION\",'+
		'              \"id\": 1'+
		'            }'+
		'          ]'+
		'        }'+
		'      ],'+
		'      \"solo\": \"online\",'+
		'      \"id\": 2,'+
		'      \"user\": \"scharette\"'+
		'    },'+
		'    {'+
		'      \"date\": \"29-APR-2016 \",'+
		'      \"times\": ['+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 1,'+
		'          \"time\": \"12:53:40 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"CONTINUED THE SESSION\",'+
		'              \"id\": 1'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 2,'+
		'          \"time\": \"13:13:16 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"No, this is not the solution.\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"(#1) - /skdservice/rest/api/cmi_solution/K81518775?caseposition=1&DSID=DSBDT4730 - Stuck in-range intake manifold pressure sensor<br/>Comment: test\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 3,'+
		'          \"time\": \"13:15:37 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Yes, this could be the solution.\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"(#1) - /skdservice/rest/api/cmi_solution/K81518775?caseposition=1&DSID=DSBDT4730 - Stuck in-range intake manifold pressure sensor<br/>Comment: test\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 4,'+
		'          \"time\": \"13:15:46 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Successful with additional parts or steps.\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"(#1) - /skdservice/rest/api/cmi_solution/K81518775?caseposition=1&DSID=DSBDT4730 - Stuck in-range intake manifold pressure sensor<br/>Comment: test\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 5,'+
		'          \"time\": \"16:20:22 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"EXITED THE SESSION\",'+
		'              \"id\": 1'+
		'            }'+
		'          ]'+
		'        }'+
		'      ],'+
		'      \"solo\": \"online\",'+
		'      \"id\": 3,'+
		'      \"user\": \"scharette\"'+
		'    },'+
		'    {'+
		'      \"date\": \"04-MAY-2016 \",'+
		'      \"times\": ['+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 1,'+
		'          \"time\": \"16:11:13 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"CONTINUED THE SESSION\",'+
		'              \"id\": 1'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 2,'+
		'          \"time\": \"16:11:21 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Reset Search\",'+
		'              \"id\": 1'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 3,'+
		'          \"time\": \"16:11:39 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Recognized Search:\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"Service Model Name: ISC CM2150<br/>Engine Serial Number: 46783622\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 4,'+
		'          \"time\": \"16:11:42 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Guided search\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"Service Model Name: ISC CM2150<br/>Engine Serial Number: 46783622<br/>Fault Codes:  No Fault Codes\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 5,'+
		'          \"time\": \"16:11:49 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Guided search\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"Service Model Name: ISC CM2150<br/>Engine Serial Number: 46783622\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 6,'+
		'          \"time\": \"16:11:50 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Recognized Search:\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"Service Model Name: ISC CM2150<br/>Engine Serial Number: 46783622\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 7,'+
		'          \"time\": \"16:11:54 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"User Description/Search:\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"<i>black smoke</i><br/>Service Model Name: ISC CM2150<br/>Engine Serial Number: 46783622<br/>Exhaust Smoke Color:  Black Smoke\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 8,'+
		'          \"time\": \"16:11:56 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Guided search\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"<i>black smoke</i><br/>Service Model Name: ISC CM2150<br/>Engine Serial Number: 46783622<br/>Exhaust Smoke Color:  Black Smoke<br/>Fault Codes:  No Fault Codes\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 9,'+
		'          \"time\": \"16:14:32 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Guided search\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"<i>black smoke</i><br/>Service Model Name: ISC CM2150<br/>Engine Serial Number: 46783622<br/>Exhaust Smoke Color:  Black Smoke<br/>Fault Codes:  No Fault Codes<br/>Engine Performance Symptom:  Engine Decelerates Slowly\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 10,'+
		'          \"time\": \"16:14:50 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Guided search\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"<i>black smoke</i><br/>Service Model Name: ISC CM2150<br/>Engine Serial Number: 46783622<br/>Exhaust Smoke Color:  Black Smoke<br/>Fault Codes:  No Fault Codes\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 11,'+
		'          \"time\": \"16:14:56 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Guided search\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"<i>black smoke</i><br/>Service Model Name: ISC CM2150<br/>Engine Serial Number: 46783622<br/>Exhaust Smoke Color:  Black Smoke<br/>Fault Codes:  No Fault Codes<br/>Engine Performance Symptom:  Engine Run On\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 12,'+
		'          \"time\": \"16:14:59 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Guided search\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"<i>black smoke</i><br/>Service Model Name: ISC CM2150<br/>Engine Serial Number: 46783622<br/>Exhaust Smoke Color:  Black Smoke<br/>Fault Codes:  No Fault Codes\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 13,'+
		'          \"time\": \"16:26:26 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Guided search\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"<i>black smoke</i><br/>Service Model Name: ISC CM2150<br/>Engine Serial Number: 46783622<br/>Exhaust Smoke Color:  Black Smoke\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 14,'+
		'          \"time\": \"16:26:39 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Guided search\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"<i>black smoke</i><br/>Service Model Name: ISC CM2150<br/>Engine Serial Number: 46783622<br/>Exhaust Smoke Color:  Black Smoke<br/>Fault Codes:  No Fault Codes\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 15,'+
		'          \"time\": \"16:30:54 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"Guided search\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"<i>black smoke</i><br/>Service Model Name: ISC CM2150<br/>Engine Serial Number: 46783622<br/>Exhaust Smoke Color:  Black Smoke\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 16,'+
		'          \"time\": \"16:30:57 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"User Description/Search:\",'+
		'              \"id\": 1,'+
		'              \"detail\": \"<i>black smoke</i><br/>Service Model Name: ISC CM2150<br/>Engine Serial Number: 46783622\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 17,'+
		'          \"time\": \"17:00:10 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"EXITED THE SESSION\",'+
		'              \"id\": 1'+
		'            }'+
		'          ]'+
		'        }'+
		'      ],'+
		'      \"solo\": \"online\",'+
		'      \"id\": 4,'+
		'      \"user\": \"scharette\"'+
		'    },'+
		'    {'+
		'      \"date\": \"05-MAY-2016 \",'+
		'      \"times\": ['+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 1,'+
		'          \"time\": \"12:24:26 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"action.changeDsProperty\",'+
		'              \"id\": 1'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 2,'+
		'          \"time\": \"15:20:08 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"EXITED THE SESSION\",'+
		'              \"id\": 1'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 3,'+
		'          \"time\": \"15:49:04 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"CONTINUED THE SESSION\",'+
		'              \"id\": 1'+
		'            },'+
		'            {'+
		'              \"caption\": \"EXITED THE SESSION\",'+
		'              \"id\": 2'+
		'            }'+
		'          ]'+
		'        },'+
		'        {'+
		'          \"solo\": \"online\",'+
		'          \"id\": 4,'+
		'          \"time\": \"15:49:30 EDT\",'+
		'          \"actions\": ['+
		'            {'+
		'              \"caption\": \"CONTINUED THE SESSION\",'+
		'              \"id\": 1'+
		'            },'+
		'            {'+
		'              \"caption\": \"EXITED THE SESSION\",'+
		'              \"id\": 2'+
		'            }'+
		'          ]'+
		'        }'+
		'      ],'+
		'      \"solo\": \"online\",'+
		'      \"id\": 5,'+
		'      \"user\": \"scharette\"'+
		'    }'+
		'  ]'+
		'}';
		CSS_J2ADSIDDetails_EDS obj = CSS_J2ADSIDDetails_EDS.parse(json);
		System.assert(obj != null);
	}
}