/**********************************************************************
Name:CG_SendNotesSiebelOutboundRequestWrapper
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:  
Sending Notes Details to Siebel  #147239                                                        
=======================================================================
History                                                            
-------                                                            
VERSION   AUTHOR          DATE                 DETAIL                                 
1.0 -    Rajasekhar Hindupur      07/27/2018        INITIAL DEVELOPMENT  
=======================================================================
***********************************************************************/
public class CG_SendNotesSiebelOutboundRequestWrapper
{
    
    public class Sender {
        public String ServiceName;
        public String SenderID;
    }
    
    public class NoteDetails {
        public String Note;    
        public String ExtNoteId;
        public String NoteType;
    }
    
    public class Target {
        public String TargetID;
    }
    
    public class DataArea {
        public String SiebelClaimNumber;
        //public String ReqOperation = 'Create';
        public String ReqOperation;
        public List<NoteDetails> NoteDetails;
    }
    
    public class Header {
        public Target Target;
        public Sender Sender;
    }
    
    public Header Header;
    public DataArea DataArea;
    
    public static CG_SendNotesSiebelOutboundRequestWrapper parse(String json)
    {
       return (CG_SendNotesSiebelOutboundRequestWrapper) System.JSON.deserialize(json, CG_SendNotesSiebelOutboundRequestWrapper.class);
        
    }
}