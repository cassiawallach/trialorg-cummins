/**********************************************************************
Name:CG_SendNotesSiebelResponseWrapper
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:  
Sending Notes Details to Siebel  #147239                                                        
=======================================================================
History                                                            
-------                                                            
VERSION   AUTHOR          			DATE                 DETAIL                                 
1.0 -    Rajasekhar Hindupur      07/30/2018        INITIAL DEVELOPMENT  
=======================================================================
***********************************************************************/
public class CG_SendNotesSiebelResponseWrapper{
    
    public Header Header;
    
    public class Header {
        public String SiebelClaimNumber;
        public String Status;
        public String ReturnCodeDescription;
    }
    
    public static CG_SendNotesSiebelResponseWrapper parse(String json){
        return (CG_SendNotesSiebelResponseWrapper) System.JSON.deserialize(json, CG_SendNotesSiebelResponseWrapper.class);
    
   }
 }