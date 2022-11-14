@istest
public class CG_CL_ClaimsCampaignsTRPandATCComp_Test {
    public static testmethod void CG_CL_ClaimsCampaignsTRPandATCComp_method(){
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.ESN__c='58679858';
        jo.Warranty_Start_Date__c=system.today();
        insert jo;
        css_claims__c claimas = new css_claims__c();
        claimas.Customer_Name__c='Sai';
        claimas.Customer_Code__c='123';
        claimas.CSS_Job__c=jo.Id;
        insert claimas;
        apexpages.currentPage().getparameters().put('id',claimas.Id);
        test.startTest();
        CG_CL_ClaimsCampaignsTRPandATCComp obj = new CG_CL_ClaimsCampaignsTRPandATCComp();
        obj.errorMsg = 'true';
        obj.tnumber = 'test1';
        obj.rWaiver = true;
        //obj.selectedRecordRowID =  '1234567';
        obj.pgId = 'a093B000002E6L2QAK';
        //obj.trackingNumber = true;
        //obj.isReturnwaiver = true;
        //obj.enableTrackingNumber();
        obj.selectedRecordRowID='test';
        //obj.enableTNDropDownCAMPAIGN();
        //obj.enableTNDropDownTRP();
        //obj.enableTNDropDownATC();
        obj.populateTotalAmountATC();
        obj.cId= claimas.id;
        obj.campPartsDetails();
        //obj.enableTNDropDownCAMPAIGN();
        //obj.enableTNDropDownTRP();
        //obj.enableTNDropDownATC();
        obj.ResetCTAData();
        obj.saveCTAData();
        obj.getreplacementReasonOptions();
        obj.getTrackNumberNew();
        //obj.listATCcompWrapper();
        
        
        list<CG_CL_ClaimsCampaignsTRPandATCComp.PartWrapper> lstcom = new list<CG_CL_ClaimsCampaignsTRPandATCComp.PartWrapper>();
        //CG_CL_ClaimsCampaignsTRPandATCComp.PartWrapper part = new CG_CL_ClaimsCampaignsTRPandATCComp.PartWrapper(claimas.id, true, 'fieldactnum', 'type', 'accountcode', 'quantity', 'servicepart', 'oem', 'partname', 'returnToFactory', 'covered','failcode', 'tNumber', 'ridValue','uprValue','tprValue','test',true);  
        
        //lstcom.add(part);
        system.assert(obj.campains==null);
        system.assert(obj.trps==null);
        system.assert(obj.atcs==null);
        
    }
    
    
    
