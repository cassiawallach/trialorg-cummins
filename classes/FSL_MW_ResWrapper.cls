/*
* CT3-237: This class used for parse response of 'INSITE image names to MW API' calls . 
* @Author: Dinesh Yadav, Created Date: 9 Dec 2020.
*/ 
public class FSL_MW_ResWrapper {
    public class DataArea {
        public List<Images> Images;
    }

    public Header Header;
    public DataArea DataArea;

    public class Header {
        public String MessageIdentifier;
        public String ReturnCode;
        public String ReturnCodeDescription;
        public String Status;
        public String MessageType;
    }

    public class Images {
        public String FileName;
        public String Exists;
        public String LastModifiedDateTime;
        public String error;
    }

    
    public static FSL_MW_ResWrapper parse(String json) {
        return (FSL_MW_ResWrapper) System.JSON.deserialize(json, FSL_MW_ResWrapper.class);
    }
}