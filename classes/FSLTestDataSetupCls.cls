public class FSLTestDataSetupCls { 
    public static Account createAccountData()
    {
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account a = new Account(name='testFSL');
        a.RecordTypeId = accRecId;
        a.BillingStreet = 'test billing Street';
		a.BillingPostalCode = '47201';
		a.BillingCity = 'test city';
		a.BillingState = 'Texas';
		a.BillingCountry = 'United States';
        insert a;
        return a;
    }
    public static Asset createAssetRecord()
    {
        Asset ast = new Asset(name='Assst1',Type_PSN__c='aset1223',Service_Model__c='testmodel');
        insert ast;
        return ast;
    }
    public static WorkOrder createWorkOrder(asset ast, account a)
    {
        WorkOrder wo=new WorkOrder(accountid=a.id, assetid=ast.id);
        insert wo;
        return wo;
    }
    public static string returnAppCode(asset ast, account a)
    {
        WorkOrder wo=new WorkOrder(accountid=a.id, assetid=ast.id);
        insert wo;
        return wo.Application__c;
    }
   
    public static WorkOrder createWorkOrder(asset ast, account a, ServiceTerritory st)
    {
        WorkOrder wo=new WorkOrder(AccountId=a.id, assetid=ast.id, serviceterritoryId=st.Id);
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.FSL_Application_Error_Message__c = '';
        insert wo;
        return wo;
    }
    
   
    
    
    //Method to create CSS_Solutions__c 
    public static CSS_Solutions__c createSolutions(boolean isInsert,Id woId){
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.FSL_Service_Job__c = woId;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        
        solAdd.Name='TestSRTS'+Math.random();
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Diagnostic_notes__c = 'solutions diagnostic notes';
        solAdd.Repair_Notes__c = 'Repair Notes';
        //solAdd.FaultCode__c = 'solution faultcode';
        //solAdd.Repair_Response__c = 'Most likely ';
        solAdd.Repair_Response__c = 'Repair Successful.';
        solAdd.Rank__c = 3;
        if(isInsert){
            insert solAdd;
        }
        return solAdd;
    }
    //Method to create  
    public static  CSS_Solution_Component__c createSRT(boolean isInsert,Id jobId,Id solAdd){
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.FSL_Service_Job__c = jobId;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.Solutions__c = solAdd;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='CAM';
        //AddsolComp.
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='CAM-campaign';
        //Addsolcomp.Part_Assignment__c ='Primary';
        //AddsolComp.Fail_Code__c ='Test-FAilcode';
        //  AddsolComp.FailCode_Formula__c = 'Test-FailCode';   Field is not writeable
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        if(isInsert)
        {
            insert AddsolComp;
        }
        return AddsolComp;
    }
    
    public static ServiceTerritory createServiceTerritory()
    {
        Operatinghours oh=new operatinghours(name='test');
        insert oh;
        ServiceTerritory st = new ServiceTerritory();
        st.City='Test City Mobile';
        //st.Country='United States';
        st.CountryCode='US';
        st.PostalCode='12345';
        st.State='Alabama';
        st.Name='Test Territory1 Mobile';
        st.Location_Code__c='abacc';
        st.OperatingHoursId=oh.id;
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c='ABCX';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        return st;
    }
    public static list<CSS_Integration_Details__c> createIntegrationConfigs()
    {
        List<CSS_Integration_Details__c> cssIntDets = new List<CSS_Integration_Details__c>();
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/getTokenQSOL';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'FSL_GetApiToken_QSOL';
        cssIntDets.add(conDetails);
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.End_Point__c = 'https//test.com/getProcedureLink';
        conDetails1.Passcode__c = 'Admin';
        conDetails1.Username__c = 'Admin';
        conDetails1.Name = 'FSL_QSOL_ProcedureLink'; 
        cssIntDets.add(conDetails1);
        
        CSS_Integration_Details__c conDetails2 = new CSS_Integration_Details__c();
        conDetails2.End_Point__c = 'https//test.com/getFCOverview';
        conDetails2.Passcode__c = 'Admin';
        conDetails2.Username__c = 'Admin';
        conDetails2.Name = 'FSL_QSOL_FCOverview'; 
        cssIntDets.add(conDetails2);
        
        CSS_Integration_Details__c conDetails3 = new CSS_Integration_Details__c();
        conDetails3.End_Point__c = 'https//test.com/getServiceHistory';
        conDetails3.Passcode__c = 'Admin';
        conDetails3.Username__c = 'Admin';
        conDetails3.Name = 'FSL_MoveX_ServiceHistory'; 
        cssIntDets.add(conDetails3);
        
        CSS_Integration_Details__c conDetails4 = new CSS_Integration_Details__c();
        conDetails4.End_Point__c = 'https//test.com/getRetrieveOptionList';
        conDetails4.Passcode__c = 'Admin';
        conDetails4.Username__c = 'Admin';
        conDetails4.Name = 'FSL_QSOL_RetrieveOptionList'; 
        cssIntDets.add(conDetails4);
        conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/getTokenQSOL';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'FSL_QSOL_Getwarrantydocs';
        cssIntDets.add(conDetails); 
        conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/getTokenQSOL';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'GetPartsListSRT';
        cssIntDets.add(conDetails); 
        conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/getTokenQSOL';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'FSLAccessibilityChecklistToken';
        cssIntDets.add(conDetails); 
        conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/getTokenQSOL';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'CG_GETDiagnosticSRT';
        conDetails.Method_Type__c='Get';
        conDetails.IsActive__c=true;
        conDetails.Key__c='test key1';
        cssIntDets.add(conDetails); 
        conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/getTokenQSOL';
        conDetails.Name = 'OAGOAuth';
        conDetails.Method_Type__c='Get';
        conDetails.IsActive__c=true;
        conDetails.Key__c='Kl2WdTIi8i4N55jezpTYGOi5gZ6vXRk/EDxzdcIj47g=';
        conDetails.Passcode__c='STbLSzIQhyVioY0Nt0j8fxsjsdBNjq2NyZLSOtfzgfgMjP5aCKnVK1kCmvl/d0unQKi0DMYXf92Mx5C20l6SVA=='; 
        conDetails.Username__c='wiYlq3UEFXo5AdO/D4p5II75P/I83y1hKcDoPHmCt0Mg0lbS9S1/LFCJenCA6qa2xIvQq9N7VfFPQKt6Vi9XiA==';
        cssIntDets.add(conDetails); 
        conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/getTokenQSOL';
        conDetails.Name = 'CSS_SBL_WarrantyDetailCoverage';
        conDetails.Method_Type__c='Get';
        conDetails.IsActive__c=true;
        conDetails.Key__c='Kl2WdTIi8i4N55jezpTYGOi5gZ6vXRk/EDxzdcIj47g=';
        conDetails.Passcode__c='STbLSzIQhyVioY0Nt0j8fxsjsdBNjq2NyZLSOtfzgfgMjP5aCKnVK1kCmvl/d0unQKi0DMYXf92Mx5C20l6SVA=='; 
        conDetails.Username__c='wiYlq3UEFXo5AdO/D4p5II75P/I83y1hKcDoPHmCt0Mg0lbS9S1/LFCJenCA6qa2xIvQq9N7VfFPQKt6Vi9XiA==';
        cssIntDets.add(conDetails); 
        
        cssIntDets.add(new CSS_Integration_Details__c(name='CG_GETAllSRT',End_Point__c='https://test.url.com',Method_Type__c='Get',Timeout__c=1200));
        insert cssintdets;
        return cssintdets;
    }
    
    public static IAM_CDH_Cross_references__c createSite(Id accId)
    {
        IAM_CDH_Cross_references__c site = new IAM_CDH_Cross_references__c(IAM_Account__c=accId,
                                                                           FSL_City__c='Test City',
                                                                           FSL_Country__c='Australia',
                                                                           FSL_State__c='Queensland',
                                                                           FSL_Site_Status__c='Active'
                                                                          );
        insert site;
        return site;
    }
}