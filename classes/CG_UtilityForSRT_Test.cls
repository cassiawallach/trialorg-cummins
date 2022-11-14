@IsTest
public class CG_UtilityForSRT_Test{
    
    static testmethod void getAccessCodesJobMethod(){
        Test.startTest();
        CG_UtilityForSRT obj = new CG_UtilityForSRT();
        List<String> getAccessCodesJob =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'A', 'A/B/C/D', 'Additional');
        List<String> getAccessCodesJob1 =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'B', 'A/B/C/D', 'Additional');
        List<String> getAccessCodesJob2 =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'C', 'A/B/C/D', 'Additional');
        List<String> getAccessCodesJob3 =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'D', 'A/B/C/D', 'Additional');
        List<String> getAccessCodesJob4 =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'A', 'A', 'RepairOrFA');
        List<String> getAccessCodesJob5 =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'B', 'B', 'RepairOrFA');
        List<String> getAccessCodesJob6 =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'C', 'C', 'RepairOrFA');
        List<String> getAccessCodesJob7 =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'D', 'D', 'RepairOrFA');
        List<String> getAccessCodesJob8 =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'A', 'R', 'RepairOrFA');
        List<String> getAccessCodesJob9 =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'B', 'R', 'RepairOrFA');
        List<String> getAccessCodesJob10 =obj.getAccessCodesJob('10', '10', '10', '10', '10','C', 'R', 'RepairOrFA');
        List<String> getAccessCodesJob11 =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'D', 'R', 'RepairOrFA');
        List<String> getAccessCodesJob12 =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'B', 'R', 'RepairOrFA');
        List<String> getAccessCodesJob13 =obj.getAccessCodesJob('10', '10', '10', '10', '10','C', 'R', 'RepairOrFA');
        List<String> getAccessCodesJob14 =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'D', 'R', 'RepairOrFA');
        
        Test.stopTest();
    }
    static testmethod void getAccessCodesClaimMethod(){
        Test.startTest();
        CG_UtilityForSRT srt=new CG_UtilityForSRT();  
        List<String> str1=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'A', 'A/B/C/D', 'Additional',true);
        List<String> str2=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'B', 'A/B/C/D', 'Additional',true);
        List<String> str3=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'C', 'A/B/C/D', 'Additional',true);
        List<String> str4=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'D', 'A/B/C/D', 'Additional',true);
        List<String> str5=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'A', 'A', 'RepairOrFA',true);
        List<String> str6=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'B', 'B', 'RepairOrFA',true);
        List<String> str7=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'C', 'C', 'RepairOrFA',true);
        List<String> str8=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'D', 'D', 'RepairOrFA',true);
        List<String> str9=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'A', 'R', 'RepairOrFA',true);
        List<String> str10=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'B', 'R', 'RepairOrFA',true);
        List<String> str11=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'C', 'R', 'RepairOrFA',true);
        List<String> str112=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'D', 'R', 'RepairOrFA',true);
        Test.stopTest();
    }
    static testmethod void getAccesscodejoboptionMethod(){
        Test.startTest();
        CG_UtilityForSRT obj = new CG_UtilityForSRT();
        List<String> getAccessCodesJob =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'A', 'A/B/C/D', 'Additional');
        List<String> getAccessCodesJob1 =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'B', 'A/B/C/D', 'Additional');
        List<String> getAccessCodesJob2 =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'C', 'A/B/C/D', 'Additional');
        List<String> getAccessCodesJob3 =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'D', 'A/B/C/D', 'Additional');
        List<String> getAccessCodesJob4 =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'C', 'A/B/C/D', 'Additional');
        List<String> getAccessCodesJob5 =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'D', 'A/B/C/D', 'Additional');
        List<String> getAccessCodesJob6 =obj.getAccessCodesJob('10', '10', '10', '10', '10', 'C', 'A/B/C/D', 'Additional');
        Test.stopTest();
    }
    static testmethod void getAccesscodeclaimoptionMethod(){
        Test.startTest();
        CG_UtilityForSRT srt = new CG_UtilityForSRT();
        List<String> str1=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'A', 'A/B/C/D', 'Additional',true);
        List<String> str2=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'B', 'A/B/C/D', 'Additional',true);
        List<String> str3=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'C', 'A/B/C/D', 'Additional',true);
        List<String> str4=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'D', 'A/B/C/D', 'Additional',true);
        List<String> str5=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'A', 'A', 'RepairOrFA',true);
        List<String> str6=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'A', 'A/B/C/D', 'Additional',true);
        List<String> str7=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'B', 'A/B/C/D', 'Additional',true);
        List<String> str8=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'C', 'A/B/C/D', 'Additional',true);
        List<String> str9=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'D', 'A/B/C/D', 'Additional',true);
        List<String> str10=srt.getAccessCodesClaim('10', '10', '10', '10', '10', 'A', 'A', 'RepairOrFA',true);
        list<selectoption> so2 =srt.getAccesscodeclaimoption('10', '10', '10', '10', '10', 'B', 'A/B/C/D/R', 'Additional',true);
        Test.stopTest();
    }
    static testmethod void getAccesscodejoboption(){
        Test.startTest();
        CG_UtilityForSRT srt = new CG_UtilityForSRT();
        List<selectoption> str1=srt.getAccesscodejoboption('10', '10', '10', '10', '10', 'A', 'A/B/C/D', 'Additional');
        List<selectoption> str2=srt.getAccesscodejoboption('10', '10', '10', '10', '10', 'B', 'A/B/C/D', 'Additional');
        List<selectoption> str3=srt.getAccesscodejoboption('10', '10', '10', '10', '10', 'C', 'A/B/C/D', 'Additional');
        List<selectoption> str4=srt.getAccesscodejoboption('10', '10', '10', '10', '10', 'D', 'A/B/C/D', 'Additional');
        List<selectoption> str5=srt.getAccesscodejoboption('10', '10', '10', '10', '10', 'A', 'A', 'RepairOrFA');
        List<selectoption> str6=srt.getAccesscodejoboption('10', '10', '10', '10', '10', 'A', 'A/B/C/D', 'Additional');
        List<selectoption> str7=srt.getAccesscodejoboption('10', '10', '10', '10', '10', 'B', 'A/B/C/D', 'Additional');
        List<selectoption> str8=srt.getAccesscodejoboption('10', '10', '10', '10', '10', 'C', 'A/B/C/D', 'Additional');
        List<selectoption> str9=srt.getAccesscodejoboption('10', '10', '10', '10', '10', 'D', 'A/B/C/D', 'Additional');
        List<selectoption> str10=srt.getAccesscodejoboption('10', '10', '10', '10', '10', 'A', 'A', 'RepairOrFA');
        list<selectoption> so2 =srt.getAccesscodejoboption('10', '10', '10', '10', '10', 'B', 'A/B/C/D/R', 'Additional');
        Test.stopTest();
    }
    static testmethod void buildDuplicateAccessCodesLogicMethod(){
        
        //CG_UtilityForSRT obj = new CG_UtilityForSRT();
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='562701';
        acc.IAM_Service_Provider_Code__c='562551';
        acc.type = 'Customer';
        insert acc;
        
        css_job_order__c jo =new css_job_order__c();
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.ESN__c='58764-58764';
        jo.Account__c=acc.id;
        jo.Repair_Location__c='Mobile';
        jo.Territory_Class_Name__c=null;
        insert jo;
        //css_solutions__c sol=css_testdata.createSolutions(true, jo.Id);
        
        CSS_Claims__c claims = new CSS_Claims__c();
        Claims.Customer_Name__c='TestUser';
        Claims.Customer_Code__c='123';
        claims.Shop_Work_Order__c='123';
        
        claims.Account__c=acc.id;
        //claims.Account__r.Type='Dealer Account';
        insert claims;
        list<CSS_PSN__c> psnlst = new list<CSS_PSN__c>();
        CSS_PSN__c psn = new CSS_PSN__c();
        psn.Name='73806085';
        psn.Unit_Number__c='123';
        psn.Application__c='AUTOMOTIVE';
        psn.Service_Model__c='ISB6.7 CM2350 B101';
        psn.Make__c='INTERNATIONAL';
        psn.Model__c='DURASTAR';
        psn.Mileage_Measure__c='Miles';
        psn.Unit_Type__c='CONVENTIONAL';
        psn.PSN__c='73806085';
        psn.ApplicationCode__c ='130';
        psn.CSS_Claims__c=claims.id;
        psn.Primary__c=true;
        PSN.Before_In_Service__c=FALSE;
        insert psn;   
        psnlst.add(psn);
        List <CSS_SRT__c> strlst = new List<CSS_SRT__c>();
        CSS_SRT__c srtObj=new CSS_SRT__c();
        srtObj.SRT_AccessiblityCheck__c=True;
        srtObj.name = 'Test'+Math.random();
        srtObj.Type__c = '99Time';
        srtObj.isPerformed__c =True;
        srtObj.SRT_Type__c='99-999';
        srtObj.Step_Id__c='99-999';
        srtObj.SRT_Warrantable__c='abcd';
        srtObj.Account_Code_Description__c = 'SERVICE TOOL WARRANTY 52';
        srtObj.SRT_ID__c='99-902-00';
        srtObj.FailCode__c='WEQP';
        insert srtObj;
        // system.debug('srtObjtest'+srtObj);
        strlst.add(srtObj);
        CSS_SRT__c srtObj1=new CSS_SRT__c();
        srtObj1.SRT_AccessiblityCheck__c=True;
        srtObj1.name = 'Test'+Math.random();
        srtObj1.Type__c = '99Time';
        srtObj1.isPerformed__c =True;
        srtObj1.SRT_Type__c='99-999';
        srtObj1.Step_Id__c='99-999';
        srtObj1.SRT_Warrantable__c='abcd';
        srtObj1.Account_Code__c=null;
        srtObj1.Account_Code_Description__c = 'SERVICE TOOL WARRANTY 97';
        srtObj1.SRT_ID__c='99-902-00';
        srtObj1.FailCode__c='WEQP';
        insert srtObj1;
        strlst.add(srtObj1);
        CSS_SRT__c srtObj11=new CSS_SRT__c();
        srtObj11.SRT_AccessiblityCheck__c=True;
        srtObj11.name = 'Test'+Math.random();
        srtObj11.Type__c = '99Time';
        srtObj11.isPerformed__c =True;
        srtObj11.SRT_Type__c='99-999';
        srtObj11.Step_Id__c='99-999';
        srtObj11.SRT_Warrantable__c='abcd';
        srtObj11.Account_Code_Description__c = 'SERVICE TOOL WARRANTY 97';
        srtObj11.SRT_ID__c='99-902-00';
        srtObj11.FailCode__c='WEQP';
        insert srtObj11;
        // system.debug('srtObjtest'+srtObj);
        strlst.add(srtObj11);
        CSS_SRT__c srtObj12=new CSS_SRT__c();
        srtObj12.SRT_AccessiblityCheck__c=True;
        srtObj12.name = 'Test'+Math.random();
        srtObj12.Type__c = '99Time';
        srtObj12.isPerformed__c =True;
        srtObj12.SRT_Type__c='99-999';
        srtObj12.Step_Id__c='99-999';
        srtObj12.SRT_Warrantable__c='abcd';
        srtObj12.Account_Code__c=null;
        srtObj12.Account_Code_Description__c = 'SERVICE TOOL WARRANTY 62';
        srtObj12.SRT_ID__c='99-902-00';
        srtObj12.FailCode__c='WEQP';
        insert srtObj12;
        strlst.add(srtObj1);
        CSS_SRT__c srtObj2=new CSS_SRT__c();
        srtObj2.SRT_AccessiblityCheck__c=True;
        srtObj2.name = 'Test'+Math.random();
        srtObj2.Type__c = '99Time';
        //srtObj2.Job_Order__c=jo.id;
        srtObj2.isPerformed__c =True;
        srtObj2.SRT_Type__c='99-999';
        srtObj2.SRT_Warrantable__c='abcd';
        srtObj2.Step_Id__c='99-999';
        //srtObj2.Account_Code__c=null;
        srtObj2.Account_Code_Description__c = 'SERVICE TOOL WARRANTY 62';
        srtObj2.SRT_ID__c='99-902-00';
        srtObj2.FailCode__c='WEQP';
        insert srtObj2;
        strlst.add(srtObj2);
        CSS_SRT__c srtObj3=new CSS_SRT__c();
        srtObj3.SRT_AccessiblityCheck__c=True;
        srtObj3.name = 'Test'+Math.random();
        srtObj3.Type__c = '99Time';
        srtObj3.isPerformed__c =True;
        srtObj3.SRT_Type__c='99-999';
        srtObj3.SRT_Warrantable__c='abcd';
        srtObj3.Step_Id__c='99-999';
        // srtObj3.Account_Code__c='SERVICE TEST WARRANTY 11';
        srtObj3.Account_Code_Description__c = 'SERVICE TOOL WARRANTY 11';
        srtObj3.SRT_ID__c='99-902-00';
        srtObj3.FailCode__c='WEQP';
        insert srtObj3;
        // system.debug('srtObjtest'+srtObj);
        strlst.add(srtObj3);
        CSS_SRT__c srtObj31=new CSS_SRT__c();
        srtObj31.SRT_AccessiblityCheck__c=True;
        srtObj31.name = 'Test'+Math.random();
        srtObj31.Type__c = 'Admin';
        srtObj31.isPerformed__c =True;
        srtObj31.SRT_Type__c='Admin';
        srtObj31.Step_Id__c='99-999';
        srtObj31.Access_Code__c='1';
        srtobj31.Job_Order__c=jo.id;
        srtObj31.SRT_Warrantable__c='abcd';
        // srtObj31.Account_Code__c='SERVICE TOOL WARRANTY 11';
        srtObj31.Account_Code_Description__c = 'SERVICE TOOL WARRANTY 11';
        srtObj31.SRT_ID__c='99-902-00';
        srtObj31.FailCode__c='WEQP';
        insert srtObj31;
        apexpages.currentPage().getparameters().put('id',claims.id); 
        apexpages.currentPage().getparameters().put('id',jo.id); 
        // system.debug('srtObjtest'+srtObj);
        strlst.add(srtObj31);
        List<CSS_SRT__C> finalList = [select id,Step_Id__c,SRT_Warrantable__c,SRT_Type__c,SRT_ID__c,FailCode__c,Access_Code_Saved__c,Type__c,Account_Code__c,isPerformed__c,AccountCode_Formula__c from CSS_SRT__c where id in (:srtObj11.id,:srtObj12.id,:srtObj3.id,:srtObj31.id,:srtObj2.id,:srtObj1.id,:srtObj.Id)];
        strlst[0] = [select id,Step_Id__c,SRT_Type__c,SRT_ID__c,FailCode__c,Access_Code_Saved__c,Type__c,Account_Code__c,isPerformed__c,AccountCode_Formula__c from CSS_SRT__c where id=:strlst[0].id];
        system.debug('strlsttest'+strlst);
        //update strlst;
        Test.startTest();
        Map<String,List<CSS_SRT__c>> duplicatePWSRTsMap1 = new Map<String,List<CSS_SRT__c>>();
        duplicatePWSRTsMap1.put('WEQP-SERVICE TOOL WARRANTY 52-99-999',strlst);
        //CG_UtilityForSRT.wid= jo.id;
        CG_UtilityForSRT.buildDuplicateAccessCodesLogic(finalList,true,true);
        CG_UtilityForSRT.executeAdminSRT902LogicForJob(jo.id,jo);
        CG_UtilityForSRT.executeAdminSRT902LogicForClaims(claims.id,claims);
        CG_UtilityForSRT.checkCalibFieldsForClaim(psnlst);
        Test.stopTest();
    } 
    static testmethod void method2(){
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='562701';
        acc.IAM_Service_Provider_Code__c='562551';
        acc.Type = 'Customer';
        insert acc;
        
        css_job_order__c jo =new css_job_order__c();
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.ESN__c='58764-58764';
        jo.Account__c=acc.id;
        jo.Repair_Location__c='Mobile';
        jo.Territory_Class_Name__c=null;
        insert jo;
        
        CSS_Claims__c claims = new CSS_Claims__c();
        Claims.Customer_Name__c='TestUser';
        Claims.Customer_Code__c='123';
        claims.Shop_Work_Order__c='123';
        claims.Repair_Location__c='Mobile';
        claims.Account__c=acc.id;
        insert claims;
        
        list<CSS_PSN__c> psnlst = new list<CSS_PSN__c>();
        CSS_PSN__c psn = new CSS_PSN__c();
        psn.Name='73806085';
        psn.Unit_Number__c='123';
        psn.Application__c='AUTOMOTIVE';
        psn.Service_Model__c='ISB6.7 CM2350 B101';
        psn.Make__c='INTERNATIONAL';
        psn.Model__c='DURASTAR';
        psn.Mileage_Measure__c='Miles';
        psn.Unit_Type__c='CONVENTIONAL';
        psn.PSN__c='73806085';
        psn.ApplicationCode__c ='130';
        psn.CSS_Claims__c=claims.id;
        psn.Primary__c=true;
        PSN.Revision_Before__c=null;
        insert psn;   
        psnlst.add(psn);
        list<CSS_SRT__c> srtlst = new list<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Account_Code__c='Emisiion warranty 70';
        srt.Type__c ='ADMIN';
        srt.SRT_Type__c='admin';
        srt.srt_id__c='00-902-00';
        srt.SRT_Warrantable__c='test';
        srt.CSS_Claims__c= claims.id;
        insert srt;
        srtlst.add(srt);
        
        test.startTest();
        list<CSS_SRT__c> srtlst1 = new list<CSS_SRT__c>();
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Account_Code__c='Emisiion warranty 70';
        srt1.Type__c ='ADMIN';
        srt1.SRT_Type__c='admin';
        srt1.srt_id__c='00-902-00';
        srt1.SRT_Warrantable__c='test';
        srt1.Access_Code__c='1';
        srt1.Job_Order__c= jo.id;
        insert srt1;
        srtlst1.add(srt1);
        apexpages.currentPage().getparameters().put('id',claims.id); 
        apexpages.currentPage().getparameters().put('id',jo.id); 
        CG_UtilityForSRT.executeAdminSRT902LogicForClaims(claims.id,claims);
        CG_UtilityForSRT.executeAdminSRT902LogicForJob(jo.id,jo);
        CG_UtilityForSRT.updateCalibFieldsError(claims.id);
        test.stopTest();
        
        
        
    }
    
}