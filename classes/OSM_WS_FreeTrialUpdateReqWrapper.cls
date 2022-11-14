/************************************************************
Name:  OSM_WS_FreeTrialUpdateReqWrapper 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is wrapper class that will contain old/new values of
quantity and subscription end date. This will be populated 
through trigger handler on update of susbcription record.
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         01/07/2018     INITIAL DEVELOPMENT          


*************************************************************/
public class OSM_WS_FreeTrialUpdateReqWrapper{
    
    //Self explanatory
    public Decimal PreviousQuantity; 
    public Decimal CurrentQuantity;
    public DateTime PreviousEndDate;
    public DateTime CurrentEndDate;
    public Id subscriptionId;

}