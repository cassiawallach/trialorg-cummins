public class FSL_MakeModelRequestWrapper{
    public cls_Header Header;
    public cls_DataArea DataArea;
    public class cls_Header {
        public cls_Target Target;
        public cls_Sender Sender;
		//------ Below code is added by Ghanshyam here Start here----//
		 public cls_Header()
        {
            Sender = new cls_Sender();
            Target = new cls_Target();
        }
		//------- Above code is Added by Ghanshyam here-----//
    }
    public class cls_Target {
        public String TargetID; //SIEBEL
		//------ Below code is added by Ghanshyam here Start here----//
		public cls_Target()
        {
            TargetId='';
        }
		//------- Above code is Added by Ghanshyam here-----//
    }
    public class cls_Sender {
        public String ServiceName;  //updateMakeModel
        public String SenderID; //CSS
		//---Below code is Added by Ghanshyam  Start here----//
		 public cls_Sender()
        {
            ServiceName='';
            SenderID='';
            //MessageID='';
        }
		//--- Above code is Added by ghanshyam  END Here----//
    }
    public class cls_DataArea {
        public cls_MakeModel[] MakeModel;
		
    }
    public class cls_MakeModel {
        public String Type; //Engines
        public String ModelSeries;  //GAZELLE
        public String PSN;  //76022086 
        public String Manufacturer; //GAZ
        public String ProductApplicationCode;   //
        public String VIN;
		//---Below code is Added by Ghanshyam  Start here----//
		public cls_MakeModel()
        {
            Type='';
            ModelSeries='';
            PSN='';
            Manufacturer='';
            ProductApplicationCode='';
            VIN='';
           
        }
		//---Above code is Added by Ghanshyam  End here----//
    }
    public static FSL_MakeModelRequestWrapper parse(String json){
        return (FSL_MakeModelRequestWrapper) System.JSON.deserialize(json, FSL_MakeModelRequestWrapper.class);
    }
}