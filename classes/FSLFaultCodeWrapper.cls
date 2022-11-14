/**********************************************************************
Name: FSLFaultCodeWrapper
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is a wrapper class for get fault codes on monthly batch.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Ravikanth Macherla         2/19/2019                         
***********************************************************************/
global class FSLFaultCodeWrapper {
    
    global string Id;
    global string PID;
    global string SID;
    global string MID;
    global string Name;
    global string AWL_Suppression_Reserved_2;
    global string J1939FMI;
    global string Information;
    global string AWL_Suppression;
    global string LanguageKey;
    global string Revision ;
    global string Special_Instructions;
    global string Cummins_Fault_Code;
    global string SPN;
    global string J2012_Pcode;
    global string Published_in_CES_14602;
    global string Algorithm_Description;
    global string Lamp_Device ;
    global string Lamp_Color ;
    global string Cummins_Description ;
    global FSLFaultCodeWrapper(){
    }
}