/************************************************************
    Name:  OSM_CheckRecursive
    Copyright © 2018  Cummins
    =============================================================
    =============================================================
    Purpose:                                                            
    This class is developed to create intercompany sales order and 
    invoice record.              
    =============================================================
    =============================================================
    History                                                            
    -------                                                            
    VERSION  AUTHOR                DATE              DETAIL  
    
 ***************************************************************/                              
   
public Class OSM_CheckRecursive{
    private static boolean run = true;
    public static boolean runOnce(){
    if(run){
     run=false;
     return true;
    }else{
        return run;
 }
    }
}