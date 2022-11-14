/**********************************************************************
Name:CG_BMSSendMiscChargesReqWrapper
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:  
Sending Misc charges to BMS  #133133                                                        
=======================================================================
History                                                            
-------                                                            
VERSION   AUTHOR          DATE                 DETAIL                                 
1.0 -    Anvesh Reddy      04/19/2018        INITIAL DEVELOPMENT  
=======================================================================
***********************************************************************/
public class CG_BMSSendMiscChargesReqWrapper {

public class Sender {
public String ServiceName;
public String SenderID;
}

public class Target {
public String TargetID;
}

public Header Header;
public DataArea DataArea;

public class DataArea {
public String CSSJobID;
public String DistributorCode;
public String BranchCode;
public String CustomerCode;
public String OrderType;
public String BMSReferenceNumber;
public List<MiscDetails> MiscDetails;
}

public class Header {
public Target Target;
public Sender Sender;
public Location Location;
}

public class MiscDetails {
public String ClaimType;
public String MiscName;
public Integer Quantity;
public Decimal Amount;
public String MiscOC;
public String CreateUser;
public String ChangeUser;
}

public class Location {
public String LocationID;
}


public static CG_BMSSendMiscChargesReqWrapper parse(String json) {
return (CG_BMSSendMiscChargesReqWrapper) System.JSON.deserialize(json, CG_BMSSendMiscChargesReqWrapper.class);
}
}