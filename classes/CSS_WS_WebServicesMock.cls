@IsTest
Global Class CSS_WS_WebServicesMock implements HttpCalloutMock{

    Global HTTPResponse respond(HTTPRequest req){
        HttpResponse res;
        if(req.getEndpoint().contains('MxAuthClai')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"access_token":"YDrDcBwK3v5Z4knPMqw8LJuyk175erFKJxPdxN81nzfIrVKVO0prWS","token_type":"Bearer","expires_in":1200,"refresh_token":"1bdLXFA0rwhWAMWYMhyLPZrcidouGY7zeG6FXOelw2i4nX","scope":"CSSCloud"}');
            res.setStatusCode(200);  
        } else if(req.getEndpoint().contains('MxAuthEngi')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"access_token":"YDrDcBwK3v5Z4knPMqw8LJuyk175erFKJxPdxN81nzfIrVKVO0prWS","token_type":"Bearer","expires_in":1200,"refresh_token":"1bdLXFA0rwhWAMWYMhyLPZrcidouGY7zeG6FXOelw2i4nX","scope":"CSSCloud"}');
            res.setStatusCode(200);
        } else if(req.getEndpoint().contains('MxAuthServ')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"access_token":"YDrDcBwK3v5Z4knPMqw8LJuyk175erFKJxPdxN81nzfIrVKVO0prWS","token_type":"Bearer","expires_in":1200,"refresh_token":"1bdLXFA0rwhWAMWYMhyLPZrcidouGY7zeG6FXOelw2i4nX","scope":"CSSCloud"}');
            res.setStatusCode(200);
        } else if(req.getEndpoint().contains('MxAuthWarr')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"access_token":"YDrDcBwK3v5Z4knPMqw8LJuyk175erFKJxPdxN81nzfIrVKVO0prWS","token_type":"Bearer","expires_in":1200,"refresh_token":"1bdLXFA0rwhWAMWYMhyLPZrcidouGY7zeG6FXOelw2i4nX","scope":"CSSCloud"}');
            res.setStatusCode(200);
        } else if((req.getEndpoint()).contains('MxAccCov')){//Fake response data for WS_GetAccountCoverage
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
            '  \"DataArea\":{'+
            '    \"Details\":['+
            '      {'+
            '        \"CoveredTravelBaseFareAmt\": \"2022\",'+
            '        \"CoveredOCAmount\": \"1001\",'+
            '        \"CoveredLaborHrs\": \"1000\",'+
            '        \"CoveredTowingMiles\": \"111\",'+
            '        \"Message\": \"\",'+
            '        \"CampaignLaborPercentage\": \"0\",'+
            '        \"CoveredTravelLabor\": \"33\",'+
            '        \"CertificateNumber\": \"\",'+
            '        \"CampaignTowingPercentage\": \"0\",'+
            '        \"SystemCode\": \"BK\",'+
            '        \"AccountCodeType\": \"NEW-New Engine Warranty\",'+
            '        \"CoveredPartsQty\": \"100\",'+
            '        \"Status\": \"Success\",'+
            '        \"CampaignOCPercentage\": \"0\",'+
            '        \"DeductibleAmount\": \"500\",'+
            '        \"ComponentCode\": \"13\",'+
            '        \"PayCode\": \"R\",'+
            '        \"AccountCode\": \"67\",'+
            '        \"CampaignPartsPercentage\": \"0\",'+
            '        \"CoveredMealsLodgingAmt\": \"222\",'+
            '        \"WarrantyId\": \"1-UWN-482\",'+
            '        \"CoveredTravelMiles\": \"11\",'+
            '        \"CampaignTravelPercentage\": \"0\"'+
            '      }'+
            '    ],'+
            '    \"AccountCode\": \"67\",'+
            '    \"AccountCodeType\": \"NEW-New Engine Warranty\"'+
            '  },'+
            '  \"Header\": {'+
            '    \"ReturnCodeDescription\": \"\",'+
            '    \"Status\": \"Success\"'+
            '  }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_GetEngineData
        else if((req.getEndpoint()).contains('MxEngData')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
            '   \"DataArea\":{'+
            '      \"AutomotiveAppFlag\":\"N\",'+
            '      \"Model\":\"GMK5200\",'+
            '      \"Esn\":79384192,'+
            '      \"EtoConversionDate\":\"\",'+
            '      \"EngineAppCode\":130,'+
            '      \"MarineAppFlag\":\"Y\",'+
            '      \"EngineBillToCode\":\"\",'+
            '      \"EquipmentId\":\"CRANE\",'+
            '      \"CustomerName\":\"\",'+
            '      \"BuildDate\":\"2009-07-28T00:00:00.000-04:00\",'+
            '      \"Manufacturer\":\"GROVE\",'+
            '      \"EngineFamilyCode\":10,'+
            '      \"WarrantyStartDate\":\"2010-09-21T00:00:00.000-04:00\",'+
            '      \"ProdAppCode\":\"BB\",'+
            '      \"ServiceModelName\":\"ISX CM871\",'+
            '      \"AccessCode\":\"B\",'+
            '      \"ProdAppDesc\":\"AUTOMOTIVE\",'+
            '      \"EngineAppDesc\":\"AUTOMOTIVE\"'+
            '   },'+
            '   \"Header\":{'+
            '      \"Status\":\"Success\"'+
            '   }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_GetCampaignData
        else if((req.getEndpoint()).contains('MxCampData')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
        '  \"DataArea\": {'+
        '    \"Details\": ['+
        '      {'+
        '        \"InShopSrtLimitFlag\": \"N\",'+
        '        \"CampaignDesc\": \"ISX CYLINDER BLOCK/LINER COUNTERBORE REPAIR- US/CANADA\",'+
        '        \"CampaignEndDate\": \"2017-10-09\",'+
        '        \"CampaignStartDate\": \"2012-03-09\",'+
        '        \"PartList\": ['+
        '          {'+
        '            \"PartQuantity\": 5,'+
        '            \"PartNumber\": 288168200,'+
        '            \"PartDescription\": \"SET,PISTON RING\"'+
        '          },'+
        '          {'+
        '            \"PartQuantity\": 5,'+
        '            \"PartNumber\": 288171900,'+
        '            \"PartDescription\": \"KIT,LINER\"'+
        '          },'+
        '          {'+
        '            \"PartQuantity\": 5,'+
        '            \"PartNumber\": 288175600,'+
        '            \"PartDescription\": \"SET,PISTON RING\"'+
        '          },'+
        '          {'+
        '            \"PartQuantity\": 10,'+
        '            \"PartNumber\": 306430500,'+
        '            \"PartDescription\": \"RING,RETAINING\"'+
        '          },'+
        '          {'+
        '            \"PartQuantity\": 5,'+
        '            \"PartNumber\": 408915300,'+
        '            \"PartDescription\": \"KIT,LINER\"'+
        '          },'+
        '          {'+
        '            \"PartQuantity\": 5,'+
        '            \"PartNumber\": 529856400,'+
        '            \"PartDescription\": \"SHIM\"'+
        '          },'+
        '          {'+
        '            \"PartQuantity\": 5,'+
        '            \"PartNumber\": 529856500,'+
        '            \"PartDescription\": \"SHIM\"'+
        '          }'+
        '        ],'+
        '        \"SrtList\": ['+
        '          {'+
        '            \"SrtCode\": \"00-901-00\",'+
        '            \"SrtDescription\": \"Administrative Time - Open and Close Repair Order (Shop Repairs)\"'+
        '          },'+
        '          {'+
        '            \"SrtCode\": \"01-151-00\",'+
        '            \"SrtDescription\": \"Piston and Liner - Remove and Install, Each Additional\"'+
        '          },'+
        '          {'+
        '            \"SrtCode\": \"01-511-00\",'+
        '            \"SrtDescription\": \"Cylinder Block - Machine Counterbore Depth for Shims, Each Additional\"'+
        '          }'+
        '        ],'+
        '        \"CampaignNumber\": 1213,'+
        '        \"FailMode\": \"LB\",'+
        '        \"FailCode\": \"KCWB\"'+
        '      }'+
        '    ]'+
        '  },'+
        '  \"Header\": {'+
        '    \"Status\": \"Success\"'+
        '  }'+
        '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_ValidateMultiESN
        else if((req.getEndpoint()).contains('MxMultiESN')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
            '   \"DataArea\":{'+
            '      \"Details\":['+
            '         {'+
            '            \"Esn\":\"79384192\",'+
            '            \"WarrantyStartDate\":\"\",'+
            '            \"ValidationFlag\":\"N\"'+
            '         },'+
            '         {'+
            '            \"Esn\":\"35089518\",'+
            '            \"WarrantyStartDate\":\"\",'+
            '            \"ValidationFlag\":\"N\"'+
            '         }'+
            '      ]'+
            '   },'+
            '   \"Header\":{'+
            '      \"Status\":\"Success\"'+
            '   }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_GetSPData
        else if((req.getEndpoint()).contains('MxSPData')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
            '   \"DataArea\":{'+
            '      \"InShopLaborRate\":\"110\",'+
            '      \"FieldServiceLaborRate\":\"\",'+
            '      \"Region\":\"\",'+
            '      \"ChannelCode\":\"110\",'+
            '      \"Details\":['+
            '         {'+
            '            \"PromotionID\":\"B982732\",'+
            '            \"FirstName\":\"Name1\",'+
            '            \"LastName\":\"Bowers\"'+
            '         },'+
            '         {'+
            '            \"PromotionID\":\"B982732\",'+
            '            \"FirstName\":\"Name2\",'+
            '            \"LastName\":\"Bowers\"'+
            '         },'+
            '         {'+
            '            \"PromotionID\":\"B982732\",'+
            '            \"FirstName\":\"Name3\",'+
            '            \"LastName\":\"Bowers\"'+
            '         }'+
            '      ],'+
            '      \"TravelRate\":\"1\",'+
            '      \"Territory\":\"UNITED STATES\",'+
            '      \"ChannelOfDistribution\":\"110-DEALER\"'+
            '   },'+
            '   \"Header\":{'+
            '      \"Status\":\"Success\"'+
            '   }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_GetSRTData
        else if((req.getEndpoint()).contains('MxSRTData')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
            '   \"DataArea\":{'+
            '      \"Details\":['+
            '         {'+
            '            \"SRTDescription\":\"Lubricating Oil Pan - Remove and Install - QSF3.8 CM2350 F107\",'+
            '            \"HrsUnit\":\"0.8\",'+
            '            \"StepId\":\"12345\",'+
            '            \"SRTCode\":\"07-018-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Bearings, Main - Remove and Install, First Pair  - QSF3.8 CM2350 F118\",'+
            '            \"HrsUnit\":\"3.8\",'+
            '            \"StepId\":\"12345\",'+
            '            \"SRTCode\":\"01-0C8-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Turbocharger Wastegate Actuator - Remove and Install - QSF3.8 CM2350 F119\",'+
            '            \"HrsUnit\":\"0.6\",'+
            '            \"StepId\":\"12345\",'+
            '            \"SRTCode\":\"10-05P-00\"'+
            '         },'+            
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - ECM No Communication, Check With Bench Top Harness\",'+
            '            \"HrsUnit\":\"0\",'+
            '            \"StepId\":\"12345\",'+
            '            \"SRTCode\":\"TT-022-07\"'+
            '         }'+
            '      ]'+
            '   },'+
            '   \"Header\":{'+
            '      \"Status\":\"Success\"'+
            '   }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_GetSRTOverlap2
        else if((req.getEndpoint()).contains('MxSRTOver2')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
            '  \"DataArea\": {'+
            '    \"TotalOverlapHours\": 2.1,'+
            '    \"Steps\": ['+
            '      {'+
            '        \"Qty\": 1,'+
            '        \"OverlapTime\": ['+
            '          {'+
            '            \"SRTNumber\": \"\",'+
            '            \"OverlapHrs\": 0'+
            '          }'+
            '        ],'+
            '        \"SRTHours\": 0.3,'+
            '        \"SRTAdjustedHours\": 0.2,'+
            '        \"StepId\": 134357,'+
            '        \"AccessCode\": \"C\"'+
            '      },'+
            '      {'+
            '        \"Qty\": 2,'+
            '        \"OverlapTime\": ['+
            '          {'+
            '            \"SRTNumber\": \"\",'+
            '            \"OverlapHrs\": 0'+
            '          }'+
            '        ],'+
            '        \"SRTHours\": 0.9,'+
            '        \"SRTAdjustedHours\": 1.8,'+
            '        \"StepId\": 134072,'+
            '        \"AccessCode\": \"C\"'+
            '      }'+
            '    ],'+
            '    \"TotalAdjustedHours\": 2'+
            '  },'+
            '  \"Header\": {'+
            '    \"ReturnCodeDescription\": \"Normal, Successful completion.\",'+
            '    \"ReturnCode\": \"ORA-00000\",'+
            '    \"Status\": \"Error\",'+
            '    \"MessageIdentifier\": \"S\"'+
            '  }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }        
        // Fake response data for WS_GetSRTOverlap
        else if((req.getEndpoint()).contains('MxSRTOver')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
            '  \"DataArea\": {'+
            '    \"Details\": ['+
            '      {'+
            '        \"Name\": \"\",'+
            '        \"OverlapHours\": \"0.00\",'+
            '        \"SrtQty\": \"0\",'+
            '        \"Claim\": \"\",'+
            '        \"SrtCode\": \"01-03H-00\",'+
            '        \"EngineFamilyCode\": \"46\",'+
            '        \"SrtAccessCode\": \"A\",'+
            '        \"FailureLine\": \"\"'+
            '      }'+
            '    ]'+
            '  },'+
            '  \"Header\": {'+
            '    \"Status\": \"Success\"'+
            '  }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }    
        // Fake response data for WS_GetPartsData
        else if((req.getEndpoint()).contains('MxPrtsData')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
            '   \"DataArea\":{'+
            '      \"PartNumberLong\":\"006439500\",'+
            '      \"KitPartFlag\":\"N\",'+
            '      \"SupersededPartNumber\":\"\",'+
            '      \"PartDescription\":\"GSK,COV\",'+
            '      \"PartProductCode\":\"ABC\",'+
            '      \"PartInService\":\"Y\"'+
            '   },'+
            '   \"Header\":{'+
            '      \"Status\":\"Success\"'+
            '   }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_CreateStatementMX
        else if((req.getEndpoint()).contains('MxCreatStm')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
            '   \"Header\": {'+
            '       \"Status\": \"success\",'+
            '       \"ReturnCodeDescription\": \"message_ifany\"'+
            '   },'+
            '   \"DataArea\": {'+
            '       \"MsgTransaction\": \"msg_transaction\",'+
            '       \"MsgDescription\": \"msg_description\"'+
            '   }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_GetStatementMX
        else if((req.getEndpoint()).contains('getStatementMX')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
            '   \"Header\": {'+
            '       \"Status\": \"success\",'+
            '       \"ReturnCodeDescription\": \"message_ifany\"'+
            '   },'+
            '   \"DataArea\": {'+
            '       \"MsgTransaction\": \"msg_transaction\",'+
            '       \"MsgDescription\": \"msg_description\"'+
            '   }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_GetCurrencyExchange
        else if((req.getEndpoint()).contains('getCurrencyExchange')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
            '   \"Header\": {'+
            '       \"Status\": \"success\",'+
            '       \"ReturnCodeDescription\": \"message_ifany\"'+
            '   },'+
            '   \"DataArea\": {'+
            '       \"ConversionRate\": \"150.00\"'+
            '   }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_GetCSSAmount
        else if((req.getEndpoint()).contains('getCssAmount')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
            '   \"Header\": {'+
            '       \"Status\": \"success\",'+
            '       \"ReturnCodeDescription\": \"message_ifany\"'+
            '   },'+
            '   \"DataArea\": {'+
            '       \"Status\": \"Success/Error\",'+
            '       \"ErrorMessage\": \"Error Message if any\"'+
            '   }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_ODM - HEADER
        else if((req.getEndpoint()).contains('MxHeadVal')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
             '  \"Response\": {'+
            '    \"DecisionID\": \"param:DecisionID\",'+
            '    \"claim\": {'+
            '      \"groupName\": \"group_name\",'+
            '      \"historyClaimFlag\": \"N\",'+
            '      \"reconPartsWarrantyFlag\": \"N\",'+
            '      \"claimReceivedDate\": \"2006-08-19T13:27:14-04:00\",'+
            '      \"failureDate\": \"2009-05-16T08:42:28\",'+
            '      \"cmiEngineSerialNumber\": \"73279794\",'+
            '      \"multiESNFlag\": \"N\",'+
            '      \"parts\": {'+
            '        \"reconPartFlag\": \"recon_part_flag\",'+
            '        \"partName\": \"part_name\",'+
            '        \"partPrice\": 150,'+
            '        \"lineNumber\": \"line_number\",'+
            '        \"partId\": \"part_id\",'+
            '        \"partAllowedFlag\": \"partAllowedFlag\",'+
            '        \"priceBook\": \"price_book\"'+
            '      },'+
            '      \"claimSource\": \"Mexico\",'+
            '      \"totalClaimAmt\": \"total_claim_Amt\",'+
            '      \"messages\": ['+
            '        {'+
            '          \"description\": \"Part # changed to universal PN\",'+
            '          \"code\": \"ODM-US-PA-WAR-402\",'+
            '          \"type\": \"WARNING\"'+
            '        },'+
            '        {'+
            '          \"description\": \"Part price not found for exception PriceBook: 015119 _17_CHNGOMS\",'+
            '          \"code\": \"\",'+
            '          \"type\": \"\"'+
            '        }'+
            '      ],'+
            '      \"distributorCode\": \"distributor_code\",'+
            '      \"roNumber\": \"RONUM2\",'+
            '      \"serviceModelName\": \"ISC8.3 CM2250\",'+
            '      \"engineApplicationCode\": \"engine_application_code\",'+
            '      \"warrantyStartDate\": \"2012-06-04\",'+
            '      \"serviceProvider\": {'+
            '        \"region\": \"NORTH AMERICA\",'+
            '        \"channelOfDistribution\": \"110\",'+
            '        \"regionCode\": \"USCA\",'+
            '        \"territory\": \"10\",'+
            '        \"status\": \"status\",'+
            '        \"inactiveDate\": \"2012-09-13T09:00:34-04:00\",'+
            '        \"outfileAllClaimsFlag\": \"Y\",'+
            '        \"claimAllowedDays\": 300'+
            '      },'+
            '      \"engineFamily\": \"6C\",'+
            '      \"srtList\": {'+
            '        \"description\": \"Temperature Sending Unit, Engine-Mounted - Replace\",'+
            '        \"hours\": 150,'+
            '        \"offsiteCheck\": \"N\",'+
            '        \"lineNumber\": \"1\",'+
            '        \"quantity\": \"1\",'+
            '        \"code\": \"21-315-00\",'+
            '        \"srtAllowedFlag\": \"srtAllowedFlag\",'+
            '        \"penalty\": 3'+
            '      },'+
            '      \"failurePoint\": 10,'+
            '      \"ownerName\": \"owner_name\",'+
            '      \"serviceProviderName\": \"service_provider_name\",'+
            '      \"engine\": {'+
            '        \"productApplicationDesp\": \"product_application_desp\",'+
            '        \"marineFlag\": \"N\",'+
            '        \"warrantyIndicatorFlag\": \"Y\",'+
            '        \"buildDate\": \"2009-10-14T03:16:36\",'+
            '        \"billToCode\": \"bill_to_code\",'+
            '        \"etoConversionDate\": \"2010-03-18T12:05:32\",'+
            '        \"oemCode\": \"oem_code\"'+
            '      },'+
            '      \"productApplicationCode\": \"BB\",'+
            '      \"status\": \"SUCCESS\",'+
            '      \"claimStatus\": \"Draft\",'+
            '      \"failureMeasure\": \"Miles\",'+
            '      \"claimSubmittedDate\": \"2014-09-18T19:18:33\",'+
            '      \"eto\": {'+
            '        \"status\": \"status\"'+
            '      },'+
            '      \"failure\": {'+
            '        \"campaignId\": \"campaign_id\",'+
            '        \"accountCodeDesp\": \"account_code_desp\",'+
            '        \"payCode\": \"D\",'+
            '        \"totalLaborAmt\": \"total_labor_amt\",'+
            '        \"status\": \"status\",'+
            '        \"authorizationNumber\": \"authorization_number\",'+
            '        \"approvalCode\": \"approval_code\",'+
            '        \"acctCodeInfo\": {'+
            '          \"chryslerFlag\": \"N\",'+
            '          \"accountCodeType\": \"account_code_type\",'+
            '          \"multiESNFlag\": \"N\"'+
            '        },'+
            '        \"totalTowingAmt\": \"total_towing_amt\",'+
            '        \"accountCode\": \"67\",'+
            '        \"failCode\": \"BK13\",'+
            '        \"coverageType\": \"coverage_type\",'+
            '        \"failMode\": \"21\",'+
            '        \"lineNumber\": \"1\",'+
            '        \"totalSRTHours\": \"total_srt_hours\",'+
            '        \"inShopCampaignFlag\": \"inShopCampaignFlag\",'+
            '        \"campaign\": {'+
            '          \"accountCode\": \"account_code\",'+
            '          \"engineComponentCode\": \"engine_component_code\",'+
            '          \"campaignId\": \"campaign_id\",'+
            '          \"completeIndicator\": \"complete_indicator\",'+
            '          \"campaignType\": \"campaign_type\",'+
            '          \"status\": \"status\",'+
            '          \"systemCode\": \"system_code\",'+
            '          \"failMode\": \"fail_mode\",'+
            '          \"expiryDateNA\": \"2014-06-10T14:33:25-04:00\",'+
            '          \"effectiveDate\": \"2018-12-28T14:51:14-05:00\",'+
            '          \"multiFlag\": \"N\",'+
            '          \"expiryDateIntl\": \"2017-11-01T04:15:53-04:00\"'+
            '        }'+
            '      },'+
            '      \"cmiServiceProviderCode\": \"37320\",'+
            '      \"travels\": {'+
            '        \"mealsCharges\": 10,'+
            '        \"towingCharges\": 2,'+
            '        \"hours\": 2,'+
            '        \"lineNumber\": \"1\",'+
            '        \"travelDistance\": 3'+
            '      },'+
            '      \"otherClaimables\": {'+
            '        \"Amount\": \"300\",'+
            '        \"details\": \"details\",'+
            '        \"item\": \"1-DCU6\",'+
            '        \"lineNumber\": \"1\"'+
            '      },'+
            '      \"manualAdjudicationFlag\": \"N\",'+
            '      \"claimCreatedDate\": \"2008-09-28T21:49:45\",'+
            '      \"bisFlag\": \"N\",'+
            '      \"claimNumber\": \"1-12091495\"'+
            '    }'+
            '  }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_ODM - FAILURE
        else if((req.getEndpoint()).contains('MxFailVal')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
             '  \"Response\": {'+
            '    \"DecisionID\": \"param:DecisionID\",'+
            '    \"claim\": {'+
            '      \"groupName\": \"group_name\",'+
            '      \"historyClaimFlag\": \"N\",'+
            '      \"reconPartsWarrantyFlag\": \"N\",'+
            '      \"claimReceivedDate\": \"2006-08-19T13:27:14-04:00\",'+
            '      \"failureDate\": \"2009-05-16T08:42:28\",'+
            '      \"cmiEngineSerialNumber\": \"73279794\",'+
            '      \"multiESNFlag\": \"N\",'+
            '      \"parts\": {'+
            '        \"reconPartFlag\": \"recon_part_flag\",'+
            '        \"partName\": \"part_name\",'+
            '        \"partPrice\": 150,'+
            '        \"lineNumber\": \"line_number\",'+
            '        \"partId\": \"part_id\",'+
            '        \"partAllowedFlag\": \"partAllowedFlag\",'+
            '        \"priceBook\": \"price_book\"'+
            '      },'+
            '      \"claimSource\": \"Mexico\",'+
            '      \"totalClaimAmt\": \"total_claim_Amt\",'+
            '      \"messages\": ['+
            '        {'+
            '          \"description\": \"Part # changed to universal PN\",'+
            '          \"code\": \"ODM-US-PA-WAR-402\",'+
            '          \"type\": \"WARNING\"'+
            '        },'+
            '        {'+
            '          \"description\": \"Part price not found for exception PriceBook: 015119 _17_CHNGOMS\",'+
            '          \"code\": \"\",'+
            '          \"type\": \"\"'+
            '        }'+
            '      ],'+
            '      \"distributorCode\": \"distributor_code\",'+
            '      \"roNumber\": \"RONUM2\",'+
            '      \"serviceModelName\": \"ISC8.3 CM2250\",'+
            '      \"engineApplicationCode\": \"engine_application_code\",'+
            '      \"warrantyStartDate\": \"2012-06-04\",'+
            '      \"serviceProvider\": {'+
            '        \"region\": \"NORTH AMERICA\",'+
            '        \"channelOfDistribution\": \"110\",'+
            '        \"regionCode\": \"USCA\",'+
            '        \"territory\": \"10\",'+
            '        \"status\": \"status\",'+
            '        \"inactiveDate\": \"2012-09-13T09:00:34-04:00\",'+
            '        \"outfileAllClaimsFlag\": \"Y\",'+
            '        \"claimAllowedDays\": 300'+
            '      },'+
            '      \"engineFamily\": \"6C\",'+
            '      \"srtList\": {'+
            '        \"description\": \"Temperature Sending Unit, Engine-Mounted - Replace\",'+
            '        \"hours\": 150,'+
            '        \"offsiteCheck\": \"N\",'+
            '        \"lineNumber\": \"1\",'+
            '        \"quantity\": \"1\",'+
            '        \"code\": \"21-315-00\",'+
            '        \"srtAllowedFlag\": \"srtAllowedFlag\",'+
            '        \"penalty\": 3'+
            '      },'+
            '      \"failurePoint\": 10,'+
            '      \"ownerName\": \"owner_name\",'+
            '      \"serviceProviderName\": \"service_provider_name\",'+
            '      \"engine\": {'+
            '        \"productApplicationDesp\": \"product_application_desp\",'+
            '        \"marineFlag\": \"N\",'+
            '        \"warrantyIndicatorFlag\": \"Y\",'+
            '        \"buildDate\": \"2009-10-14T03:16:36\",'+
            '        \"billToCode\": \"bill_to_code\",'+
            '        \"etoConversionDate\": \"2010-03-18T12:05:32\",'+
            '        \"oemCode\": \"oem_code\"'+
            '      },'+
            '      \"productApplicationCode\": \"BB\",'+
            '      \"status\": \"SUCCESS\",'+
            '      \"claimStatus\": \"Draft\",'+
            '      \"failureMeasure\": \"Miles\",'+
            '      \"claimSubmittedDate\": \"2014-09-18T19:18:33\",'+
            '      \"eto\": {'+
            '        \"status\": \"status\"'+
            '      },'+
            '      \"failure\": {'+
            '        \"campaignId\": \"campaign_id\",'+
            '        \"accountCodeDesp\": \"account_code_desp\",'+
            '        \"payCode\": \"D\",'+
            '        \"totalLaborAmt\": \"total_labor_amt\",'+
            '        \"status\": \"status\",'+
            '        \"authorizationNumber\": \"authorization_number\",'+
            '        \"approvalCode\": \"approval_code\",'+
            '        \"acctCodeInfo\": {'+
            '          \"chryslerFlag\": \"N\",'+
            '          \"accountCodeType\": \"account_code_type\",'+
            '          \"multiESNFlag\": \"N\"'+
            '        },'+
            '        \"totalTowingAmt\": \"total_towing_amt\",'+
            '        \"accountCode\": \"67\",'+
            '        \"failCode\": \"BK13\",'+
            '        \"coverageType\": \"coverage_type\",'+
            '        \"failMode\": \"21\",'+
            '        \"lineNumber\": \"1\",'+
            '        \"totalSRTHours\": \"total_srt_hours\",'+
            '        \"inShopCampaignFlag\": \"inShopCampaignFlag\",'+
            '        \"campaign\": {'+
            '          \"accountCode\": \"account_code\",'+
            '          \"engineComponentCode\": \"engine_component_code\",'+
            '          \"campaignId\": \"campaign_id\",'+
            '          \"completeIndicator\": \"complete_indicator\",'+
            '          \"campaignType\": \"campaign_type\",'+
            '          \"status\": \"status\",'+
            '          \"systemCode\": \"system_code\",'+
            '          \"failMode\": \"fail_mode\",'+
            '          \"expiryDateNA\": \"2014-06-10T14:33:25-04:00\",'+
            '          \"effectiveDate\": \"2018-12-28T14:51:14-05:00\",'+
            '          \"multiFlag\": \"N\",'+
            '          \"expiryDateIntl\": \"2017-11-01T04:15:53-04:00\"'+
            '        }'+
            '      },'+
            '      \"cmiServiceProviderCode\": \"37320\",'+
            '      \"travels\": {'+
            '        \"mealsCharges\": 10,'+
            '        \"towingCharges\": 2,'+
            '        \"hours\": 2,'+
            '        \"lineNumber\": \"1\",'+
            '        \"travelDistance\": 3'+
            '      },'+
            '      \"otherClaimables\": {'+
            '        \"Amount\": \"300\",'+
            '        \"details\": \"details\",'+
            '        \"item\": \"1-DCU6\",'+
            '        \"lineNumber\": \"1\"'+
            '      },'+
            '      \"manualAdjudicationFlag\": \"N\",'+
            '      \"claimCreatedDate\": \"2008-09-28T21:49:45\",'+
            '      \"bisFlag\": \"N\",'+
            '      \"claimNumber\": \"1-12091495\"'+
            '    }'+
            '  }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_ODM - PARTS
        else if((req.getEndpoint()).contains('MxPrtsVal')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
             '  \"Response\": {'+
            '    \"DecisionID\": \"param:DecisionID\",'+
            '    \"claim\": {'+
            '      \"groupName\": \"group_name\",'+
            '      \"historyClaimFlag\": \"N\",'+
            '      \"reconPartsWarrantyFlag\": \"N\",'+
            '      \"claimReceivedDate\": \"2006-08-19T13:27:14-04:00\",'+
            '      \"failureDate\": \"2009-05-16T08:42:28\",'+
            '      \"cmiEngineSerialNumber\": \"73279794\",'+
            '      \"multiESNFlag\": \"N\",'+
            '      \"parts\": {'+
            '        \"reconPartFlag\": \"recon_part_flag\",'+
            '        \"partName\": \"part_name\",'+
            '        \"partPrice\": 150,'+
            '        \"lineNumber\": \"line_number\",'+
            '        \"partId\": \"part_id\",'+
            '        \"partAllowedFlag\": \"partAllowedFlag\",'+
            '        \"partsProductCode\": \"partsProductCode\",'+
            '        \"priceBook\": \"price_book\"'+
            '      },'+
            '      \"claimSource\": \"Mexico\",'+
            '      \"totalClaimAmt\": \"total_claim_Amt\",'+
            '      \"messages\": ['+
            '        {'+
            '          \"description\": \"Part # changed to universal PN\",'+
            '          \"code\": \"ODM-US-PA-WAR-402\",'+
            '          \"type\": \"WARNING\"'+
            '        },'+
            '        {'+
            '          \"description\": \"Part price not found for exception PriceBook: 015119 _17_CHNGOMS\",'+
            '          \"code\": \"\",'+
            '          \"type\": \"\"'+
            '        }'+
            '      ],'+
            '      \"distributorCode\": \"distributor_code\",'+
            '      \"roNumber\": \"RONUM2\",'+
            '      \"serviceModelName\": \"ISC8.3 CM2250\",'+
            '      \"engineApplicationCode\": \"engine_application_code\",'+
            '      \"warrantyStartDate\": \"2012-06-04\",'+
            '      \"serviceProvider\": {'+
            '        \"region\": \"NORTH AMERICA\",'+
            '        \"channelOfDistribution\": \"110\",'+
            '        \"regionCode\": \"USCA\",'+
            '        \"territory\": \"10\",'+
            '        \"status\": \"status\",'+
            '        \"inactiveDate\": \"2012-09-13T09:00:34-04:00\",'+
            '        \"outfileAllClaimsFlag\": \"Y\",'+
            '        \"claimAllowedDays\": 300'+
            '      },'+
            '      \"engineFamily\": \"6C\",'+
            '      \"srtList\": {'+
            '        \"description\": \"Temperature Sending Unit, Engine-Mounted - Replace\",'+
            '        \"hours\": 150,'+
            '        \"offsiteCheck\": \"N\",'+
            '        \"lineNumber\": \"1\",'+
            '        \"quantity\": \"1\",'+
            '        \"code\": \"21-315-00\",'+
            '        \"srtAllowedFlag\": \"srtAllowedFlag\",'+
            '        \"penalty\": 3'+
            '      },'+
            '      \"failurePoint\": 10,'+
            '      \"ownerName\": \"owner_name\",'+
            '      \"serviceProviderName\": \"service_provider_name\",'+
            '      \"engine\": {'+
            '        \"productApplicationDesp\": \"product_application_desp\",'+
            '        \"marineFlag\": \"N\",'+
            '        \"warrantyIndicatorFlag\": \"Y\",'+
            '        \"buildDate\": \"2009-10-14T03:16:36\",'+
            '        \"billToCode\": \"bill_to_code\",'+
            '        \"etoConversionDate\": \"2010-03-18T12:05:32\",'+
            '        \"oemCode\": \"oem_code\"'+
            '      },'+
            '      \"productApplicationCode\": \"BB\",'+
            '      \"status\": \"SUCCESS\",'+
            '      \"claimStatus\": \"Draft\",'+
            '      \"failureMeasure\": \"Miles\",'+
            '      \"claimSubmittedDate\": \"2014-09-18T19:18:33\",'+
            '      \"eto\": {'+
            '        \"status\": \"status\"'+
            '      },'+
            '      \"failure\": {'+
            '        \"campaignId\": \"campaign_id\",'+
            '        \"accountCodeDesp\": \"account_code_desp\",'+
            '        \"payCode\": \"D\",'+
            '        \"totalLaborAmt\": \"total_labor_amt\",'+
            '        \"status\": \"status\",'+
            '        \"authorizationNumber\": \"authorization_number\",'+
            '        \"approvalCode\": \"approval_code\",'+
            '        \"acctCodeInfo\": {'+
            '          \"chryslerFlag\": \"N\",'+
            '          \"accountCodeType\": \"account_code_type\",'+
            '          \"multiESNFlag\": \"N\"'+
            '        },'+
            '        \"totalTowingAmt\": \"total_towing_amt\",'+
            '        \"accountCode\": \"67\",'+
            '        \"failCode\": \"BK13\",'+
            '        \"coverageType\": \"coverage_type\",'+
            '        \"failMode\": \"21\",'+
            '        \"lineNumber\": \"1\",'+
            '        \"totalSRTHours\": \"total_srt_hours\",'+
            '        \"inShopCampaignFlag\": \"inShopCampaignFlag\",'+
            '        \"campaign\": {'+
            '          \"accountCode\": \"account_code\",'+
            '          \"engineComponentCode\": \"engine_component_code\",'+
            '          \"campaignId\": \"campaign_id\",'+
            '          \"completeIndicator\": \"complete_indicator\",'+
            '          \"campaignType\": \"campaign_type\",'+
            '          \"status\": \"status\",'+
            '          \"systemCode\": \"system_code\",'+
            '          \"failMode\": \"fail_mode\",'+
            '          \"expiryDateNA\": \"2014-06-10T14:33:25-04:00\",'+
            '          \"effectiveDate\": \"2018-12-28T14:51:14-05:00\",'+
            '          \"multiFlag\": \"N\",'+
            '          \"expiryDateIntl\": \"2017-11-01T04:15:53-04:00\"'+
            '        }'+
            '      },'+
            '      \"cmiServiceProviderCode\": \"37320\",'+
            '      \"travels\": {'+
            '        \"mealsCharges\": 10,'+
            '        \"towingCharges\": 2,'+
            '        \"hours\": 2,'+
            '        \"lineNumber\": \"1\",'+
            '        \"travelDistance\": 3'+
            '      },'+
            '      \"otherClaimables\": {'+
            '        \"Amount\": \"300\",'+
            '        \"details\": \"details\",'+
            '        \"item\": \"1-DCU6\",'+
            '        \"lineNumber\": \"1\"'+
            '      },'+
            '      \"manualAdjudicationFlag\": \"N\",'+
            '      \"claimCreatedDate\": \"2008-09-28T21:49:45\",'+
            '      \"bisFlag\": \"N\",'+
            '      \"claimNumber\": \"1-12091495\"'+
            '    }'+
            '  }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_ODM - TRAVEL
        else if((req.getEndpoint()).contains('MxTraVal')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
             '  \"Response\": {'+
            '    \"DecisionID\": \"param:DecisionID\",'+
            '    \"claim\": {'+
            '      \"groupName\": \"group_name\",'+
            '      \"historyClaimFlag\": \"N\",'+
            '      \"reconPartsWarrantyFlag\": \"N\",'+
            '      \"claimReceivedDate\": \"2006-08-19T13:27:14-04:00\",'+
            '      \"failureDate\": \"2009-05-16T08:42:28\",'+
            '      \"cmiEngineSerialNumber\": \"73279794\",'+
            '      \"multiESNFlag\": \"N\",'+
            '      \"parts\": {'+
            '        \"reconPartFlag\": \"recon_part_flag\",'+
            '        \"partName\": \"part_name\",'+
            '        \"partPrice\": 150,'+
            '        \"lineNumber\": \"line_number\",'+
            '        \"partId\": \"part_id\",'+
            '        \"partAllowedFlag\": \"partAllowedFlag\",'+
            '        \"priceBook\": \"price_book\"'+
            '      },'+
            '      \"claimSource\": \"Mexico\",'+
            '      \"totalClaimAmt\": \"total_claim_Amt\",'+
            '      \"messages\": ['+
            '        {'+
            '          \"description\": \"Part # changed to universal PN\",'+
            '          \"code\": \"ODM-US-PA-WAR-402\",'+
            '          \"type\": \"WARNING\"'+
            '        },'+
            '        {'+
            '          \"description\": \"Part price not found for exception PriceBook: 015119 _17_CHNGOMS\",'+
            '          \"code\": \"\",'+
            '          \"type\": \"\"'+
            '        }'+
            '      ],'+
            '      \"distributorCode\": \"distributor_code\",'+
            '      \"roNumber\": \"RONUM2\",'+
            '      \"serviceModelName\": \"ISC8.3 CM2250\",'+
            '      \"engineApplicationCode\": \"engine_application_code\",'+
            '      \"warrantyStartDate\": \"2012-06-04\",'+
            '      \"serviceProvider\": {'+
            '        \"region\": \"NORTH AMERICA\",'+
            '        \"channelOfDistribution\": \"110\",'+
            '        \"regionCode\": \"USCA\",'+
            '        \"territory\": \"10\",'+
            '        \"status\": \"status\",'+
            '        \"inactiveDate\": \"2012-09-13T09:00:34-04:00\",'+
            '        \"outfileAllClaimsFlag\": \"Y\",'+
            '        \"claimAllowedDays\": 300'+
            '      },'+
            '      \"engineFamily\": \"6C\",'+
            '      \"srtList\": {'+
            '        \"description\": \"Temperature Sending Unit, Engine-Mounted - Replace\",'+
            '        \"hours\": 150,'+
            '        \"offsiteCheck\": \"N\",'+
            '        \"lineNumber\": \"1\",'+
            '        \"quantity\": \"1\",'+
            '        \"code\": \"21-315-00\",'+
            '        \"srtAllowedFlag\": \"srtAllowedFlag\",'+
            '        \"penalty\": 3'+
            '      },'+
            '      \"failurePoint\": 10,'+
            '      \"ownerName\": \"owner_name\",'+
            '      \"serviceProviderName\": \"service_provider_name\",'+
            '      \"engine\": {'+
            '        \"productApplicationDesp\": \"product_application_desp\",'+
            '        \"marineFlag\": \"N\",'+
            '        \"warrantyIndicatorFlag\": \"Y\",'+
            '        \"buildDate\": \"2009-10-14T03:16:36\",'+
            '        \"billToCode\": \"bill_to_code\",'+
            '        \"etoConversionDate\": \"2010-03-18T12:05:32\",'+
            '        \"oemCode\": \"oem_code\"'+
            '      },'+
            '      \"productApplicationCode\": \"BB\",'+
            '      \"status\": \"SUCCESS\",'+
            '      \"claimStatus\": \"Draft\",'+
            '      \"failureMeasure\": \"Miles\",'+
            '      \"claimSubmittedDate\": \"2014-09-18T19:18:33\",'+
            '      \"eto\": {'+
            '        \"status\": \"status\"'+
            '      },'+
            '      \"failure\": {'+
            '        \"campaignId\": \"campaign_id\",'+
            '        \"accountCodeDesp\": \"account_code_desp\",'+
            '        \"payCode\": \"D\",'+
            '        \"totalLaborAmt\": \"total_labor_amt\",'+
            '        \"status\": \"status\",'+
            '        \"authorizationNumber\": \"authorization_number\",'+
            '        \"approvalCode\": \"approval_code\",'+
            '        \"acctCodeInfo\": {'+
            '          \"chryslerFlag\": \"N\",'+
            '          \"accountCodeType\": \"account_code_type\",'+
            '          \"multiESNFlag\": \"N\"'+
            '        },'+
            '        \"totalTowingAmt\": \"total_towing_amt\",'+
            '        \"accountCode\": \"67\",'+
            '        \"failCode\": \"BK13\",'+
            '        \"coverageType\": \"coverage_type\",'+
            '        \"failMode\": \"21\",'+
            '        \"lineNumber\": \"1\",'+
            '        \"totalSRTHours\": \"total_srt_hours\",'+
            '        \"inShopCampaignFlag\": \"inShopCampaignFlag\",'+
            '        \"campaign\": {'+
            '          \"accountCode\": \"account_code\",'+
            '          \"engineComponentCode\": \"engine_component_code\",'+
            '          \"campaignId\": \"campaign_id\",'+
            '          \"completeIndicator\": \"complete_indicator\",'+
            '          \"campaignType\": \"campaign_type\",'+
            '          \"status\": \"status\",'+
            '          \"systemCode\": \"system_code\",'+
            '          \"failMode\": \"fail_mode\",'+
            '          \"expiryDateNA\": \"2014-06-10T14:33:25-04:00\",'+
            '          \"effectiveDate\": \"2018-12-28T14:51:14-05:00\",'+
            '          \"multiFlag\": \"N\",'+
            '          \"expiryDateIntl\": \"2017-11-01T04:15:53-04:00\"'+
            '        }'+
            '      },'+
            '      \"cmiServiceProviderCode\": \"37320\",'+
            '      \"travels\": {'+
            '        \"mealsCharges\": 10,'+
            '        \"towingCharges\": 2,'+
            '        \"hours\": 2,'+
            '        \"lineNumber\": \"1\",'+
            '        \"travelDistance\": 3'+
            '      },'+
            '      \"otherClaimables\": {'+
            '        \"Amount\": \"300\",'+
            '        \"details\": \"details\",'+
            '        \"item\": \"1-DCU6\",'+
            '        \"lineNumber\": \"1\"'+
            '      },'+
            '      \"manualAdjudicationFlag\": \"N\",'+
            '      \"claimCreatedDate\": \"2008-09-28T21:49:45\",'+
            '      \"bisFlag\": \"N\",'+
            '      \"claimNumber\": \"1-12091495\"'+
            '    }'+
            '  }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_ODM - OTHER CLAIMABLES
        else if((req.getEndpoint()).contains('MxOCVal')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
             '  \"Response\": {'+
            '    \"DecisionID\": \"param:DecisionID\",'+
            '    \"claim\": {'+
            '      \"groupName\": \"group_name\",'+
            '      \"historyClaimFlag\": \"N\",'+
            '      \"reconPartsWarrantyFlag\": \"N\",'+
            '      \"claimReceivedDate\": \"2006-08-19T13:27:14-04:00\",'+
            '      \"failureDate\": \"2009-05-16T08:42:28\",'+
            '      \"cmiEngineSerialNumber\": \"73279794\",'+
            '      \"multiESNFlag\": \"N\",'+
            '      \"parts\": {'+
            '        \"reconPartFlag\": \"recon_part_flag\",'+
            '        \"partName\": \"part_name\",'+
            '        \"partPrice\": 150,'+
            '        \"lineNumber\": \"line_number\",'+
            '        \"partId\": \"part_id\",'+
            '        \"partAllowedFlag\": \"partAllowedFlag\",'+
            '        \"priceBook\": \"price_book\"'+
            '      },'+
            '      \"claimSource\": \"Mexico\",'+
            '      \"totalClaimAmt\": \"total_claim_Amt\",'+
            '      \"messages\": ['+
            '        {'+
            '          \"description\": \"Part # changed to universal PN\",'+
            '          \"code\": \"ODM-US-PA-WAR-402\",'+
            '          \"type\": \"WARNING\"'+
            '        },'+
            '        {'+
            '          \"description\": \"Part price not found for exception PriceBook: 015119 _17_CHNGOMS\",'+
            '          \"code\": \"\",'+
            '          \"type\": \"\"'+
            '        }'+
            '      ],'+
            '      \"distributorCode\": \"distributor_code\",'+
            '      \"roNumber\": \"RONUM2\",'+
            '      \"serviceModelName\": \"ISC8.3 CM2250\",'+
            '      \"engineApplicationCode\": \"engine_application_code\",'+
            '      \"warrantyStartDate\": \"2012-06-04\",'+
            '      \"serviceProvider\": {'+
            '        \"region\": \"NORTH AMERICA\",'+
            '        \"channelOfDistribution\": \"110\",'+
            '        \"regionCode\": \"USCA\",'+
            '        \"territory\": \"10\",'+
            '        \"status\": \"status\",'+
            '        \"inactiveDate\": \"2012-09-13T09:00:34-04:00\",'+
            '        \"outfileAllClaimsFlag\": \"Y\",'+
            '        \"claimAllowedDays\": 300'+
            '      },'+
            '      \"engineFamily\": \"6C\",'+
            '      \"srtList\": {'+
            '        \"description\": \"Temperature Sending Unit, Engine-Mounted - Replace\",'+
            '        \"hours\": 150,'+
            '        \"offsiteCheck\": \"N\",'+
            '        \"lineNumber\": \"1\",'+
            '        \"quantity\": \"1\",'+
            '        \"code\": \"21-315-00\",'+
            '        \"srtAllowedFlag\": \"srtAllowedFlag\",'+
            '        \"penalty\": 3'+
            '      },'+
            '      \"failurePoint\": 10,'+
            '      \"ownerName\": \"owner_name\",'+
            '      \"serviceProviderName\": \"service_provider_name\",'+
            '      \"engine\": {'+
            '        \"productApplicationDesp\": \"product_application_desp\",'+
            '        \"marineFlag\": \"N\",'+
            '        \"warrantyIndicatorFlag\": \"Y\",'+
            '        \"buildDate\": \"2009-10-14T03:16:36\",'+
            '        \"billToCode\": \"bill_to_code\",'+
            '        \"etoConversionDate\": \"2010-03-18T12:05:32\",'+
            '        \"oemCode\": \"oem_code\"'+
            '      },'+
            '      \"productApplicationCode\": \"BB\",'+
            '      \"status\": \"SUCCESS\",'+
            '      \"claimStatus\": \"Draft\",'+
            '      \"failureMeasure\": \"Miles\",'+
            '      \"claimSubmittedDate\": \"2014-09-18T19:18:33\",'+
            '      \"eto\": {'+
            '        \"status\": \"status\"'+
            '      },'+
            '      \"failure\": {'+
            '        \"campaignId\": \"campaign_id\",'+
            '        \"accountCodeDesp\": \"account_code_desp\",'+
            '        \"payCode\": \"D\",'+
            '        \"totalLaborAmt\": \"total_labor_amt\",'+
            '        \"status\": \"status\",'+
            '        \"authorizationNumber\": \"authorization_number\",'+
            '        \"approvalCode\": \"approval_code\",'+
            '        \"acctCodeInfo\": {'+
            '          \"chryslerFlag\": \"N\",'+
            '          \"accountCodeType\": \"account_code_type\",'+
            '          \"multiESNFlag\": \"N\"'+
            '        },'+
            '        \"totalTowingAmt\": \"total_towing_amt\",'+
            '        \"accountCode\": \"67\",'+
            '        \"failCode\": \"BK13\",'+
            '        \"coverageType\": \"coverage_type\",'+
            '        \"failMode\": \"21\",'+
            '        \"lineNumber\": \"1\",'+
            '        \"totalSRTHours\": \"total_srt_hours\",'+
            '        \"inShopCampaignFlag\": \"inShopCampaignFlag\",'+
            '        \"campaign\": {'+
            '          \"accountCode\": \"account_code\",'+
            '          \"engineComponentCode\": \"engine_component_code\",'+
            '          \"campaignId\": \"campaign_id\",'+
            '          \"completeIndicator\": \"complete_indicator\",'+
            '          \"campaignType\": \"campaign_type\",'+
            '          \"status\": \"status\",'+
            '          \"systemCode\": \"system_code\",'+
            '          \"failMode\": \"fail_mode\",'+
            '          \"expiryDateNA\": \"2014-06-10T14:33:25-04:00\",'+
            '          \"effectiveDate\": \"2018-12-28T14:51:14-05:00\",'+
            '          \"multiFlag\": \"N\",'+
            '          \"expiryDateIntl\": \"2017-11-01T04:15:53-04:00\"'+
            '        }'+
            '      },'+
            '      \"cmiServiceProviderCode\": \"37320\",'+
            '      \"travels\": {'+
            '        \"mealsCharges\": 10,'+
            '        \"towingCharges\": 2,'+
            '        \"hours\": 2,'+
            '        \"lineNumber\": \"1\",'+
            '        \"travelDistance\": 3'+
            '      },'+
            '      \"otherClaimables\": {'+
            '        \"Amount\": \"300\",'+
            '        \"details\": \"details\",'+
            '        \"item\": \"1-DCU6\",'+
            '        \"lineNumber\": \"1\"'+
            '      },'+
            '      \"manualAdjudicationFlag\": \"N\",'+
            '      \"claimCreatedDate\": \"2008-09-28T21:49:45\",'+
            '      \"bisFlag\": \"N\",'+
            '      \"claimNumber\": \"1-12091495\"'+
            '    }'+
            '  }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_ODM - SRT
        else if((req.getEndpoint()).contains('MxSRTVal')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
             '  \"Response\": {'+
            '    \"DecisionID\": \"param:DecisionID\",'+
            '    \"claim\": {'+
            '      \"groupName\": \"group_name\",'+
            '      \"historyClaimFlag\": \"N\",'+
            '      \"reconPartsWarrantyFlag\": \"N\",'+
            '      \"claimReceivedDate\": \"2006-08-19T13:27:14-04:00\",'+
            '      \"failureDate\": \"2009-05-16T08:42:28\",'+
            '      \"cmiEngineSerialNumber\": \"73279794\",'+
            '      \"multiESNFlag\": \"N\",'+
            '      \"parts\": {'+
            '        \"reconPartFlag\": \"recon_part_flag\",'+
            '        \"partName\": \"part_name\",'+
            '        \"partPrice\": 150,'+
            '        \"lineNumber\": \"line_number\",'+
            '        \"partId\": \"part_id\",'+
            '        \"partAllowedFlag\": \"partAllowedFlag\",'+
            '        \"priceBook\": \"price_book\"'+
            '      },'+
            '      \"claimSource\": \"Mexico\",'+
            '      \"totalClaimAmt\": \"total_claim_Amt\",'+
            '      \"messages\": ['+
            '        {'+
            '          \"description\": \"Part # changed to universal PN\",'+
            '          \"code\": \"ODM-US-PA-WAR-402\",'+
            '          \"type\": \"WARNING\"'+
            '        },'+
            '        {'+
            '          \"description\": \"Part price not found for exception PriceBook: 015119 _17_CHNGOMS\",'+
            '          \"code\": \"\",'+
            '          \"type\": \"\"'+
            '        }'+
            '      ],'+
            '      \"distributorCode\": \"distributor_code\",'+
            '      \"roNumber\": \"RONUM2\",'+
            '      \"serviceModelName\": \"ISC8.3 CM2250\",'+
            '      \"engineApplicationCode\": \"engine_application_code\",'+
            '      \"warrantyStartDate\": \"2012-06-04\",'+
            '      \"serviceProvider\": {'+
            '        \"region\": \"NORTH AMERICA\",'+
            '        \"channelOfDistribution\": \"110\",'+
            '        \"regionCode\": \"USCA\",'+
            '        \"territory\": \"10\",'+
            '        \"status\": \"status\",'+
            '        \"inactiveDate\": \"2012-09-13T09:00:34-04:00\",'+
            '        \"outfileAllClaimsFlag\": \"Y\",'+
            '        \"claimAllowedDays\": 300'+
            '      },'+
            '      \"engineFamily\": \"6C\",'+
            '      \"srtList\": {'+
            '        \"description\": \"Temperature Sending Unit, Engine-Mounted - Replace\",'+
            '        \"hours\": 150,'+
            '        \"offsiteCheck\": \"N\",'+
            '        \"lineNumber\": \"1\",'+
            '        \"quantity\": \"1\",'+
            '        \"code\": \"21-315-00\",'+
            '        \"srtAllowedFlag\": \"srtAllowedFlag\",'+
            '        \"penalty\": 3'+
            '      },'+
            '      \"failurePoint\": 10,'+
            '      \"ownerName\": \"owner_name\",'+
            '      \"serviceProviderName\": \"service_provider_name\",'+
            '      \"engine\": {'+
            '        \"productApplicationDesp\": \"product_application_desp\",'+
            '        \"marineFlag\": \"N\",'+
            '        \"warrantyIndicatorFlag\": \"Y\",'+
            '        \"buildDate\": \"2009-10-14T03:16:36\",'+
            '        \"billToCode\": \"bill_to_code\",'+
            '        \"etoConversionDate\": \"2010-03-18T12:05:32\",'+
            '        \"oemCode\": \"oem_code\"'+
            '      },'+
            '      \"productApplicationCode\": \"BB\",'+
            '      \"status\": \"SUCCESS\",'+
            '      \"claimStatus\": \"Draft\",'+
            '      \"failureMeasure\": \"Miles\",'+
            '      \"claimSubmittedDate\": \"2014-09-18T19:18:33\",'+
            '      \"eto\": {'+
            '        \"status\": \"status\"'+
            '      },'+
            '      \"failure\": {'+
            '        \"campaignId\": \"campaign_id\",'+
            '        \"accountCodeDesp\": \"account_code_desp\",'+
            '        \"payCode\": \"D\",'+
            '        \"totalLaborAmt\": \"total_labor_amt\",'+
            '        \"status\": \"status\",'+
            '        \"authorizationNumber\": \"authorization_number\",'+
            '        \"approvalCode\": \"approval_code\",'+
            '        \"acctCodeInfo\": {'+
            '          \"chryslerFlag\": \"N\",'+
            '          \"accountCodeType\": \"account_code_type\",'+
            '          \"multiESNFlag\": \"N\"'+
            '        },'+
            '        \"totalTowingAmt\": \"total_towing_amt\",'+
            '        \"accountCode\": \"67\",'+
            '        \"failCode\": \"BK13\",'+
            '        \"coverageType\": \"coverage_type\",'+
            '        \"failMode\": \"21\",'+
            '        \"lineNumber\": \"1\",'+
            '        \"totalSRTHours\": \"total_srt_hours\",'+
            '        \"inShopCampaignFlag\": \"inShopCampaignFlag\",'+
            '        \"campaign\": {'+
            '          \"accountCode\": \"account_code\",'+
            '          \"engineComponentCode\": \"engine_component_code\",'+
            '          \"campaignId\": \"campaign_id\",'+
            '          \"completeIndicator\": \"complete_indicator\",'+
            '          \"campaignType\": \"campaign_type\",'+
            '          \"status\": \"status\",'+
            '          \"systemCode\": \"system_code\",'+
            '          \"failMode\": \"fail_mode\",'+
            '          \"expiryDateNA\": \"2014-06-10T14:33:25-04:00\",'+
            '          \"effectiveDate\": \"2018-12-28T14:51:14-05:00\",'+
            '          \"multiFlag\": \"N\",'+
            '          \"expiryDateIntl\": \"2017-11-01T04:15:53-04:00\"'+
            '        }'+
            '      },'+
            '      \"cmiServiceProviderCode\": \"37320\",'+
            '      \"travels\": {'+
            '        \"mealsCharges\": 10,'+
            '        \"towingCharges\": 2,'+
            '        \"hours\": 2,'+
            '        \"lineNumber\": \"1\",'+
            '        \"travelDistance\": 3'+
            '      },'+
            '      \"otherClaimables\": {'+
            '        \"Amount\": \"300\",'+
            '        \"details\": \"details\",'+
            '        \"item\": \"1-DCU6\",'+
            '        \"lineNumber\": \"1\"'+
            '      },'+
            '      \"manualAdjudicationFlag\": \"N\",'+
            '      \"claimCreatedDate\": \"2008-09-28T21:49:45\",'+
            '      \"bisFlag\": \"N\",'+
            '      \"claimNumber\": \"1-12091495\"'+
            '    }'+
            '  }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_ODM - PRE-SUBMIT
        else if((req.getEndpoint()).contains('MxPreSub')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
        '  \"Response\": {'+
        '    \"DecisionID\": \"\",'+
        '    \"claim\": {'+
        '      \"groupName\": \"\",'+
        '      \"historyClaimFlag\": \"N\",'+
        '      \"reconPartsWarrantyFlag\": \"N\",'+
        '      \"failureDate\": \"2016-01-01T00:00:00-06:00\",'+
        '      \"cmiEngineSerialNumber\": 75015214,'+
        '      \"multiESNFlag\": \"N\",'+
        '      \"claimSource\": \"MX\",'+
        '      \"totalClaimAmt\": \"\",'+
        '      \"messages\": ['+
        '        {'+
        '          \"description\": \"Invalid claim total. A claim must have at least one SRT, Part, or Other Claimable in order to be submitted\",'+
        '          \"code\": \"ODM-PS-ERR-107\",'+
        '          \"type\": \"ERROR\"'+
        '        }'+
        '      ],'+
        '      \"roNumber\": 98765,'+
        '      \"level\": \"\",'+
        '      \"serviceModelName\": \"ISX12 CM2350 X102\",'+
        '      \"warrantyStartDate\": \"2012-05-04T00:00:00-05:00\",'+
        '      \"engineFamily\": \"0K\",'+
        '      \"serviceProvider\": {'+
        '        \"region\": \"MEXICO\",'+
        '        \"channelOfDistribution\": \"DEALER\",'+
        '        \"regionCode\": \"MEXI\",'+
        '        \"engineExpirationdate\": \"\",'+
        '        \"territory\": \"MEXICO\",'+
        '        \"outfileAllClaimsFlag\": \"Y\",'+
        '        \"engineEffectiveDate\": \"\",'+
        '        \"claimAllowedDays\": 365'+
        '      },'+
        '      \"failures\": ['+
        '        {'+
        '        \"srtList\": ['+
        '         {'+
        '          \"hours\": \"\",'+
        '          \"srtAllowedFlag\": \"\",'+
        '          \"quantity\": \"\"'+
        '         }'+
        '        ],'+
        '        \"payCode\": \"R\",'+
        '        \"status\": \"Draft\",'+
        '        \"totalLaborAmt\": \"\",'+
        '        \"authorizationNumber\": 123,'+
        '        \"parts\": ['+
        '         {'+
        '          \"partPrice\": \"\",'+
        '          \"partAllowedFlag\": \"\"'+
        '         }'+
        '        ],'+
        '        \"acctCodeInfo\": \"\",'+
        '        \"totalTowingAmt\": \"\",'+
        '        \"accountCode\": 67,'+
        '        \"travels\": ['+
        '         {'+
        '          \"mealsCharges\": \"\",'+
        '          \"towingCharges\": \"\",'+
        '          \"hours\": \"\",'+
        '          \"travelDistance\": \"\"'+
        '         }'+
        '        ],'+
        '        \"failCode\": \"BKCA\",'+
        '        \"otherClaimables\": ['+
        '         {'+
        '          \"amount\": \"\"'+
        '         }'+
        '        ],'+
        '        \"coverageType\": \"NEW-New Engine Warranty\",'+
        '        \"failMode\": 21,'+
        '        \"lineNumber\": 1,'+
        '        \"totalSRTHours\": \"\",'+
        '        \"inShopCampaignFlag\": \"\",'+
        '        \"campaign\": {'+
        '          \"accountCode\": \"\",'+
        '          \"engineComponentCode\": \"\",'+
        '          \"campaignId\": \"\",'+
        '          \"completeIndicator\": \"\",'+
        '          \"campaignType\": \"\",'+
        '          \"status\": \"\",'+
        '          \"systemCode\": \"\",'+
        '          \"failMode\": \"\",'+
        '          \"multiFlag\": \"\"'+
        '        }'+
        '       }' +
        '      ],'+
        '      \"failurePoint\": 1000,'+
        '      \"engine\": {'+
        '        \"productApplicationDesp\": \"BUS\",'+
        '        \"marineFlag\": \"N\",'+
        '        \"engineFamilyCode\": \"0K\",'+
        '        \"warrantyIndicatorFlag\": \"Y\",'+
        '        \"buildDate\": \"2012-11-01T00:00:00-05:00\"'+
        '      },'+
        '      \"productApplicationCode\": \"BU\",'+
        '      \"status\": \"ERROR\",'+
        '      \"claimStatus\": \"Draft\",'+
        '      \"failureMeasure\": \"Kilometers\",'+
        '      \"cmiServiceProviderCode\": 54887,'+
        '      \"manualAdjudicationFlag\": \"\",'+
        '      \"bisFlag\": \"N\",'+
        '      \"claimNumber\": \"Draft\"'+
        '    }'+
        '  }'+
        '}';
                res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for ClaimSubmission
        else if((req.getEndpoint()).contains('MxClaimSub')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
            '   \"DataArea\":{'+
            '      \"Status\":\"Success\",'+
            '      \"ErrorMessage\":\"\",'+
            '      \"ClaimNumber\":\"1-15067818\"'+
            '   },'+
            '   \"Header\":{'+
            '      \"ReturnCodeDescription\":\"\",'+
            '      \"Status\":\"Success\"'+
            '   }'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for ClaimReliability
        else if((req.getEndpoint()).contains('MxClaimRel')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String json = '{'+
            '   \"messageIdentifier\":\"1-306d8891-dda1-11eb-8a11-022059974d50\",'+
            '   \"returnCode\":\"201\",'+
            '   \"returnCodeDescription\":\"Created\",'+
            '   \"status\":\"Success\",'+
            '   \"message\":\"2 claim header records inserted into CLAIM_CSV_DAILY_LOADER table and 2 claim parts records inserted into CLAIM_CSV_PART_LOADER table\"'+
            '}';
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for GetCSSDetail
        else if((req.getEndpoint()).contains('MxCssDet')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
                        
            String json = '{'+
                '  \"Header\": {'+
                '    \"Status\": \"Success\",'+
                '    \"ReturnCodeDescription\": \"Message if any..\"'+
                '  },'+
                '  \"DataArea\": {'+
                '    \"DetailParts\": ['+
                '      {'+
                '        \"PartNumber\": \"4331387RX\",'+
                '        \"PartQty\": \"1\",'+
                '        \"AdjustmentReason\": \"AdjustmentReason1\",'+
                '        \"AdjustmentPartsPercent\": \"100\"'+
                '      },'+
                '      {'+
                '        \"PartNumber\": \"006439500\",'+
                '        \"PartQty\": \"2\",'+
                '        \"AdjustmentReason\": \"AdjustmentReason2\",'+
                '        \"AdjustmentPartsPercent\": \"100\"'+
                '      },'+
                '      {'+
                '        \"PartNumber\": \"4034289RX\",'+
                '        \"PartQty\": \"1\",'+
                '        \"AdjustmentReason\": \"AdjustmentReason3\",'+
                '        \"AdjustmentPartsPercent\": \"100\"'+
                '      }'+
                '    ],'+
                '    \"DetailSRTs\": ['+
                '      {'+
                '        \"SRTCode\": \"10\",'+
                '        \"SRTHours\": \"10\",'+
                '        \"SRTQty\": \"10\",'+
                '        \"AccessCode\": \"A\",'+
                '        \"PercentageAdjustment\": \"100\",'+
                '        \"AdjustmentReason\": \"SRTAdjustmentReason\"'+
                '      },'+
                '      {'+
                '        \"SRTCode\": \"11\",'+
                '        \"SRTHours\": \"11\",'+
                '        \"SRTQty\": \"11\",'+
                '        \"AccessCode\": \"B\",'+
                '        \"PercentageAdjustment\": \"100\",'+
                '        \"AdjustmentReason\": \"SRTAdjustmentReason\"'+
                '      }'+
                '    ],'+
                '    \"DetailOtherClaimables\": ['+
                '      {'+
                '        \"Description\": \"Description1\",'+
                '        \"ApprovedAmount\": \"11\",'+
                '        \"AdjustmentReason\": \"OCAdjustmentReason\"'+
                '      },'+
                '      {'+
                '        \"Description\": \"Description2\",'+
                '        \"ApprovedAmount\": \"12\",'+
                '        \"AdjustmentReason\": \"OCAdjustmentReason\"'+
                '      }'+
                '    ],'+
                '    \"DetailTravels\": ['+
                '      {'+
                '        \"AdjustmentReason\": \"TravelAdjustmentReason1\",'+
                '        \"TravelType\": \"Non-commercial\"'+
                '      }'+
                '    ]'+
                '  }'+
                '}';  
                                
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_GetGSQFailure
        else if((req.getEndpoint()).contains('MxGsqFai')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            String json = '{'+
                '    \"DataArea\": ['+
                '        {'+
                '            \"FailureName\": \"ATC 1777\",'+
                '            \"SystemCode\": \"WE\",'+
                '            \"ComponentCode\": \"QP\",'+
                '            \"FailureID\": \"F30007170\",'+
                '            \"FailureMode\": \"ES\"'+
                '        },'+
                '        {'+
                '            \"FailureName\": \"Turbocharger Oil Drain Line\",'+
                '            \"SystemCode\": \"LS\",'+
                '            \"ComponentCode\": \"HT\",'+
                '            \"FailureID\": \"F10000170\",'+
                '            \"FailureMode\": \"\"'+
                '        },'+
                '        {'+
                '            \"FailureName\": \"Water Pump\",'+
                '            \"SystemCode\": \"KP\",'+
                '            \"ComponentCode\": \"BD\",'+
                '            \"FailureID\": \"F08000180\",'+
                '            \"FailureMode\": \"\"'+
                '        }'+
                '    ],'+
                '    \"Header\": {'+
                '        \"ReturnCode\": \"ORA-00000\",'+
                '        \"ReturnCodeDescription\": \"Normal, Successful completion.\",'+
                '        \"MessageIdentifier\": \"2-687e77a0-dd8c-11ea-9cde-122ad0d67aa6\",'+
                '        \"Status\": \"SUCCESS\",'+
                '        \"MessageType\": \"S\"'+
                '    }'+
                '}';
                                
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_GetGSQSRT
        else if((req.getEndpoint()).contains('MxGsqSrt')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            String json = '{'+
                '  \"DataArea\": {'+
                '    \"CaseResponse\": ['+
                '      {'+
                '        \"AccessCodeD\": 0.2,'+
                '        \"AccessCodeC\": 0,'+
                '        \"SRTDetails\": \"00-200-00\",'+
                '        \"AccessCodeB\": 0,'+
                '        \"SRTAccessCode\": \"D\",'+
                '        \"AccessCodeA\": 0,'+
                '        \"S6Desc\": \"\",'+
                '        \"Assignment\": \"ALTERNATIVE\",'+
                '        \"S9Desc\": \"\",'+
                '        \"SRTDesc\": \"Steam Clean - Single\\nComponent Replacemt - Alternative\",'+
                '        \"SRTTime\": 0.2,'+
                '        \"S1Desc\": \"\",'+
                '        \"S5Desc\": \"\",'+
                '        \"S3Desc\": \"\",'+
                '        \"S8Desc\": \"\",'+
                '        \"SRTQuantity\": 1,'+
                '        \"AccessCodeS1\": 0,'+
                '        \"SRTTitle\": \"Steam Clean - Single Component Repair - Alternative\",'+
                '        \"S4Desc\": \"\",'+
                '        \"FailureID\": \"F13000000\",'+
                '        \"VerifyRepeatValue\": {'+
                '          \"SRTEventPerfDateTime\": \"\",'+
                '          \"SRTType\": \"\",'+
                '          \"Step\": {'+
                '            \"StepID\": 89620,'+
                '            \"Percentage\": 0,'+
                '            \"SRTModifyDateTime\": \"\",'+
                '            \"StepDescription\": ['+
                '              \"Steam Clean - Single\\nComponent Replacemt\"'+
                '            ]'+
                '          }'+
                '        },'+
                '        \"AccessCodeS8\": 0,'+
                '        \"AccessCodeS9\": 0,'+
                '        \"AccessCodeR\": 0.2,'+
                '        \"AccessCodeS6\": 0,'+
                '        \"S2Desc\": \"\",'+
                '        \"AccessCodeS7\": 0,'+
                '        \"SRTMessage\": \"\",'+
                '        \"AccessCodeS4\": 0,'+
                '        \"AccessCodeS5\": 0,'+
                '        \"AccessCodeS2\": 0,'+
                '        \"AccessCodeS3\": 0,'+
                '        \"FailureName\": \"Air Compressor\",'+
                '        \"S7Desc\": \"\"'+
                '      },'+
                '      {'+
                '        \"AccessCodeD\": 0.2,'+
                '        \"AccessCodeC\": 0,'+
                '        \"SRTDetails\": \"00-400-00\",'+
                '        \"AccessCodeB\": 0,'+
                '        \"SRTAccessCode\": \"D\",'+
                '        \"AccessCodeA\": 0,'+
                '        \"S6Desc\": \"\",'+
                '        \"Assignment\": \"PRIMARY\",'+
                '        \"S9Desc\": \"\",'+
                '        \"SRTDesc\": \"Steam Clean - Single\\nComponent Replacemt\",'+
                '        \"SRTTime\": 0.2,'+
                '        \"S1Desc\": \"\",'+
                '        \"S5Desc\": \"\",'+
                '        \"S3Desc\": \"\",'+
                '        \"S8Desc\": \"\",'+
                '        \"SRTQuantity\": 1,'+
                '        \"AccessCodeS1\": 0,'+
                '        \"SRTTitle\": \"Steam Clean - Single Component Repair\",'+
                '        \"S4Desc\": \"\",'+
                '        \"FailureID\": \"F12000000\",'+
                '        \"VerifyRepeatValue\": {'+
                '          \"SRTEventPerfDateTime\": \"\",'+
                '          \"SRTType\": \"\",'+
                '          \"Step\": {'+
                '            \"StepID\": 89620,'+
                '            \"Percentage\": 0,'+
                '            \"SRTModifyDateTime\": \"\",'+
                '            \"StepDescription\": ['+
                '              \"Steam Clean - Single\\nComponent Replacemt\"'+
                '            ]'+
                '          }'+
                '        },'+
                '        \"AccessCodeS8\": 0,'+
                '        \"AccessCodeS9\": 0,'+
                '        \"AccessCodeR\": 0.2,'+
                '        \"AccessCodeS6\": 0,'+
                '        \"S2Desc\": \"\",'+
                '        \"AccessCodeS7\": 0,'+
                '        \"SRTMessage\": \"\",'+
                '        \"AccessCodeS4\": 0,'+
                '        \"AccessCodeS5\": 0,'+
                '        \"AccessCodeS2\": 0,'+
                '        \"AccessCodeS3\": 0,'+
                '        \"FailureName\": \"Air Compressor\",'+
                '        \"S7Desc\": \"\"'+
                '      },'+
                '      {'+
                '        \"AccessCodeD\": 0.2,'+
                '        \"AccessCodeC\": 0,'+
                '        \"SRTDetails\": \"00-400-00\",'+
                '        \"AccessCodeB\": 0,'+
                '        \"SRTAccessCode\": \"D\",'+
                '        \"AccessCodeA\": 0,'+
                '        \"S6Desc\": \"\",'+
                '        \"Assignment\": \"PRIMARY\",'+
                '        \"S9Desc\": \"\",'+
                '        \"SRTDesc\": \"Steam Clean - Single\\nComponent Replacemt\",'+
                '        \"SRTTime\": 0.2,'+
                '        \"S1Desc\": \"\",'+
                '        \"S5Desc\": \"\",'+
                '        \"S3Desc\": \"\",'+
                '        \"S8Desc\": \"\",'+
                '        \"SRTQuantity\": 1,'+
                '        \"AccessCodeS1\": 0,'+
                '        \"SRTTitle\": \"Steam Clean - Single Component Repair\",'+
                '        \"S4Desc\": \"\",'+
                '        \"FailureID\": \"F12000000\",'+
                '        \"VerifyRepeatValue\": {'+
                '          \"SRTEventPerfDateTime\": \"\",'+
                '          \"SRTType\": \"\",'+
                '          \"Step\": {'+
                '            \"StepID\": 89620,'+
                '            \"Percentage\": 0,'+
                '            \"SRTModifyDateTime\": \"\",'+
                '            \"StepDescription\": ['+
                '              \"Steam Clean - Single\\nComponent Replacemt\"'+
                '            ]'+
                '          }'+
                '        },'+
                '        \"AccessCodeS8\": 0,'+
                '        \"AccessCodeS9\": 0,'+
                '        \"AccessCodeR\": 0.2,'+
                '        \"AccessCodeS6\": 0,'+
                '        \"S2Desc\": \"\",'+
                '        \"AccessCodeS7\": 0,'+
                '        \"SRTMessage\": \"\",'+
                '        \"AccessCodeS4\": 0,'+
                '        \"AccessCodeS5\": 0,'+
                '        \"AccessCodeS2\": 0,'+
                '        \"AccessCodeS3\": 0,'+
                '        \"FailureName\": \"Air Compressor\",'+
                '        \"S7Desc\": \"\"'+
                '      }'+
                '    ],'+
                '    \"ResponseMessage\": \"\"'+
                '  },'+
                '  \"Header\": {'+
                '    \"Status\": \"Success\",'+
                '    \"ReturnCodeDescription\": \"\"'+
                '  }'+
                '}';
                                
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_GetServiceModel
        else if((req.getEndpoint()).contains('MxServMod')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            String json = '{'+
                '  \"DataArea\": {'+
                '    \"OutputMessageCode\": \"ORA-00000\",'+
                '    \"OutputMessage\": \"Normal, Successful completion.\",'+
                '    \"EquipmentData\": ['+
                '      {'+
                '        \"Status\": \"ACTIVE\",'+
                '        \"Configuration\": \"BUS\",'+
                '        \"EngineFamilyCode\": 56,'+
                '        \"ServiceModelDetails\": ['+
                '          {'+
                '            \"EF\": 56,'+
                '            \"SMN\": \"L9 CM2350 L116B\"'+
                '          },'+
                '          {'+
                '            \"EF\": 56,'+
                '            \"SMN\": \"L9 CM2350 L123B\"'+
                '          },'+
                '          {'+
                '            \"EF\": 56,'+
                '            \"SMN\": \"ISL CM2150\"'+
                '          },'+
                '          {'+
                '            \"EF\": 56,'+
                '            \"SMN\": \"ISL CM554\"'+
                '          },'+
                '          {'+
                '            \"EF\": 56,'+
                '            \"SMN\": \"ISL9 CM2350 L101\"'+
                '          }'+
                '        ],'+
                '        \"EquipmentId\": \"EQ534\",'+
                '        \"Model\": \"ALL AMERICAN A\",'+
                '        \"AccessCode\": \"D\",'+
                '        \"Make\": \"BLUE BIRD\",'+
                '        \"ApplicationCategory\": \"A\"'+
                '      },'+
                '      {'+
                '        \"Status\": \"ACTIVE\",'+
                '        \"Configuration\": \"CONVENTIONAL\",'+
                '        \"EngineFamilyCode\": 10,'+
                '        \"ServiceModelDetails\": ['+
                '          {'+
                '            \"EF\": 10,'+
                '            \"SMN\": \"ISX CM870\"'+
                '          },'+
                '          {'+
                '            \"EF\": 10,'+
                '            \"SMN\": \"ISX15 CM2350 X101\"'+
                '          },'+
                '          {'+
                '            \"EF\": 10,'+
                '            \"SMN\": \"ISX15 CM2250\"'+
                '          },'+
                '          {'+
                '            \"EF\": 10,'+
                '            \"SMN\": \"ISX CM570\"'+
                '          },'+
                '          {'+
                '            \"EF\": 10,'+
                '            \"SMN\": \"ISX CM871\"'+
                '          },'+
                '          {'+
                '            \"EF\": 10,'+
                '            \"SMN\": \"X15 CM2350 X116B\"'+
                '          },'+
                '          {'+
                '            \"EF\": 10,'+
                '            \"SMN\": \"ISX CM871 E\"'+
                '          },'+
                '          {'+
                '            \"EF\": 10,'+
                '            \"SMN\": \"X15 CM2350 X114B\"'+
                '          }'+
                '        ],'+
                '        \"EquipmentId\": \"EQ5436\",'+
                '        \"Model\": \"T600 SERIES\",'+
                '        \"AccessCode\": \"B\",'+
                '        \"Make\": \"KENWORTH\",'+
                '        \"ApplicationCategory\": \"A\"'+
                '      },'+
                '      {'+
                '        \"Status\": \"ACTIVE\",'+
                '        \"Configuration\": \"TRENCHER\",'+
                '        \"EngineFamilyCode\": 31,'+
                '        \"ServiceModelDetails\": ['+
                '          {'+
                '            \"EF\": 31,'+
                '            \"SMN\": \"QSB6.7 CM2250 B128\"'+
                '          },'+
                '          {'+
                '            \"EF\": 31,'+
                '            \"SMN\": \"QSB6.7 CM2250\"'+
                '          },'+
                '          {'+
                '            \"EF\": 31,'+
                '            \"SMN\": \"QSB6.7 CM2250 EC\"'+
                '          }'+
                '        ],'+
                '        \"EquipmentId\": \"EQ12608\",'+
                '        \"Model\": \"DD10\",'+
                '        \"AccessCode\": \"C\",'+
                '        \"Make\": \"AMERICAN AUGER\",'+
                '        \"ApplicationCategory\": \"I\"'+
                '      }'+
                '    ],'+
                '    \"OutputMessageType\": \"S\"'+
                '  },'+
                '  \"Header\": {'+
                '    \"Status\": \"SUCCESS\",'+
                '    \"ReturnCodeDescription\": \"Normal, Successful completion.\"'+
                '  }'+
                '}';                                
            
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_GetPartReturn
        else if((req.getEndpoint()).contains('MxPartRet')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            String json = '{'+
                '    \"DataArea\": ['+
                '        {'+
                '            \"LOCATION\": \"\",'+
                '            \"MESSAGE\": \"***ENHANCED PARTS RETURN REQUEST***PLEASE TAG THE PART AND PLACE IT IN THE BOX OF THE REPLACEMENT PART. LABEL THE PART WITH A MATERIAL RETURN TAG WHICH INCLUDES ESN, DISTRIBUTOR CODE, CLAIM NUMBER AND WORK ORDER NUMBER. THE PART SHOULD BE RETURNED TO: CUMMINS SSC EUROPE UNIT B DAVENTRY INTERCHANGE, SOPWITH WAY DRAYTON FIELDS INDUSTRIAL ESTATE, DAVENTRY, NORTHHAMPTONSHIRE, NN11, 8PB, UK. CONTACT SSC.EUROPE@CUMMINS.COM WITH QUESTIONS.\",'+
                '            \"ATTENTION\": \"\",'+
                '            \"RETURNMESSAGE\": \"\",'+
                '            \"EPRFLAG\": \"Y\",'+
                '            \"PARTNUMBER\": \"006439500\",'+
                '            \"COMPANY\": \"\"'+
                '        }'+
                '    ],'+
                '    \"Header\": {'+
                '        \"Status\": \"Success\",'+
                '        \"ReturnCodeDescription\": \"\"'+
                '    }'+
                '}'; 
            
            res.setBody(json);
            res.setStatusCode(200);
        }
        // Fake response data for WS_GetFailCodes
        else if((req.getEndpoint()).contains('MxFailCod')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            String json = '{'+
                '  \"DataArea\": {'+
                '    \"Details\": ['+
                '      {'+
                '        \"Active\": \"Y\",'+
                '        \"BusinesUnit\": \"CMI\",'+
                '        \"ServiceGroupCode\": \"19\",'+
                '        \"UpdatedDate\": \"2019-04-03T03:15:07.000-05:00\",'+
                '        \"SystemCode\": \"DS\",'+
                '        \"ComponentCode\": \"JH\",'+
                '        \"FailureName\": \"\",'+
                '        \"SystemName\": \"DIGI SOL\",'+
                '        \"ComponentName\": \"JUMPER HARNESS\",'+
                '        \"Created\": \"2019-04-03T03:15:07.000-05:00\"'+
                '      }'+
                '    ]'+
                '  },'+
                '  \"Header\": {'+
                '    \"Status\": \"Success\",'+
                '    \"ReturnCode\": \"\",'+
                '    \"ReturnCodeDescription\": \"\",'+
                '    \"MessageIdentifier\": \"1523f642-7862-4db1-a9ed-52fbfeb24623\"'+
                '  }'+
                '}';
            
            res.setBody(json);
            res.setStatusCode(200);
        }        
               
        return res;
    }
}