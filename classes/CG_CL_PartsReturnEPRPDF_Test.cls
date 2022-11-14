@istest
public class CG_CL_PartsReturnEPRPDF_Test 
{
  static testmethod void TM1()
    {
        String grpName = 'CQ'+'-'+'03456-1234';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        Test.startTest();
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            
            system.debug('Hello World');
            //Simply create the object and check coverage first
            //CG_CL_PartsReturnEPRPDF obj=new CG_CL_PartsReturnEPRPDF();
            list<CSS_Claims__c> clmlist=new list<CSS_Claims__c>();
            CSS_Claims__c clm=new CSS_Claims__c();
            clm.Location_Code__c='03456-1234';
            //clm.OwnerId=userinfo.getUserId();
            insert clm;
            clmlist.add(clm);
            upsert clmlist;
            
            //Insert PO
            list<CSS_Parts_Options__c> polist=new list<CSS_Parts_Options__c>();
            CSS_Parts_Options__c po=new CSS_Parts_Options__c();
            po.ReturnToFactory__c = 'Y'; 
            po.ReturnWaiver__c = false; 
            po.CSS_Claims__c =clm.id;
            insert po;
            CSS_Parts_Options__c po1 = new CSS_Parts_Options__c();
            po1.ReturnToFactory__c = 'Y'; 
            po1.ReturnWaiver__c = false; 
            po1.CSS_Claims__c =clm.id;
            insert po1;
            polist.add(po);
            polist.add(po1);
            upsert polist;
            
            //Insert PSN
            list<CSS_PSN__c> psnlist=new list<CSS_PSN__c>();
            
            CSS_PSN__c psn1=new CSS_PSN__c();
            psn1.Primary__c=true;
            psn1.Product_Hours__c=2;
            psn1.CSS_Claims__c=clm.id;
            insert psn1;
            
            CSS_PSN__c psn2=new CSS_PSN__c();
            psn2.Primary__c=true;
            psn2.Product_Hours__c=2;
            psn2.CSS_Claims__c=clm.id;
            insert psn2;
            
            psnlist.add(psn1);
            psnlist.add(psn2);
            upsert psnlist;
            
            //Insert Claim Submission
            CSS_Claim_Submission__c csb=new CSS_Claim_Submission__c();
            csb.CSS_Claims__c=clm.id;
            insert csb;
     
            
            PageReference pref;
            pref = new PageReference('/'+clm.id);
            pref.getParameters().put('id',clm.id);
            Test.setCurrentPage(pref); 
            Test.stopTest();
        }
        
    }
    static testmethod void TM2()
    {
        String grpName = 'CQ'+'-'+'03456-1234';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            Test.startTest();
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            
           system.debug('Hello World');
            //Simply create the object and check coverage first
            //CG_CL_PartsReturnEPRPDF obj=new CG_CL_PartsReturnEPRPDF();
            list<CSS_Claims__c> clmlist=new list<CSS_Claims__c>();
            CSS_Claims__c clm=new CSS_Claims__c();
            clm.Location_Code__c='03456-1234';
            //clm.OwnerId=userinfo.getUserId();
            insert clm;
            clmlist.add(clm);
            upsert clmlist;
            
            //Insert PO
            list<CSS_Parts_Options__c> polist=new list<CSS_Parts_Options__c>();
            CSS_Parts_Options__c po=new CSS_Parts_Options__c();
            po.ReturnToFactory__c = 'Y'; 
            po.ReturnWaiver__c = false; 
            po.CSS_Claims__c =clm.id;
            po.selected_part__c=true;
            insert po;
            polist.add(po);
            upsert polist;
            
            //Insert PSN
            list<CSS_PSN__c> psnlist=new list<CSS_PSN__c>();
            
            CSS_PSN__c psn1=new CSS_PSN__c();
            psn1.Primary__c=true;
            psn1.Mileage_Measure__c='Miles';
            psn1.CSS_Claims__c=clm.id;
            psn1.Mileage__c = 2.0;
            psn1.Product_Hours__c = 2.0;
            insert psn1;
            
            CSS_PSN__c psn2=new CSS_PSN__c();
            psn2.Primary__c=true;
            psn2.Mileage_Measure__c = 'Miles';
            psn2.Mileage__c = 2.0;
            psn2.Product_Hours__c = 2.0;
            psn2.CSS_Claims__c=clm.id;
            insert psn2;
            
            CSS_PSN__c psn3=new CSS_PSN__c();
            psn3.Primary__c=true;
            psn3.Mileage_Measure__c = 'Kilometers';
            psn3.Mileage__c = 2.0;
            psn3.Product_Hours__c = 2.0;
            psn3.CSS_Claims__c=clm.id;
            insert psn3;
            
            psnlist.add(psn1);
            psnlist.add(psn2);
            psnlist.add(psn3);
            upsert psnlist;
            
            //Insert Claim Submission
            CSS_Claim_Submission__c csb=new CSS_Claim_Submission__c();
            csb.CSS_Claims__c=clm.id;
     
            
            PageReference pref;
            pref = new PageReference('/'+clm.id);
            pref.getParameters().put('id',clm.id);
            Test.setCurrentPage(pref); 
            
            
            CG_CL_PartsReturnEPRPDF obj2=new CG_CL_PartsReturnEPRPDF();
            obj2.spCode='test';
            obj2.distiCode='test';
            obj2.claimCreateDate='';
            Test.stopTest();
        }
                 
    }
    static testmethod void TM3()
    {
        String grpName = 'CQ'+'-'+'03456-1234';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            Test.startTest();
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            
            system.debug('Hello World');
            //Simply create the object and check coverage first
            //CG_CL_PartsReturnEPRPDF obj=new CG_CL_PartsReturnEPRPDF();
            list<CSS_Claims__c> clmlist=new list<CSS_Claims__c>();
            CSS_Claims__c clm=new CSS_Claims__c();
            //clm.OwnerId=userinfo.getUserId();
            clm.Location_Code__c='03456-1234';
            insert clm;
            clmlist.add(clm);
            upsert clmlist;
            
            //Insert PO
            list<CSS_Parts_Options__c> polist=new list<CSS_Parts_Options__c>();
            CSS_Parts_Options__c po=new CSS_Parts_Options__c();
            po.ReturnToFactory__c = 'Y'; 
            po.ReturnWaiver__c = false; 
            po.CSS_Claims__c =clm.id;
            po.selected_part__c=true;
            insert po;
            polist.add(po);
            upsert polist;
            
            //Insert PSN
            list<CSS_PSN__c> psnlist=new list<CSS_PSN__c>();
            
            CSS_PSN__c psn1=new CSS_PSN__c();
            psn1.Primary__c=true;
            psn1.Mileage_Measure__c='Kilometers';
            psn1.CSS_Claims__c=clm.id;
            insert psn1;
            
            CSS_PSN__c psn2=new CSS_PSN__c();
            psn2.Primary__c=true;
            psn2.Mileage_Measure__c = 'Kilometers';
            psn2.CSS_Claims__c=clm.id;
            insert psn2;
            
            psnlist.add(psn1);
            psnlist.add(psn2);
            upsert psnlist;
            
            //Insert Claim Submission
            CSS_Claim_Submission__c csb=new CSS_Claim_Submission__c();
            csb.CSS_Claims__c=clm.id;
     
            
            PageReference pref;
            pref = new PageReference('/'+clm.id);
            pref.getParameters().put('id',clm.id);
            Test.setCurrentPage(pref); 
            
            
            CG_CL_PartsReturnEPRPDF obj3=new CG_CL_PartsReturnEPRPDF();
            Test.stopTest();
        }
                 
    }
}