    public static testmethod void CG_CL_ClaimsCampaignsTRPandATCCop_method1(){
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.ESN__c='58679858';
        jo.Warranty_Start_Date__c=system.today();
        insert jo;
        css_claims__c claimas = new css_claims__c();
        claimas.Customer_Name__c='Sai';
        claimas.Customer_Code__c='123';
        claimas.CSS_Job__c=jo.Id;
        insert claimas;
        css_solutions__c sol1 = new css_solutions__c();
        sol1.Service_Job__c=jo.id;
        insert sol1;
        List<CSS_Solution_Component__c> lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c sol = new CSS_Solution_Component__c();
        sol.Type__c='Campaign';
        sol.Selected_Component__c=true;
        sol.CSS_Claims__c=claimas.Id;
        sol.Status__c='Approved';
        sol.Complete_Indicator__c=true;
        sol.Multiple_Times__c=true;
        sol.Service_Job__c=jo.Id;
        sol.Solutions__c=sol1.Id;
        sol.AccountCode__c='Testing';
        insert sol;
        lstsolcomp.add(sol);
        
         CSS_Solution_Component__c sol11 = new CSS_Solution_Component__c();
        sol11.Type__c='TRP';
        sol11.Selected_Component__c=true;
        sol11.CSS_Claims__c=claimas.Id;
        sol11.Status__c='Approved';
        sol11.Complete_Indicator__c=true;
        sol11.Multiple_Times__c=true;
        sol11.Service_Job__c=jo.Id;
        sol11.Solutions__c=sol1.Id;
        sol11.AccountCode__c='Testing';
        insert sol11;
        lstsolcomp.add(sol11);
        
          CSS_Solution_Component__c sol12 = new CSS_Solution_Component__c();
        sol12.Type__c='ATC';
        sol12.Selected_Component__c=true;
        sol12.CSS_Claims__c=claimas.Id;
        sol12.Status__c='Approved';
        sol12.Complete_Indicator__c=true;
        sol12.Multiple_Times__c=true;
        sol12.Service_Job__c=jo.Id;
        sol12.Solutions__c=sol1.Id;
        sol12.AccountCode__c='Testing';
        insert sol12;
        lstsolcomp.add(sol12);
        
        
        CSS_Parts_Options__c partop = new CSS_Parts_Options__c();
        partop.CSS_Claims__c=claimas.Id;
        partop.Service_Job__c=null;
        partop.FailurepartId__c=sol.Id;
           partop.selected_part__c=true;
        insert partop;
            
         CSS_Parts_Options__c partop1 = new CSS_Parts_Options__c();
        partop1.CSS_Claims__c=claimas.Id;
        partop1.Service_Job__c=null;
        partop1.FailurepartId__c=sol11.Id;
           partop1.selected_part__c=true;
        insert partop1;
        
         CSS_Parts_Options__c partop2 = new CSS_Parts_Options__c();
        partop2.CSS_Claims__c=claimas.Id;
        partop2.Service_Job__c=null;
        partop2.FailurepartId__c=sol12.Id;
           partop2.selected_part__c=true;
        insert partop2;
        
        apexpages.currentPage().getparameters().put('id',claimas.Id);
        test.startTest();
        CG_CL_ClaimsCampaignsTRPandATCComp obj = new CG_CL_ClaimsCampaignsTRPandATCComp();
        obj.cId= claimas.id;
        obj.campPartsDetails();
        obj.ResetCTAData();
        obj.saveCTAData();
        obj.getreplacementReasonOptions();
        obj.populateTotalAmountATC();
        obj.enableTNDropDownATC();
        
        
        // obj.listATCcompWrapper();
        list<CG_CL_ClaimsCampaignsTRPandATCComp.PartWrapper> lstcom = new list<CG_CL_ClaimsCampaignsTRPandATCComp.PartWrapper>();
        //CG_CL_ClaimsCampaignsTRPandATCComp.PartWrapper part = new CG_CL_ClaimsCampaignsTRPandATCComp.PartWrapper(claimas.id, true, 'fieldactnum', 'type', 'accountcode', 'quantity', 'servicepart', 'oem', 'partname', 'returnToFactory', 'covered','failcode', 'tNumber', 'ridValue','uprVlaue','tprValue','test',true);  
        
        //lstcom.add(part);
        
    }
       public static testmethod void CG_CL_ClaimsCampaignsTRPandATCCop_method12(){
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.ESN__c='58679858';
        jo.Warranty_Start_Date__c=system.today();
        insert jo;
        css_claims__c claimas = new css_claims__c();
        claimas.Customer_Name__c='Sai';
        claimas.Customer_Code__c='123';
        claimas.CSS_Job__c=null;
        insert claimas;
        css_solutions__c sol1 = new css_solutions__c();
        sol1.Service_Job__c=jo.id;
        insert sol1;
        CSS_Solution_Component__c sol = new CSS_Solution_Component__c();
        sol.Type__c='Campaign';
        sol.Selected_Component__c=true;
        sol.CSS_Claims__c=claimas.Id;
        sol.Status__c='Approved';
        sol.Complete_Indicator__c=true;
        sol.Multiple_Times__c=true;
        sol.Service_Job__c=jo.Id;
        sol.Solutions__c=sol1.Id;
        sol.AccountCode__c='Testing';
        insert sol;
        
         CSS_Solution_Component__c sol11 = new CSS_Solution_Component__c();
        sol11.Type__c='TRP';
        sol11.Selected_Component__c=true;
        sol11.CSS_Claims__c=claimas.Id;
        sol11.Status__c='Approved';
        sol11.Complete_Indicator__c=true;
        sol11.Multiple_Times__c=true;
        sol11.Service_Job__c=jo.Id;
        sol11.Solutions__c=sol1.Id;
        sol11.AccountCode__c='Testing';
        insert sol11;
        
          CSS_Solution_Component__c sol12 = new CSS_Solution_Component__c();
        sol12.Type__c='ATC';
        sol12.Selected_Component__c=true;
        sol12.CSS_Claims__c=claimas.Id;
        sol12.Status__c='Approved';
        sol12.Complete_Indicator__c=true;
        sol12.Multiple_Times__c=true;
        sol12.Service_Job__c=jo.Id;
        sol12.Solutions__c=sol1.Id;
        sol12.AccountCode__c='Testing';
        insert sol12;
        
        CSS_Parts_Options__c partop = new CSS_Parts_Options__c();
        partop.CSS_Claims__c=claimas.Id;
        partop.Service_Job__c=null;
           partop.FailurepartId__c=sol.Id;
           partop.selected_part__c=true;
        insert partop;
            
           CSS_Parts_Options__c partop1 = new CSS_Parts_Options__c();
        partop1.CSS_Claims__c=claimas.Id;
        partop1.Service_Job__c=null;
        partop1.FailurepartId__c=sol11.Id;
           partop1.selected_part__c=true;
        insert partop1;
        
         CSS_Parts_Options__c partop2 = new CSS_Parts_Options__c();
        partop2.CSS_Claims__c=claimas.Id;
        partop2.Service_Job__c=null;
        partop2.FailurepartId__c=sol12.Id;
           partop2.selected_part__c=true;
        insert partop2;
           
        apexpages.currentPage().getparameters().put('id',claimas.Id);
        test.startTest();
        CG_CL_ClaimsCampaignsTRPandATCComp obj = new CG_CL_ClaimsCampaignsTRPandATCComp();
        obj.cId= claimas.id;
       // obj.selectedPart=1;
       // obj.enableTrackingNumber();
        obj.campPartsDetails();
        obj.ResetCTAData();
        obj.saveCTAData();
        obj.getreplacementReasonOptions();
        
        // obj.listATCcompWrapper();
        list<CG_CL_ClaimsCampaignsTRPandATCComp.PartWrapper> lstcom = new list<CG_CL_ClaimsCampaignsTRPandATCComp.PartWrapper>();
        //CG_CL_ClaimsCampaignsTRPandATCComp.PartWrapper part = new CG_CL_ClaimsCampaignsTRPandATCComp.PartWrapper(claimas.id, true, 'fieldactnum', 'type', 'accountcode', 'quantity', 'servicepart', 'oem', 'partname', 'returnToFactory', 'covered','failcode', 'tNumber', 'ridValue','uprValue','tprValue','test',true);  
        
        //lstcom.add(part);
        
    }
      public static testmethod void CG_CL_ClaimsCampaignsTRPandATCCop_method13(){
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.ESN__c='58679858';
        jo.Warranty_Start_Date__c=system.today();
        insert jo;
        css_claims__c claimas = new css_claims__c();
        claimas.Customer_Name__c='Sai';
        claimas.Customer_Code__c='123';
       // claimas.CSS_Job__c=null;
        insert claimas;
        css_solutions__c sol1 = new css_solutions__c();
        sol1.Service_Job__c=jo.id;
        insert sol1;
          List<CSS_Solution_Component__c> lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c sol = new CSS_Solution_Component__c();
        sol.Type__c='Campaign';
        sol.Selected_Component__c=true;
        sol.CSS_Claims__c=claimas.Id;
        sol.Status__c='Approved';
        sol.Complete_Indicator__c=true;
        sol.Multiple_Times__c=true;
        sol.Service_Job__c=jo.Id;
        sol.Solutions__c=sol1.Id;
        sol.AccountCode__c='Testing';
           sol.CampaignPartsPercentage__c='100';
        insert sol;
          lstsolcomp.add(sol);
        
         CSS_Solution_Component__c sol11 = new CSS_Solution_Component__c();
        sol11.Type__c='TRP';
        sol11.Selected_Component__c=true;
        sol11.CSS_Claims__c=claimas.Id;
        sol11.Status__c='Approved';
        sol11.Complete_Indicator__c=true;
        sol11.Multiple_Times__c=true;
        sol11.Service_Job__c=jo.Id;
        sol11.Solutions__c=sol1.Id;
        sol11.AccountCode__c='Testing';
           sol11.CampaignPartsPercentage__c='100';
        insert sol11;
           lstsolcomp.add(sol11);
        
          CSS_Solution_Component__c sol12 = new CSS_Solution_Component__c();
        sol12.Type__c='ATC';
        sol12.Selected_Component__c=true;
        sol12.CSS_Claims__c=claimas.Id;
        sol12.Status__c='Approved';
        sol12.Complete_Indicator__c=true;
        sol12.Multiple_Times__c=true;
        sol12.Service_Job__c=jo.Id;
        sol12.Solutions__c=sol1.Id;
        sol12.AccountCode__c='Testing';
           sol12.CampaignPartsPercentage__c='100';
        insert sol12;
           lstsolcomp.add(sol12);
        
        CSS_Parts_Options__c partop = new CSS_Parts_Options__c();
        partop.CSS_Claims__c=claimas.Id;
        partop.Service_Job__c=null;
          partop.Service_partnumber__c='1';
           partop.FailurepartId__c=sol.Id;
           partop.selected_part__c=true;
           partop.Quantity__c=2.0;
          partop.ReturnWaiver__c=true;
        insert partop;
            
           CSS_Parts_Options__c partop1 = new CSS_Parts_Options__c();
        partop1.CSS_Claims__c=claimas.Id;
        partop1.Service_Job__c=null;
           partop1.Service_partnumber__c='1';
        partop1.FailurepartId__c=sol11.Id;
           partop1.selected_part__c=true;
           partop1.Quantity__c=1.0;
          partop1.ReturnWaiver__c=true;
        insert partop1;
        
         CSS_Parts_Options__c partop2 = new CSS_Parts_Options__c();
        partop2.CSS_Claims__c=claimas.Id;
        partop2.Service_Job__c=null;
           partop2.Service_partnumber__c='1';
        partop2.FailurepartId__c=sol12.Id;
           partop2.selected_part__c=true;
           partop2.Quantity__c=2.0;
          partop2.ReturnWaiver__c=true;
        insert partop2;
           
        apexpages.currentPage().getparameters().put('id',claimas.Id);
        test.startTest();
        CG_CL_ClaimsCampaignsTRPandATCComp obj = new CG_CL_ClaimsCampaignsTRPandATCComp();
        obj.cId= claimas.id;
        //obj.selectedPart=1;
       //obj.enableTrackingNumber();
        obj.campPartsDetails();
        obj.ResetCTAData();
        obj.saveCTAData();
        obj.getreplacementReasonOptions();
          obj.getTrackNumberNew();
          obj.tnumber='1';
          obj.enableTNDropDownCAMPAIGN();
        obj.enableTNDropDownTRP();
          obj.enableTNDropDownATC();
          obj.populateTotalAmountTRP();
      
       
        system.assert(obj.campains==null);
          system.assert(obj.trps==null);
          system.assert(obj.atcs==null);
          system.assert(obj.errorMsg==null);
          
          
    }
      public static testmethod void CG_CL_ClaimsCampaignsTRPandATCCop_method14(){
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.ESN__c='58679858';
        jo.Warranty_Start_Date__c=system.today();
        insert jo;
        css_claims__c claimas = new css_claims__c();
        claimas.Customer_Name__c='Sai';
        claimas.Customer_Code__c='123';
        claimas.CSS_Job__c=null;
        insert claimas;
        css_solutions__c sol1 = new css_solutions__c();
        sol1.Service_Job__c=jo.id;
        insert sol1;
        CSS_Solution_Component__c sol = new CSS_Solution_Component__c();
        sol.Type__c='Campaign';
        sol.Selected_Component__c=true;
        sol.CSS_Claims__c=claimas.Id;
        sol.Status__c='Approved';
        sol.Complete_Indicator__c=true;
        sol.Multiple_Times__c=true;
        sol.Service_Job__c=jo.Id;
        sol.Solutions__c=sol1.Id;
        sol.AccountCode__c='Testing';
           sol.CampaignPartsPercentage__c='100';
        insert sol;
        
         CSS_Solution_Component__c sol11 = new CSS_Solution_Component__c();
        sol11.Type__c='TRP';
        sol11.Selected_Component__c=true;
        sol11.CSS_Claims__c=claimas.Id;
        sol11.Status__c='Approved';
        sol11.Complete_Indicator__c=true;
        sol11.Multiple_Times__c=true;
        sol11.Service_Job__c=jo.Id;
        sol11.Solutions__c=sol1.Id;
        sol11.AccountCode__c='Testing';
           sol11.CampaignPartsPercentage__c='100';
        insert sol11;
        
          CSS_Solution_Component__c sol12 = new CSS_Solution_Component__c();
        sol12.Type__c='ATC';
        sol12.Selected_Component__c=true;
        sol12.CSS_Claims__c=claimas.Id;
        sol12.Status__c='Approved';
        sol12.Complete_Indicator__c=true;
        sol12.Multiple_Times__c=true;
        sol12.Service_Job__c=jo.Id;
        sol12.Solutions__c=sol1.Id;
        sol12.AccountCode__c='Testing';
           sol12.CampaignPartsPercentage__c='100';
        insert sol12;
        
        CSS_Parts_Options__c partop = new CSS_Parts_Options__c();
        partop.CSS_Claims__c=claimas.Id;
        partop.Service_Job__c=null;
          partop.Service_partnumber__c='1';
           partop.FailurepartId__c=sol.Id;
           partop.selected_part__c=true;
           partop.Quantity__c=2.0;
          partop.ReturnWaiver__c=false;
          partop.Tracking_Number__c='Select One';
        insert partop;
            
           CSS_Parts_Options__c partop1 = new CSS_Parts_Options__c();
        partop1.CSS_Claims__c=claimas.Id;
        partop1.Service_Job__c=null;
           partop1.Service_partnumber__c='1';
        partop1.FailurepartId__c=sol11.Id;
           partop1.selected_part__c=true;
           partop1.Quantity__c=1.0;
          partop1.ReturnWaiver__c=false;
          partop1.Tracking_Number__c='Select One';
        insert partop1;
        
         CSS_Parts_Options__c partop2 = new CSS_Parts_Options__c();
        partop2.CSS_Claims__c=claimas.Id;
        partop2.Service_Job__c=null;
           partop2.Service_partnumber__c='1';
        partop2.FailurepartId__c=sol12.Id;
           partop2.selected_part__c=true;
           partop2.Quantity__c=2.0;
          partop2.ReturnWaiver__c=false;
          partop2.Tracking_Number__c='Select One';
        insert partop2;
           
        apexpages.currentPage().getparameters().put('id',claimas.Id);
        test.startTest();
        CG_CL_ClaimsCampaignsTRPandATCComp obj = new CG_CL_ClaimsCampaignsTRPandATCComp();
        obj.cId= claimas.id;
        //obj.selectedPart=1;
       //obj.enableTrackingNumber();
        obj.campPartsDetails();
        obj.ResetCTAData();
        obj.saveCTAData();
        obj.getreplacementReasonOptions();
          obj.getTrackNumberNew();
          obj.tnumber='1';
          obj.enableTNDropDownCAMPAIGN();
        obj.enableTNDropDownTRP();
          obj.enableTNDropDownATC();
      
       
        system.assert(obj.campains==null);
          system.assert(obj.trps==null);
          system.assert(obj.atcs==null);
          system.assert(obj.errorMsg==null);
          
          
    }
     public static testmethod void CG_CL_ClaimsCampaignsTRPandATCCop_method15(){
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.ESN__c='58679858';
        jo.Warranty_Start_Date__c=system.today();
        insert jo;
        css_claims__c claimas = new css_claims__c();
        claimas.Customer_Name__c='Sai';
        claimas.Customer_Code__c='123';
        claimas.CSS_Job__c=null;
        insert claimas;
        css_solutions__c sol1 = new css_solutions__c();
        sol1.Service_Job__c=jo.id;
        insert sol1;
        CSS_Solution_Component__c sol = new CSS_Solution_Component__c();
        sol.Type__c='Campaign';
        sol.Selected_Component__c=true;
        sol.CSS_Claims__c=claimas.Id;
        sol.Status__c='Approved';
        sol.Complete_Indicator__c=true;
        sol.Multiple_Times__c=true;
        sol.Service_Job__c=jo.Id;
        sol.Solutions__c=sol1.Id;
        sol.AccountCode__c='Testing';
           sol.CampaignPartsPercentage__c='100';
        insert sol;
        
         CSS_Solution_Component__c sol11 = new CSS_Solution_Component__c();
        sol11.Type__c='TRP';
        sol11.Selected_Component__c=true;
        sol11.CSS_Claims__c=claimas.Id;
        sol11.Status__c='Approved';
        sol11.Complete_Indicator__c=true;
        sol11.Multiple_Times__c=true;
        sol11.Service_Job__c=jo.Id;
        sol11.Solutions__c=sol1.Id;
        sol11.AccountCode__c='Testing';
           sol11.CampaignPartsPercentage__c='100';
        insert sol11;
        
          CSS_Solution_Component__c sol12 = new CSS_Solution_Component__c();
        sol12.Type__c='ATC';
        sol12.Selected_Component__c=true;
        sol12.CSS_Claims__c=claimas.Id;
        sol12.Status__c='Approved';
        sol12.Complete_Indicator__c=true;
        sol12.Multiple_Times__c=true;
        sol12.Service_Job__c=jo.Id;
        sol12.Solutions__c=sol1.Id;
        sol12.AccountCode__c='Testing';
           sol12.CampaignPartsPercentage__c='100';
        insert sol12;
        
        CSS_Parts_Options__c partop = new CSS_Parts_Options__c();
        partop.CSS_Claims__c=claimas.Id;
        partop.Service_Job__c=null;
          partop.Service_partnumber__c='1';
           partop.FailurepartId__c=sol.Id;
           partop.selected_part__c=true;
           partop.Quantity__c=2.0;
          partop.ReturnWaiver__c=true;
          partop.Tracking_Number__c='Select One';
          
        insert partop;
            
           CSS_Parts_Options__c partop1 = new CSS_Parts_Options__c();
        partop1.CSS_Claims__c=claimas.Id;
        partop1.Service_Job__c=null;
           partop1.Service_partnumber__c='1';
        partop1.FailurepartId__c=sol11.Id;
           partop1.selected_part__c=true;
           partop1.Quantity__c=1.0;
          partop1.ReturnWaiver__c=true;
          partop1.Tracking_Number__c='Select One';
          
        insert partop1;
        
         CSS_Parts_Options__c partop2 = new CSS_Parts_Options__c();
        partop2.CSS_Claims__c=claimas.Id;
        partop2.Service_Job__c=null;
           partop2.Service_partnumber__c='1';
        partop2.FailurepartId__c=sol12.Id;
           partop2.selected_part__c=true;
           partop2.Quantity__c=2.0;
          partop2.ReturnWaiver__c=true;
          partop2.Tracking_Number__c='Select One';
          
        insert partop2;
           
        apexpages.currentPage().getparameters().put('id',claimas.Id);
        test.startTest();
        CG_CL_ClaimsCampaignsTRPandATCComp obj = new CG_CL_ClaimsCampaignsTRPandATCComp();
        obj.cId= claimas.id;
        //obj.selectedPart=1;
       //obj.enableTrackingNumber();
        obj.campPartsDetails();
        obj.ResetCTAData();
        obj.saveCTAData();
        obj.getreplacementReasonOptions();
          obj.getTrackNumberNew();
          obj.tnumber='1';
         obj.enableTNDropDownCAMPAIGN();
        obj.enableTNDropDownTRP();
          obj.enableTNDropDownATC();
      
       
        system.assert(obj.campains==null);
          system.assert(obj.trps==null);
          system.assert(obj.atcs==null);
        //  system.assert(obj.errorMsg==null);
          
          
    }
    
