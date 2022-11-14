public class CG_OP_GetEngineDataPlateRespWrapper {

	public String engineSerialNumber;
	public List<Data> data;

	public class Data {
	    public String engineBuild; // Coming as per new REST Response, added 18092019
		public String response; //not coming as part of REST response now
		public String responseMsg; //not coming as part of REST response now
		public String vin;
		public String serviceEngineModel;
		public String marketingEngineModel;
		public String engineBuildDate;
		public String warrantyStartDate;
		public String epaModelName;
		public String shopOrder;
		public String engineBuildPlant;
		public String ecmCode;
		public String fuelPumpPartNumber;
		public String fuelPumpCalibration; //not coming as part of REST response now -- consider it same as fuelPumpCode as per QSOL team
		public String marketingConfig;
		public String technicalConfig;
		public String cplNumber;
		public String customerNumber;
		public String businessUnit; //not coming as part of REST response now -- Always EBU as per QSOL team
	}

	
	public static CG_OP_GetEngineDataPlateRespWrapper parse(String json) {
		return (CG_OP_GetEngineDataPlateRespWrapper) System.JSON.deserialize(json, CG_OP_GetEngineDataPlateRespWrapper.class);
	}
}