@RestResource(urlMapping='/mock_webservice/*')
global class CSS_WS_WebServicesExternalMock{
    @HttpPost
  global static void doPost() {
        RestRequest    req = RestContext.request;
        RestResponse  res = RestContext.response;
        res.addHeader('Content-Type', 'application/javascript');
        Integer code = 200;
        if((req.requestURI).contains('MxAccCov')){
            res.responseBody = Blob.valueOf('{'+
            '  \"DataArea\": {'+
            '    \"Details\": ['+
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
            '}');
        } else if((req.requestURI).contains('MxEngData')){
            res.responseBody = Blob.valueOf('{'+
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
            '}');
        } else if((req.requestURI).contains('MxCampData')){
            res.responseBody = Blob.valueOf('{'+
        '  \"DataArea\": {'+
        '    \"Details\": ['+
        '      {'+
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
        '}');
        } else if((req.requestURI).contains('MxMultiESN')){
            res.responseBody = Blob.valueOf('{'+
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
            '}');
        } else if((req.requestURI).contains('MxSPData')){
            res.responseBody = Blob.valueOf('{'+
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
            '}');
        } else if((req.requestURI).contains('MxSRTData')){
            res.responseBody = Blob.valueOf('{'+
            '   \"DataArea\":{'+
            '      \"Details\":['+
            '         {'+
            '            \"SRTDescription\":\"Lubricating Oil Pan - Remove and Install - QSF3.8 CM2350 F107\",'+
            '            \"HrsUnit\":\"0.8\",'+
            '            \"SRTCode\":\"07-018-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"EGR Differential Pressure Sensor - Remove and Install - QSF3.8 CM2350 F118\",'+
            '            \"HrsUnit\":\"0.3\",'+
            '            \"SRTCode\":\"19-09S-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Gear Housing, Rear - Remove and Install - QSF3.8 CM2350 F118\",'+
            '            \"HrsUnit\":\"7.4\",'+
            '            \"SRTCode\":\"01-0C0-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Fan Guard, Shroud Circular Type - Remove and Install, Each\",'+
            '            \"HrsUnit\":\"0.2\",'+
            '            \"SRTCode\":\"08-136-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Fan Hub - Remove and Install\",'+
            '            \"HrsUnit\":\"0.5\",'+
            '            \"SRTCode\":\"08-112-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Rocker Lever - Remove and Install, Each Additional Pair  - QSF3.8 CM2350 F107\",'+
            '            \"HrsUnit\":\"0.2\",'+
            '            \"SRTCode\":\"03-011-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Injector Supply Lines (High Pressure) - Remove and Install, All  - QSF3.8 CM2350 F118\",'+
            '            \"HrsUnit\":\"0.9\",'+
            '            \"SRTCode\":\"06-05R-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Second Technician for Lifting Assistance (0.1 hours)\",'+
            '            \"HrsUnit\":\"0.1\",'+
            '            \"SRTCode\":\"99-905-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Tappet - Remove and Install, All  - QSF3.8 CM2350 F107\",'+
            '            \"HrsUnit\":\"6.5\",'+
            '            \"SRTCode\":\"04-008-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Alternator - Remove and Install - QSF3.8 CM2350 F119\",'+
            '            \"HrsUnit\":\"0.4\",'+
            '            \"SRTCode\":\"13-025-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Vehicle or Machine Toolbox- Remove and Install\",'+
            '            \"HrsUnit\":\"0.5\",'+
            '            \"SRTCode\":\"17-164-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"EGR Valve - Remove and Install - QSF3.8 CM2350 F107\",'+
            '            \"HrsUnit\":\"0.5\",'+
            '            \"SRTCode\":\"11-01B-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Bearings, Main - Remove and Install, First Pair  - QSF3.8 CM2350 F118\",'+
            '            \"HrsUnit\":\"3.8\",'+
            '            \"SRTCode\":\"01-0C8-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Turbocharger Wastegate Actuator - Remove and Install - QSF3.8 CM2350 F119\",'+
            '            \"HrsUnit\":\"0.6\",'+
            '            \"SRTCode\":\"10-05P-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"EGR Cooler Coolant Lines - Remove and Install - QSF3.8 CM2350 F119\",'+
            '            \"HrsUnit\":\"0.6\",'+
            '            \"SRTCode\":\"11-05F-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Crankshaft Seal, Rear - Remove and Install - QSF3.8 CM2350 F118\",'+
            '            \"HrsUnit\":\"0.8\",'+
            '            \"SRTCode\":\"01-0C2-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Piston Cooling Nozzle - Remove and Install, All  - QSF3.8 CM2350 F118\",'+
            '            \"HrsUnit\":\"1.6\",'+
            '            \"SRTCode\":\"01-0BZ-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Engine Support Bracket, Rear - Remove and Install - QSF3.8 CM2350 F118\",'+
            '            \"HrsUnit\":\"0.2\",'+
            '            \"SRTCode\":\"16-01J-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Aftertreatment Diesel Particulate Filter Cleaning\",'+
            '            \"HrsUnit\":\"0.4\",'+
            '            \"SRTCode\":\"11-054-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Cooling Fan Belt Tensioner - Remove and Install - QSF3.8 CM2350 F119\",'+
            '            \"HrsUnit\":\"0.4\",'+
            '            \"SRTCode\":\"08-04N-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Air Intake Manifold - Remove and Install - QSF3.8 CM2880 F112\",'+
            '            \"HrsUnit\":\"2.7\",'+
            '            \"SRTCode\":\"10-03R-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Alternator Bracket - Remove and Install - QSF3.8 CM2350 F119\",'+
            '            \"HrsUnit\":\"0.5\",'+
            '            \"SRTCode\":\"13-024-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Exhaust Outlet Connection - Remove and Install - QSF3.8 CM2350 F119\",'+
            '            \"HrsUnit\":\"0.4\",'+
            '            \"SRTCode\":\"11-05M-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Air Intake Manifold - Remove and Install - QSF3.8 CM2350 F107\",'+
            '            \"HrsUnit\":\"3.6\",'+
            '            \"SRTCode\":\"10-01F-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Fan Hub, Belt Driven - Remove and Install - ISF3.8 CM2350 F109\",'+
            '            \"HrsUnit\":\"0.6\",'+
            '            \"SRTCode\":\"08-02S-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Exhaust Manifold, Dry - Remove and Install - ISF3.8 CM2350 F109\",'+
            '            \"HrsUnit\":\"1.9\",'+
            '            \"SRTCode\":\"11-01X-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Pulley, Fan Idler - Remove and Install - QSF3.8 CM2350 F118\",'+
            '            \"HrsUnit\":\"0.3\",'+
            '            \"SRTCode\":\"08-04B-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Rail Fuel Pressure Sensor - Remove and Install - QSF3.8 CM2350 F119\",'+
            '            \"HrsUnit\":\"0.2\",'+
            '            \"SRTCode\":\"19-0A3-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Hydraulic Oil Tank (CMLA Application) - Remove and Install\",'+
            '            \"HrsUnit\":\"1.5\",'+
            '            \"SRTCode\":\"17-129-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Air Intake Connection - Remove and Install - QSF3.8 CM2350 F119\",'+
            '            \"HrsUnit\":\"0.6\",'+
            '            \"SRTCode\":\"10-05N-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Fan Spacer and Pulley - Remove and Install - QSF3.8 CM2350 F119\",'+
            '            \"HrsUnit\":\"0.4\",'+
            '            \"SRTCode\":\"08-04R-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Engine Coolant Temperature Sensor - Remove and Install - ISF3.8 CM2350 F109\",'+
            '            \"HrsUnit\":\"0.3\",'+
            '            \"SRTCode\":\"19-03W-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Fuel Supply Lines - Remove and Install - QSF3.8 CM2880 F112\",'+
            '            \"HrsUnit\":\"0.3\",'+
            '            \"SRTCode\":\"06-04U-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Closed Crankcase Ventilation Hoses - Remove and Install - ISF3.8 CM2220 IAN\",'+
            '            \"HrsUnit\":\"0.4\",'+
            '            \"SRTCode\":\"03-02B-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Exhaust Outlet Connection - Remove and Install - QSF3.8 CM2880 F112\",'+
            '            \"HrsUnit\":\"0.5\",'+
            '            \"SRTCode\":\"11-03U-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Engine Support Bracket, Front - Remove and Install - QSF3.8 CM2350 F119\",'+
            '            \"HrsUnit\":\"0.2\",'+
            '            \"SRTCode\":\"16-01Q-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Flywheel - Remove and Install - ISF3.8 CM2350 F109\",'+
            '            \"HrsUnit\":\"0.7\",'+
            '            \"SRTCode\":\"16-00S-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Piston and Connecting Rod Assembly - Remove and Install, First  - ISF3.8 CM2350 F109\",'+
            '            \"HrsUnit\":\"10\",'+
            '            \"SRTCode\":\"01-061-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Crankshaft Seal, Front - Remove and Install - ISF3.8 CM2350 F109\",'+
            '            \"HrsUnit\":\"1.2\",'+
            '            \"SRTCode\":\"01-05L-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Bearings, Main - Remove and Install, Each Additional Pair  - QSF3.8 CM2880 F112\",'+
            '            \"HrsUnit\":\"0.2\",'+
            '            \"SRTCode\":\"01-09D-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Crankshaft - Remove and Install - QSF3.8 CM2350 F119\",'+
            '            \"HrsUnit\":\"0\",'+
            '            \"SRTCode\":\"01-0CT-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Crankcase Breather Oil Drain Line - Remove and Install - QSF3.8 CM2350 F118\",'+
            '            \"HrsUnit\":\"0.3\",'+
            '            \"SRTCode\":\"03-03A-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Rocker Lever - Remove and Install, First Pair  - QSF3.8 CM2350 F118\",'+
            '            \"HrsUnit\":\"1.9\",'+
            '            \"SRTCode\":\"03-03K-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Crankshaft Seal, Rear - Remove and Install - QSF3.8 CM2350 F107\",'+
            '            \"HrsUnit\":\"0.8\",'+
            '            \"SRTCode\":\"01-03G-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Refrigerant Compressor - Remove and Install\",'+
            '            \"HrsUnit\":\"0\",'+
            '            \"SRTCode\":\"09-504-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Piston Cooling Nozzle - Remove and Install, First  - QSF3.8 CM2350 F118\",'+
            '            \"HrsUnit\":\"1.3\",'+
            '            \"SRTCode\":\"01-0BY-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Bearings, Main - Remove and Install, Each Additional Pair  - QSF3.8 CM2350 F119\",'+
            '            \"HrsUnit\":\"0.3\",'+
            '            \"SRTCode\":\"01-0CW-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Gear Cover, Front - Remove and Install - QSF3.8 CM2350 F118\",'+
            '            \"HrsUnit\":\"3.4\",'+
            '            \"SRTCode\":\"01-0C1-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Water Pump - Remove and Install - ISF3.8 CM2350 F109\",'+
            '            \"HrsUnit\":\"0.6\",'+
            '            \"SRTCode\":\"08-01Z-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Tappet - Remove and Install, All  - QSF3.8 CM2350 F119\",'+
            '            \"HrsUnit\":\"0\",'+
            '            \"SRTCode\":\"04-010-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Fuel Pump - Remove and Install - QSF3.8 CM2350 F107\",'+
            '            \"HrsUnit\":\"1.1\",'+
            '            \"SRTCode\":\"05-00H-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Air Tank - Remove and Install\",'+
            '            \"HrsUnit\":\"0.5\",'+
            '            \"SRTCode\":\"17-166-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Air Intake Connection - Remove and Install - ISF3.8 CM2350 F109\",'+
            '            \"HrsUnit\":\"0.6\",'+
            '            \"SRTCode\":\"10-02C-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"EGR Differential Pressure Sensor Adapter - Remove and Install - QSF3.8 CM2350 F119\",'+
            '            \"HrsUnit\":\"0.7\",'+
            '            \"SRTCode\":\"11-05H-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Water Inlet Connection - Remove and Install - QSF3.8 CM2880 F112\",'+
            '            \"HrsUnit\":\"0.7\",'+
            '            \"SRTCode\":\"08-03K-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Intake Manifold Pressure/Temperature Sensor - Remove and Install - QSF3.8 CM2350 F107\",'+
            '            \"HrsUnit\":\"0.2\",'+
            '            \"SRTCode\":\"19-01K-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Lubricating Oil Pressure Regulator (Main Rifle) - Remove and Install - ISF3.8 CM2220 AN\",'+
            '            \"HrsUnit\":\"0.4\",'+
            '            \"SRTCode\":\"07-02Z-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Piston and Connecting Rod Assembly - Remove and Install, All  - QSF3.8 CM2350 F119\",'+
            '            \"HrsUnit\":\"12.9\",'+
            '            \"SRTCode\":\"01-0CK-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Tappet - Remove and Install, First Pair  - QSF3.8 CM2350 F107\",'+
            '            \"HrsUnit\":\"4.1\",'+
            '            \"SRTCode\":\"04-00B-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Administrative Time - Open and Close Web-Based Claims\",'+
            '            \"HrsUnit\":\"0.1\",'+
            '            \"SRTCode\":\"00-906-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Engine Wiring Harness - Remove and Install - QSF3.8 CM2880 F112\",'+
            '            \"HrsUnit\":\"2.4\",'+
            '            \"SRTCode\":\"19-06Y-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Mobile Vehicle/Equipment Lift System- Set Up\",'+
            '            \"HrsUnit\":\"0.6\",'+
            '            \"SRTCode\":\"17-154-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Engine Wiring Harness - Remove and Install - ISF3.8 CM2350 F109\",'+
            '            \"HrsUnit\":\"2.4\",'+
            '            \"SRTCode\":\"19-03V-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Fuel Drain Lines - Remove and Install - ISF3.8 CM2350 F109\",'+
            '            \"HrsUnit\":\"0.3\",'+
            '            \"SRTCode\":\"06-02U-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - Main Bearing Noise\",'+
            '            \"HrsUnit\":\"0.5\",'+
            '            \"SRTCode\":\"TS-060-03\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - Engine Difficult to Start or Will Not Start, Exhaust Smoke Present (Electronic Engine)\",'+
            '            \"HrsUnit\":\"0.3\",'+
            '            \"SRTCode\":\"TS-137-03\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - Engine Performance, Air Handling Diagnostics\",'+
            '            \"HrsUnit\":\"1.2\",'+
            '            \"SRTCode\":\"TT-005-07\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - Engine Noise Excessive - Drive Belt\",'+
            '            \"HrsUnit\":\"0.1\",'+
            '            \"SRTCode\":\"TS-160-01\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - ECM No Communication, Check Datalink Adapter Power\",'+
            '            \"HrsUnit\":\"0.1\",'+
            '            \"SRTCode\":\"TT-024-01\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Cylinder Block - Machine Camshaft Bore Oversize for Standard Bushing, First\",'+
            '            \"HrsUnit\":\"0\",'+
            '            \"SRTCode\":\"01-562-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Piston - Remove and Install, First\",'+
            '            \"HrsUnit\":\"2.4\",'+
            '            \"SRTCode\":\"01-136-01\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Capscrew, Cylinder Head, Main Cap, Flywheel or Damper - Magnetic Crack Check, Each Four\",'+
            '            \"HrsUnit\":\"0\",'+
            '            \"SRTCode\":\"22-401-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"PM Inspection 21 - 45 / Diesel\",'+
            '            \"HrsUnit\":\"1.5\",'+
            '            \"SRTCode\":\"99-214-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Engine Support Bracket, Rear - Remove and Install, Both\",'+
            '            \"HrsUnit\":\"0.5\",'+
            '            \"SRTCode\":\"16-102-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Aftertreatment - Snap Test (Aftertreatment Connected)\",'+
            '            \"HrsUnit\":\"0.1\",'+
            '            \"SRTCode\":\"14-722-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Rocker Lever Assembly - Remove and Install, First\",'+
            '            \"HrsUnit\":\"0.7\",'+
            '            \"SRTCode\":\"03-106-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - Intake Manifold Air Temperature Above Specification\",'+
            '            \"HrsUnit\":\"0\",'+
            '            \"SRTCode\":\"TS-072-02\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Engine - Rebuild\",'+
            '            \"HrsUnit\":\"0\",'+
            '            \"SRTCode\":\"00-201-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - ECM No Communication, Initial Check of Datalink Adapter and INSITE\",'+
            '            \"HrsUnit\":\"0\",'+
            '            \"SRTCode\":\"TT-021-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Coolant Bypass Tube - Remove and Install\",'+
            '            \"HrsUnit\":\"0.3\",'+
            '            \"SRTCode\":\"08-101-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Component Connector and Pin - Inspection, Each Four\",'+
            '            \"HrsUnit\":\"0.1\",'+
            '            \"SRTCode\":\"19-361-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - Engine Crankcase Gases (Blowby) Excessive\",'+
            '            \"HrsUnit\":\"0.2\",'+
            '            \"SRTCode\":\"TS-019-01\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Radiator - Remove and Install (Part of Another Repair), (Common Rail Fuel System)\",'+
            '            \"HrsUnit\":\"1.2\",'+
            '            \"SRTCode\":\"17-203-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Crankcase Breather Disc - Remove and Install\",'+
            '            \"HrsUnit\":\"1\",'+
            '            \"SRTCode\":\"03-802-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - Engine Power Output Low (Electronic Engine)\",'+
            '            \"HrsUnit\":\"0\",'+
            '            \"SRTCode\":\"TS-136-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - Active Fault Codes 613, 1718, 1866, 1935, 1968, 1969, 2312, 2313, 2314, 2321, 2322, 2359, 2372, 2412, 2554, 2634, 2961, 2962, 2963, 2964, 2976, 3164, 3165, 3167,4167,4283\",'+
            '            \"HrsUnit\":\"0.3\",'+
            '            \"SRTCode\":\"FC-037-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Injector - Clean Exterior for Reuse, Each Two\",'+
            '            \"HrsUnit\":\"0.1\",'+
            '            \"SRTCode\":\"06-438-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Coolant Thermostat and/or Seal - Leak Test (With EGR)\",'+
            '            \"HrsUnit\":\"0.7\",'+
            '            \"SRTCode\":\"08-040-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Cylinder Head - Remove and Install\",'+
            '            \"HrsUnit\":\"4.3\",'+
            '            \"SRTCode\":\"02-104-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - Active Fault Codes 2973, 3138, 3144, 3145, 3149, 3151, 3231, 3235, 3236\",'+
            '            \"HrsUnit\":\"0.9\",'+
            '            \"SRTCode\":\"FC-029-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Non SRT details- Campaign/TRP/ATC-0.1Hr\",'+
            '            \"HrsUnit\":\"0.1\",'+
            '            \"SRTCode\":\"99-902-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - Engine Performance, No Start\",'+
            '            \"HrsUnit\":\"0.4\",'+
            '            \"SRTCode\":\"TT-002-03\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - ECM No Communication, Check Service Tool Hardware\",'+
            '            \"HrsUnit\":\"0.5\",'+
            '            \"SRTCode\":\"TT-029-04\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Engine Exhaust Brake - Remove and Install\",'+
            '            \"HrsUnit\":\"0.7\",'+
            '            \"SRTCode\":\"20-106-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - Air Compressor Pumping Excessive Oil into Air System\",'+
            '            \"HrsUnit\":\"0\",'+
            '            \"SRTCode\":\"TS-003-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Gear Housing - Remove and Install\",'+
            '            \"HrsUnit\":\"2\",'+
            '            \"SRTCode\":\"01-122-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Aftertreatment DEF Dosing Unit - Flush (Air Assisted)\",'+
            '            \"HrsUnit\":\"0.5\",'+
            '            \"SRTCode\":\"11-402-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - Engine Performance, Engine Mechanical Checks\",'+
            '            \"HrsUnit\":\"0.8\",'+
            '            \"SRTCode\":\"TT-008-03\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - Lubricating Oil Temperature Above Normal\",'+
            '            \"HrsUnit\":\"0\",'+
            '            \"SRTCode\":\"TS-059-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - Lubricating Oil Pressure High\",'+
            '            \"HrsUnit\":\"0\",'+
            '            \"SRTCode\":\"TS-056-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Tappet - Remove and Install, All (With Service Tool Part No. 3822513) (Camshaft Removed), (Common Rail Fuel System)\",'+
            '            \"HrsUnit\":\"0.3\",'+
            '            \"SRTCode\":\"04-213-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - Engine Noise Excessive, Combustion Knocks\",'+
            '            \"HrsUnit\":\"1.5\",'+
            '            \"SRTCode\":\"TS-081-07\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Alternator - Initial Check\",'+
            '            \"HrsUnit\":\"0.2\",'+
            '            \"SRTCode\":\"13-603-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Engine Oil Heater, Electric - Remove and Install, Each\",'+
            '            \"HrsUnit\":\"0.2\",'+
            '            \"SRTCode\":\"17-121-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"OEM Throttle Pedal - Remove and Install, (Common Rail Fuel System)\",'+
            '            \"HrsUnit\":\"0.3\",'+
            '            \"SRTCode\":\"19-229-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Aftertreatment Diesel Exhaust Fluid Dosing Unit - Remove and Install (with SCR)\",'+
            '            \"HrsUnit\":\"0\",'+
            '            \"SRTCode\":\"19-037-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Thread Insert, Keensert! or Heli-Coil! - Install, Each\",'+
            '            \"HrsUnit\":\"0.3\",'+
            '            \"SRTCode\":\"22-505-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"PM Group 24 Battery Replacement\",'+
            '            \"HrsUnit\":\"0.5\",'+
            '            \"SRTCode\":\"99-239-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Aftertreatment DEF Dosing Unit - Remove and Install\",'+
            '            \"HrsUnit\":\"0\",'+
            '            \"SRTCode\":\"11-079-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Camshaft Position Sensor - Remove and Install - QSF3.8 CM2350 F118\",'+
            '            \"HrsUnit\":\"0.1\",'+
            '            \"SRTCode\":\"19-09F-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Crankshaft Speed Indicator Ring - Remove and Install - ISF3.8 CM2350 F109\",'+
            '            \"HrsUnit\":\"0.7\",'+
            '            \"SRTCode\":\"01-05W-00\"'+
            '         },'+
            '         {'+
            '            \"SRTDescription\":\"Troubleshoot - ECM No Communication, Check With Bench Top Harness\",'+
            '            \"HrsUnit\":\"0\",'+
            '            \"SRTCode\":\"TT-022-07\"'+
            '         }'+
            '      ]'+
            '   },'+
            '   \"Header\":{'+
            '      \"Status\":\"Success\"'+
            '   }'+
            '}');
        } else if((req.requestURI).contains('MxSRTOver')){
            res.responseBody = Blob.valueOf('{'+
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
            '}');
        } else if((req.requestURI).contains('MxPrtsData')){
            res.responseBody = Blob.valueOf('{'+
            '   \"DataArea\":{'+
            '      \"PartNumberLong\":\"006439500\",'+
            '      \"KitPartFlag\":\"N\",'+
            '      \"SupersededPartNumber\":\"\",'+
            '      \"PartDescription\":\"GSK,COV\",'+
            '      \"PartInService\":\"Y\"'+
            '   },'+
            '   \"Header\":{'+
            '      \"Status\":\"Success\"'+
            '   }'+
            '}');
        } else if((req.requestURI).contains('MxCreatStm')){
            res.responseBody = Blob.valueOf('{'+
            '   \"Header\": {'+
            '       \"Status\": \"success\",'+
            '       \"ReturnCodeDescription\": \"message_ifany\"'+
            '   },'+
            '   \"DataArea\": {'+
            '       \"MsgTransaction\": \"msg_transaction\",'+
            '       \"MsgDescription\": \"msg_description\"'+
            '   }'+
            '}');
        } else if((req.requestURI).contains('getStatementMX')){
            res.responseBody = Blob.valueOf('{'+
            '   \"Header\": {'+
            '       \"Status\": \"success\",'+
            '       \"ReturnCodeDescription\": \"message_ifany\"'+
            '   },'+
            '   \"DataArea\": {'+
            '       \"MsgTransaction\": \"msg_transaction\",'+
            '       \"MsgDescription\": \"msg_description\"'+
            '   }'+
            '}');
        } else if((req.requestURI).contains('getCurrencyExchange')){
            res.responseBody = Blob.valueOf('{'+
            '   \"Header\": {'+
            '       \"Status\": \"success\",'+
            '       \"ReturnCodeDescription\": \"message_ifany\"'+
            '   },'+
            '   \"DataArea\": {'+
            '       \"ConversionRate\": \"150.00\"'+
            '   }'+
            '}');
        } else if((req.requestURI).contains('getCssAmount')){
            res.responseBody = Blob.valueOf('{'+
            '   \"Header\": {'+
            '       \"Status\": \"success\",'+
            '       \"ReturnCodeDescription\": \"message_ifany\"'+
            '   },'+
            '   \"DataArea\": {'+
            '       \"Status\": \"Success/Error\",'+
            '       \"ErrorMessage\": \"Error Message if any\"'+
            '   }'+
            '}');
        } else if((req.requestURI).contains('MxHeadVal')){
            res.responseBody = Blob.valueOf('{'+
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
            '}');
        } else if((req.requestURI).contains('MxFailVal')){
            res.responseBody = Blob.valueOf('{'+
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
            '}');
        } else if((req.requestURI).contains('MxPrtsVal')){
            res.responseBody = Blob.valueOf('{'+
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
            '}');
        } else if((req.requestURI).contains('MxTraVal')){
            res.responseBody = Blob.valueOf('{'+
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
            '}');
        } else if((req.requestURI).contains('MxOCVal')){
            res.responseBody = Blob.valueOf('{'+
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
            '}');
        } else if((req.requestURI).contains('MxSRTVal')){
            res.responseBody = Blob.valueOf('{'+
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
            '        \"status\": \"Success\"'+
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
            '}');
        } else if((req.requestURI).contains('MxPreSub')){
            res.responseBody = Blob.valueOf('{'+
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
        '          \"type\": \"WARNING\"'+
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
        '          \"quantity\": \"\"'+
        '         }'+
        '        ],'+
        '        \"payCode\": \"R\",'+
        '        \"status\": \"Draft\",'+
        '        \"totalLaborAmt\": \"\",'+
        '        \"authorizationNumber\": 123,'+
        '        \"parts\": ['+
        '         {'+
        '          \"partPrice\": \"\"'+
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
        '}');
        } else if((req.requestURI).contains('MxClaimSub')){
            res.responseBody = Blob.valueOf('{'+
            '   \"DataArea\":{'+
            '      \"Status\":\"Success\",'+
            '      \"ErrorMessage\":\"\",'+
            '      \"ClaimNumber\":\"1-15067818\"'+
            '   },'+
            '   \"Header\":{'+
            '      \"ReturnCodeDescription\":\"\",'+
            '      \"Status\":\"Success\"'+
            '   }'+
            '}');
        } else {
            res.responseBody = Blob.valueOf('{"URI":" ' + req.requestURI + '"}');
            code = 404;
        }
        res.statusCode = code;
    }

}