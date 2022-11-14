/**********************************************************************
Name: FSL_CL_MROMessageData
Copyright © 2019  Cummins
=======================================================================
=======================================================================
Purpose: This class is used for MRO Messages Integration.

=======================================================================
=======================================================================
                                                                                                                      
VERSION  AUTHOR            DATE                DETAIL                                 
1.0      PiyushR           2/8/2019   	       INITIAL DEVELOPMENT                    
***********************************************************************/

public class FSL_CL_MROMessageData {
    public class DataArea {
        public String Status;
        public String CustomerCode;
        public String ReturnCodeDescription;
        public List<MessageDetails> MessageDetails;
    }

    public class MessageDetails {
        public String Priority;
        public List<TextDetails> TextDetails;
        public String MessageID;
    }

    public class TextDetails {
        public String LnNo;
        public String MessageText;
    }

	public class Sender {
		public String ServiceName;
		public String SenderID;
		public String MessageID;
	}

	public class Target {
		public String TargetID;
	}

	public class Location {
        public String LocationID;
    }

	public class Header {
		public Sender Sender;
		public String Status;
		public Target Target;
		public String ReturnCodeDescription;
		public Location Location;
	}

	public DataArea DataArea;
	public Header Header;

	
	public static FSL_CL_MROMessageData parse(String json) {
		return (FSL_CL_MROMessageData) System.JSON.deserialize(json, FSL_CL_MROMessageData.class);
	}
    /*
    public class DataArea {
        public String Status;
        public String CustomerCode;
        public String ReturnCodeDescription;
        public List<MessageDetails> MessageDetails;
        public String MessageID;
        
    }
    
    public class MessageDetails {
        public String Priority;
        public List<TextDetails> TextDetails;
    }
    
    public class TextDetails {
        public String LnNo;
        public String MessageText;
    }
    
    public class Sender {
        public String ServiceName;
        public String SenderID;
        public String MessageID;
    }
    public class Target {
        public String TargetID;
    }
    public class Location {
        public String LocationID;
    }
    
    public class Header {
        public Sender senders;
        public String Status;
        public Target target;
        public String ReturnCodeDescription;
        public Location location;
    }
    
    public Header Header;
    public DataArea DataArea;
    
    public static FSL_CL_MROMessageData parse(String json) {
        return (FSL_CL_MROMessageData) System.JSON.deserialize(json, FSL_CL_MROMessageData.class);
    } */
}