      public static testmethod void CG_CL_ClaimsCampaignsTRPandATCCop_method16(){
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.ESN__c='58679858';
        jo.Warranty_Start_Date__c=system.today();
        insert jo;
        css_claims__c claimas = new css_claims__c();
        claimas.Customer_Name__c='Sai';
        claimas.Customer_Code__c='123';
        claimas.CSS_Job__c=null;
        insert claimas;
        css_solutions__c sol1 = new css_solutions__c();
        sol1.Service_Job__c=jo.id;
        insert sol1;
        CSS_Solution_Component__c sol = new CSS_Solution_Component__c();
        sol.Type__c='Campaign';
        sol.Selected_Component__c=true;
        sol.CSS_Claims__c=claimas.Id;
        sol.Status__c='Approved';
        sol.Complete_Indicator__c=true;
        sol.Multiple_Times__c=true;
        sol.Service_Job__c=jo.Id;
        sol.Solutions__c=sol1.Id;
        sol.AccountCode__c='Testing';
           sol.CampaignPartsPercentage__c='100';
        insert sol;
        
         CSS_Solution_Component__c sol11 = new CSS_Solution_Component__c();
        sol11.Type__c='TRP';
        sol11.Selected_Component__c=true;
        sol11.CSS_Claims__c=claimas.Id;
        sol11.Status__c='Approved';
        sol11.Complete_Indicator__c=true;
        sol11.Multiple_Times__c=true;
        sol11.Service_Job__c=jo.Id;
        sol11.Solutions__c=sol1.Id;
        sol11.AccountCode__c='Testing';
           sol11.CampaignPartsPercentage__c='100';
        insert sol11;
        
          CSS_Solution_Component__c sol12 = new CSS_Solution_Component__c();
        sol12.Type__c='ATC';
        sol12.Selected_Component__c=true;
        sol12.CSS_Claims__c=claimas.Id;
        sol12.Status__c='Approved';
        sol12.Complete_Indicator__c=true;
        sol12.Multiple_Times__c=true;
        sol12.Service_Job__c=jo.Id;
        sol12.Solutions__c=sol1.Id;
        sol12.AccountCode__c='Testing';
           sol12.CampaignPartsPercentage__c='100';
        insert sol12;
        
        CSS_Parts_Options__c partop = new CSS_Parts_Options__c();
        partop.CSS_Claims__c=claimas.Id;
        partop.Service_Job__c=null;
          partop.Service_partnumber__c='1';
           partop.FailurepartId__c=sol.Id;
           partop.selected_part__c=true;
           partop.Quantity__c=2.0;
          partop.ReturnWaiver__c=false;
          partop.Tracking_Number__c='Select One';
        insert partop;
            
           CSS_Parts_Options__c partop1 = new CSS_Parts_Options__c();
        partop1.CSS_Claims__c=claimas.Id;
        partop1.Service_Job__c=null;
           partop1.Service_partnumber__c='1';
        partop1.FailurepartId__c=sol11.Id;
           partop1.selected_part__c=true;
           partop1.Quantity__c=1.0;
          partop1.ReturnWaiver__c=false;
          partop1.Tracking_Number__c='Select One';
        insert partop1;
        
         CSS_Parts_Options__c partop2 = new CSS_Parts_Options__c();
        partop2.CSS_Claims__c=claimas.Id;
        partop2.Service_Job__c=null;
           partop2.Service_partnumber__c='1';
        partop2.FailurepartId__c=sol12.Id;
           partop2.selected_part__c=true;
           partop2.Quantity__c=2.0;
          partop2.ReturnWaiver__c=false;
          partop2.Tracking_Number__c='Select One';
         
        insert partop2;
           
        apexpages.currentPage().getparameters().put('id',claimas.Id);
        test.startTest();
        CG_CL_ClaimsCampaignsTRPandATCComp obj = new CG_CL_ClaimsCampaignsTRPandATCComp();
        obj.cId= claimas.id;
        //obj.selectedPart=1;
       //obj.enableTrackingNumber();
        obj.campPartsDetails();
        obj.ResetCTAData();
        obj.saveCTAData();
        obj.getreplacementReasonOptions();
          obj.getTrackNumberNew();
          obj.tnumber= '1';
          obj.enableTNDropDownCAMPAIGN();
        obj.enableTNDropDownTRP();
          obj.enableTNDropDownATC();
      
       
        system.assert(obj.campains==null);
          system.assert(obj.trps==null);
          system.assert(obj.atcs==null);
        //  system.assert(obj.errorMsg==null);
          
          
    }
}