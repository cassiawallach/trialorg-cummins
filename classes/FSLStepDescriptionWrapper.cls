public class FSLStepDescriptionWrapper {
    
    public header Header;
    public DataArea DataArea;
    Public class Header {
        public sender Sender;
        public Target Target;
        public Header()
        {
            Sender = new Sender();
            Target = new Target();
        }
    }
    public class Sender {
        public string MessageID;// = 'unique message ID at SF';
        public string SenderID;// = 'SF';
        public string ServiceName;// = 'GetStandardRepairTime';
        public Sender()
        {
            MessageID = 'unique message ID at SF';
            SenderID = 'SF';
            ServiceName = 'GetStandardRepairTime';
        }
    }
    public class Target {
        public string TargetID;// = 'SRT';
        public Target()
        {
            TargetID = 'SRT';
        }
    }
    
    public class DataArea {
        public string EquipmentID;
        public string SRTType;
        public string StepID;
          public DataArea()
        {
            EquipmentID='';
            SRTType='';

        }
    }
}