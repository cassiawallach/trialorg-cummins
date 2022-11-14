@IsTest
public class CG_OP_GetOptionsRespWrapper_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '['+
		'    {'+
		'        \"optionNumber\": \"PE1027-05\",'+
		'        \"optionDescription\": \"Aftertreatment Device\",'+
		'        \"repairGroup\": \"11.01.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PE1715-03\",'+
		'        \"optionDescription\": \"DOSER,FLUID\",'+
		'        \"repairGroup\": \"11.01.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PE1715-01\",'+
		'        \"optionDescription\": \"Fluid Doser\",'+
		'        \"repairGroup\": \"11.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"CP1183-03\",'+
		'        \"optionDescription\": \"Air Compressor\",'+
		'        \"repairGroup\": \"12.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"ER1014-07\",'+
		'        \"optionDescription\": \"Exhaust Recirculation\",'+
		'        \"repairGroup\": \"11.01.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"IC1112-01\",'+
		'        \"optionDescription\": \"CONNECTION,AIR INTAKE\",'+
		'        \"repairGroup\": \"10.01.2\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"IM1837\",'+
		'        \"optionDescription\": \"Air Intake Manifold\",'+
		'        \"repairGroup\": \"10.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"IT1033-01\",'+
		'        \"optionDescription\": \"Air Transfer Connection\",'+
		'        \"repairGroup\": \"10.01.2\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PP10321\",'+
		'        \"optionDescription\": \"Turbocharger\",'+
		'        \"repairGroup\": \"10.05\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PP10357\",'+
		'        \"optionDescription\": \"NOZZLE, PISTON COOLING\",'+
		'        \"repairGroup\": \"01.01.2\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PP10357\",'+
		'        \"optionDescription\": \"PISTON, CONN ROD AND\",'+
		'        \"repairGroup\": \"01.04\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PP10359\",'+
		'        \"optionDescription\": \"Cylinder Head\",'+
		'        \"repairGroup\": \"02.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PP10360\",'+
		'        \"optionDescription\": \"Injector\",'+
		'        \"repairGroup\": \"06.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"TB1469-02\",'+
		'        \"optionDescription\": \"ARRANGEMENT,TURBOCHARGER\",'+
		'        \"repairGroup\": \"10.06.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"TP1813-02\",'+
		'        \"optionDescription\": \"PLUMBING,TURBOCHARGER\",'+
		'        \"repairGroup\": \"10.06.2\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"BB1909\",'+
		'        \"optionDescription\": \"BLOCK,CYLINDER\",'+
		'        \"repairGroup\": \"01.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"BB1909\",'+
		'        \"optionDescription\": \"Crankshaft\",'+
		'        \"repairGroup\": \"01.02\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"BB1909\",'+
		'        \"optionDescription\": \"Cus Accessory Brace\",'+
		'        \"repairGroup\": \"16.04.2\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"BB1909\",'+
		'        \"optionDescription\": \"Cylinder Liner Kit\",'+
		'        \"repairGroup\": \"01.01.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"BB1909\",'+
		'        \"optionDescription\": \"Gear Housing Brace\",'+
		'        \"repairGroup\": \"01.09.2\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"BB1909\",'+
		'        \"optionDescription\": \"Gear Housing Sensor Adapter\",'+
		'        \"repairGroup\": \"01.09.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"BB1909\",'+
		'        \"optionDescription\": \"Gear Housing/Idler Gears\",'+
		'        \"repairGroup\": \"01.09\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"EB1207\",'+
		'        \"optionDescription\": \"Engine Brake\",'+
		'        \"repairGroup\": \"03.04\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"HC1004\",'+
		'        \"optionDescription\": \"Cabin Heater Plumbing\",'+
		'        \"repairGroup\": \"08.13.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PP10321\",'+
		'        \"optionDescription\": \"Turbocharger\",'+
		'        \"repairGroup\": \"10.05\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PP10342\",'+
		'        \"optionDescription\": \"CAMSHAFT\",'+
		'        \"repairGroup\": \"01.07\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PP10357\",'+
		'        \"optionDescription\": \"NOZZLE, PISTON COOLING\",'+
		'        \"repairGroup\": \"01.01.2\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PP10357\",'+
		'        \"optionDescription\": \"PISTON, CONN ROD AND\",'+
		'        \"repairGroup\": \"01.04\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PP10359\",'+
		'        \"optionDescription\": \"Cylinder Head\",'+
		'        \"repairGroup\": \"02.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PP10360\",'+
		'        \"optionDescription\": \"Injector\",'+
		'        \"repairGroup\": \"06.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"RL1754-03\",'+
		'        \"optionDescription\": \"LEVER,ROCKER\",'+
		'        \"repairGroup\": \"03.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"VC1088\",'+
		'        \"optionDescription\": \"ARRANGEMENT,VALVE COVER\",'+
		'        \"repairGroup\": \"03.01.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"CI1725-01\",'+
		'        \"optionDescription\": \"Air Cpr Inlet Arrangement\",'+
		'        \"repairGroup\": \"12.01.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"CP1183-03\",'+
		'        \"optionDescription\": \"Air Compressor\",'+
		'        \"repairGroup\": \"12.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"WP1744-03\",'+
		'        \"optionDescription\": \"PUMP,WATER\",'+
		'        \"repairGroup\": \"08.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"FH11059-12\",'+
		'        \"optionDescription\": \"Flywheel Housing\",'+
		'        \"repairGroup\": \"16.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"WR1717-01\",'+
		'        \"optionDescription\": \"Wiring Accessories\",'+
		'        \"repairGroup\": \"21.02\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"CH1021-02\",'+
		'        \"optionDescription\": \"AID,COO HEATER STARTING\",'+
		'        \"repairGroup\": \"10.02\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"CP1183-03\",'+
		'        \"optionDescription\": \"Air Compressor\",'+
		'        \"repairGroup\": \"12.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"EC1726-04\",'+
		'        \"optionDescription\": \"THERMOSTAT\",'+
		'        \"repairGroup\": \"08.07\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"HC1004\",'+
		'        \"optionDescription\": \"Cabin Heater Plumbing\",'+
		'        \"repairGroup\": \"08.13.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"IM1837\",'+
		'        \"optionDescription\": \"Air Intake Manifold\",'+
		'        \"repairGroup\": \"10.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"TH1217\",'+
		'        \"optionDescription\": \"ARRANGEMENT,THM HOUSING\",'+
		'        \"repairGroup\": \"08.07\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"TH1711\",'+
		'        \"optionDescription\": \"HOUSING,THERMOSTAT\",'+
		'        \"repairGroup\": \"08.07\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"TP1813-02\",'+
		'        \"optionDescription\": \"PLUMBING,TURBOCHARGER\",'+
		'        \"repairGroup\": \"10.06.2\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"WF1242-02\",'+
		'        \"optionDescription\": \"RESISTOR,CORROSION\",'+
		'        \"repairGroup\": \"08.08\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"WI1118\",'+
		'        \"optionDescription\": \"CONNECTION,WATER INLET\",'+
		'        \"repairGroup\": \"08.07.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"WO1126-02\",'+
		'        \"optionDescription\": \"CONNECTION,WATER OUTLET\",'+
		'        \"repairGroup\": \"08.07.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"WP1744-03\",'+
		'        \"optionDescription\": \"PUMP,WATER\",'+
		'        \"repairGroup\": \"08.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"CF1072\",'+
		'        \"optionDescription\": \"Ref Compressor Mounting\",'+
		'        \"repairGroup\": \"12.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"DA1237-03\",'+
		'        \"optionDescription\": \"Vibration Damper\",'+
		'        \"repairGroup\": \"01.02.2\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"EH1120-02\",'+
		'        \"optionDescription\": \"Alternator Mounting\",'+
		'        \"repairGroup\": \"13.02.3\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"EM1355-01\",'+
		'        \"optionDescription\": \"Front Engine Support\",'+
		'        \"repairGroup\": \"16.03\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"FA1511-01\",'+
		'        \"optionDescription\": \"DRIVE,FAN\",'+
		'        \"repairGroup\": \"08.03\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"FH11059-12\",'+
		'        \"optionDescription\": \"Flywheel Housing\",'+
		'        \"repairGroup\": \"16.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"FW1020-06\",'+
		'        \"optionDescription\": \"Flywheel\",'+
		'        \"repairGroup\": \"16.02\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"FW1701\",'+
		'        \"optionDescription\": \"MOUNTING,FLYWHEEL\",'+
		'        \"repairGroup\": \"16.02.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"GG1749-01\",'+
		'        \"optionDescription\": \"COVER,FRONT GEAR\",'+
		'        \"repairGroup\": \"01.06\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"LA1718-02\",'+
		'        \"optionDescription\": \"Lifting Bracket Mounting\",'+
		'        \"repairGroup\": \"17.06\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PP10321\",'+
		'        \"optionDescription\": \"Turbocharger\",'+
		'        \"repairGroup\": \"10.05\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PP10357\",'+
		'        \"optionDescription\": \"NOZZLE, PISTON COOLING\",'+
		'        \"repairGroup\": \"01.01.2\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PP10357\",'+
		'        \"optionDescription\": \"PISTON, CONN ROD AND\",'+
		'        \"repairGroup\": \"01.04\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PP10359\",'+
		'        \"optionDescription\": \"Cylinder Head\",'+
		'        \"repairGroup\": \"02.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PP10360\",'+
		'        \"optionDescription\": \"Injector\",'+
		'        \"repairGroup\": \"06.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"SM1732-02\",'+
		'        \"optionDescription\": \"MOUNTING,STARTING MOTOR\",'+
		'        \"repairGroup\": \"13.05.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"WR1717-01\",'+
		'        \"optionDescription\": \"Wiring Accessories\",'+
		'        \"repairGroup\": \"21.02\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"CH1021-02\",'+
		'        \"optionDescription\": \"AID,COO HEATER STARTING\",'+
		'        \"repairGroup\": \"10.02\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PH1818-09\",'+
		'        \"optionDescription\": \"Engine Control Module\",'+
		'        \"repairGroup\": \"05.06.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PH1826-01\",'+
		'        \"optionDescription\": \"Eng Cnt Module Plumbing\",'+
		'        \"repairGroup\": \"05.06.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"SV1001\",'+
		'        \"optionDescription\": \"Engine Operating Voltage\",'+
		'        \"repairGroup\": \"13.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"WR1717-01\",'+
		'        \"optionDescription\": \"Wiring Accessories\",'+
		'        \"repairGroup\": \"21.02\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"DL1068\",'+
		'        \"optionDescription\": \"LOCATION, DRAIN\",'+
		'        \"repairGroup\": \"06.07\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"FD1706\",'+
		'        \"optionDescription\": \"Fuel Drain Plumbing\",'+
		'        \"repairGroup\": \"17.05\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"FF1308\",'+
		'        \"optionDescription\": \"FILTER,FUEL\",'+
		'        \"repairGroup\": \"06.04\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"FP10278\",'+
		'        \"optionDescription\": \"PUMP, FUEL\",'+
		'        \"repairGroup\": \"05.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"FS1732\",'+
		'        \"optionDescription\": \"Fuel System Primer\",'+
		'        \"repairGroup\": \"05.19\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"PP10323-03\",'+
		'        \"optionDescription\": \"PLUMBING,INJECTOR\",'+
		'        \"repairGroup\": \"06.01.2\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"BR1296\",'+
		'        \"optionDescription\": \"BREATHER,CRANKCASE\",'+
		'        \"repairGroup\": \"03.02\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"LC1751-01\",'+
		'        \"optionDescription\": \"COOLER,ENGINE OIL\",'+
		'        \"repairGroup\": \"07.05\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"LF1232-03\",'+
		'        \"optionDescription\": \"FILTER,FULL FLOW OIL\",'+
		'        \"repairGroup\": \"07.03\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"LG1148-04\",'+
		'        \"optionDescription\": \"GAUGE,OIL LEVEL\",'+
		'        \"repairGroup\": \"07.02\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"LP1729-03\",'+
		'        \"optionDescription\": \"PUMP,LUBRICATING OIL\",'+
		'        \"repairGroup\": \"07.06\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"OB1443-02\",'+
		'        \"optionDescription\": \"ARRANGEMENT,OIL FILL\",'+
		'        \"repairGroup\": \"07.02\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"TP1813-02\",'+
		'        \"optionDescription\": \"PLUMBING,TURBOCHARGER\",'+
		'        \"repairGroup\": \"10.06.2\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"DO1813\",'+
		'        \"optionDescription\": \"SOFTWARE,CUS INTERFACE\",'+
		'        \"repairGroup\": \"99.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"FCP846\",'+
		'        \"optionDescription\": \"CALIBRATION,FUEL PUMP\",'+
		'        \"repairGroup\": \"99.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"FR10993\",'+
		'        \"optionDescription\": \"RATING,FUEL\",'+
		'        \"repairGroup\": \"99.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"NN1735\",'+
		'        \"optionDescription\": \"Nameplate\",'+
		'        \"repairGroup\": \"01.06.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"SC12085\",'+
		'        \"optionDescription\": \"SOFTWARE,CALIBRATION\",'+
		'        \"repairGroup\": \"99.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"EB1207\",'+
		'        \"optionDescription\": \"Engine Brake\",'+
		'        \"repairGroup\": \"03.04\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"AP8122\",'+
		'        \"optionDescription\": \"Agency Approval\",'+
		'        \"repairGroup\": \"01.06.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"FA1511-01\",'+
		'        \"optionDescription\": \"Fan Drive\",'+
		'        \"repairGroup\": \"08.03\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"FW1701\",'+
		'        \"optionDescription\": \"FLYWHEEL MOUNTING\",'+
		'        \"repairGroup\": \"16.02.1\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"LA1112\",'+
		'        \"optionDescription\": \"ARRANGEMENT, LIFTING\",'+
		'        \"repairGroup\": \"17.06\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"OP1230\",'+
		'        \"optionDescription\": \"Oil Pan\",'+
		'        \"repairGroup\": \"07.01\"'+
		'    },'+
		'    {'+
		'        \"optionNumber\": \"SS1097-01\",'+
		'        \"optionDescription\": \"PAINT\",'+
		'        \"repairGroup\": \"03.01\"'+
		'    }'+
		']';
		List<CG_OP_GetOptionsRespWrapper> r = CG_OP_GetOptionsRespWrapper.parsedata(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		/*CG_OP_GetOptionsRespWrapper objJSON2Apex = new CG_OP_GetOptionsRespWrapper(System.JSON.createParser(json));
		System.assert(objJSON2Apex != null);
		System.assert(objJSON2Apex.optionNumber == null);
		System.assert(objJSON2Apex.optionDescription == null);
		System.assert(objJSON2Apex.repairGroup == null);*/
	}
}