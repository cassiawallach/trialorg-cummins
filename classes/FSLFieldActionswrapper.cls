/**********************************************************************
Name: FSLFieldActionswrapper
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class written for to get FieldActionsSRT' webservice for Field actions when the supervisor checks ‘Required to perform/review’ and saves.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Ravikanth Macherla         05/16/2019                         
***********************************************************************/
public class FSLFieldActionswrapper{
    
    public cls_DataArea DataArea;
    public cls_Header Header;
    public cls_FieldAction fldAction;
    
    public class cls_DataArea {
        public cls_FieldAction[] FieldAction;
    }
    public class cls_FieldAction {
        public String FieldActionNumber;    //1609
        public String FieldActionType;  //TRP
        public cls_FieldActionSRTTime[] FieldActionSRTTime;
    }
    public class cls_FieldActionSRTTime {
        public String SRTDetails ;
        public Decimal SRTQuantity ;
        public Decimal SRTTime ;
        public String SRTTitle ;
        public String SRTAccessCode ;
        public String Assignment ;
        public String Type;
        public String StepID;
        public String StepDescription;
        public Decimal ATIME;
        public Decimal BTIME;
        public Decimal CTIME;
        public Decimal DTIME;
        public Decimal RTIME;
        public Decimal S1TIME;
        public Decimal S2TIME;
        public Decimal S3TIME;
        public Decimal S4TIME;
        public Decimal S5TIME;
        public Decimal S6TIME;
        public Decimal S7TIME;
        public Decimal S8TIME;
        public Decimal S9TIME;
    }
    public class cls_Header {
        public String Status;   //Success
        public String ReturnCode;   //ORA-00000
        public String ReturnCodeDescription;    //Normal, Successful completion.
        public String MessageIdentifier;    //S
        public String FieldActionNumber;
    }
    
    /* public Header Header;
public DataArea DataArea;

//     public List<Details> Details;

public class Header{
public String MessageIdentifier{get;set;}
public String ReturnCode{get;set;}
public String ReturnCodeDescription{get;set;}
public String Status{get;set;}
}

public class DataArea{
public list<Details> Details {get;set;} 
}    

public class Details {
public String Status;   //Success
public String ReturnCode;   //ORA-00000
public String ReturnCodeDescription;    //Normal, Successful completion.
public String MessageIdentifier;    //S 

} */
    
    public static FSLFieldActionswrapper parse(String json){
        return (FSLFieldActionswrapper) System.JSON.deserialize(json, FSLFieldActionswrapper.class);
    }
}