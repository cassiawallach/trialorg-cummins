/***********************************************************
Name: OSM_SW_QueueableBoltInboundJob
Test Class Name:  OSM_BOLT_WS_CustomMasterInbound_Test
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
Manage bulk data for bolt customer inbound                                  
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sharad            08/03/2021     INITIAL DEVELOPMENT          


*************************************************************/

public class OSM_SW_QueueableBoltInboundJob implements Queueable {
    public List<Id> accountIds = new List<Id>();
    public OSM_BOLT_WS_CustomMasterReq reqJSON = null;
    public Map<String,OSM_BOLT_WS_CustomMasterReq.CUST_ACCTS_O_STG_ROW> mapBolt = new Map<String,OSM_BOLT_WS_CustomMasterReq.CUST_ACCTS_O_STG_ROW>();
    public Map<String,OSM_BOLT_WS_CustomMasterReq.CUST_O_STG_ROW> mapBoltCUST = new Map<String,OSM_BOLT_WS_CustomMasterReq.CUST_O_STG_ROW>();
    public String jSONRequestBody;
    public OSM_SW_QueueableBoltInboundJob(List<Id> accountIds1,Map<String,OSM_BOLT_WS_CustomMasterReq.CUST_ACCTS_O_STG_ROW> mapBolt1,Map<String,OSM_BOLT_WS_CustomMasterReq.CUST_O_STG_ROW> mapBoltCUST1,OSM_BOLT_WS_CustomMasterReq reqJSON1,String jSONRequestBody1)
    {
        accountIds = accountIds1;
        reqJSON = reqJSON1;
        mapBolt = mapBolt1;
        mapBoltCUST = mapBoltCUST1;
        jSONRequestBody = jSONRequestBody1;
    }
    public void execute(QueueableContext context) {
        OSM_SW_BatchBoltCustomerInbound inboundBatch = new OSM_SW_BatchBoltCustomerInbound();
        inboundBatch.accountIds = accountIds;
        inboundBatch.reqJSON = reqJSON;
        inboundBatch.mapBolt = mapBolt;
        inboundBatch.mapBoltCUST = mapBoltCUST;
        inboundBatch.jSONRequestBody = jSONRequestBody;
        Database.executeBatch(inboundBatch);
    }
}