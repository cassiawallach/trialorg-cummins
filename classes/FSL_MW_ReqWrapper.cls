/*
* CT3-237: This class used for send INSITE image names to MW API . 
* @Author: Dinesh Yadav, Created Date: 9 Dec 2020.
*/ 
public class FSL_MW_ReqWrapper {
    public Header Header;
    public DataArea DataArea;

    public class Header {
        public Sender Sender;
        public Target Target;
    }
    
    public class Sender {
        public String ServiceName; //ECMimages
        public String SenderID; //GuidanzWeb
    }

    public class Target {
        public String TargetID; //AzureFiles
    }

    public class DataArea {
        public List<String> Images;
    }
    
    public static FSL_MW_ReqWrapper parse(String json) {
        return (FSL_MW_ReqWrapper) System.JSON.deserialize(json, FSL_MW_ReqWrapper.class);
    }
}