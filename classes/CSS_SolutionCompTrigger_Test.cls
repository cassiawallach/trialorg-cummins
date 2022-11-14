@isTest
public class CSS_SolutionCompTrigger_Test {
    public static testMethod void testSolutions() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, 
                               TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        boolean callSrt = true; 
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        CSS_Fault_Code__c fc;
        CSS_Solution_Component__c solComp;
        CSS_Solution_Component__c solComponent;
        CSS_Solution_Component__c sComp = new CSS_Solution_Component__c();
        List<string> solCompAdd = new List<string>();
        List<string> solCompA = new List<string>();
        System.runAs(newUser) {
            job1 = new CSS_Job_Order__c(ownerId = newUser.id,Customer_Name__c='varun',service_model__c='Test',Equipment_ID__c='EQ7667',Qsol_Engine_Family_Code__c='10',Claim_no__c=1234);
            insert job1;
            fc = new CSS_Fault_Code__c(name='441',Job_Order__c=job1.id);
            insert fc;
            solutions = new CSS_Solutions__c(ownerID = newUser.id,Name='K21484443',Service_Job__c=job1.Id,Solution_Title__c='Test',Case_Name__c='K21484443',FaultCode__c=fc.id);
            insert solutions;
            solComp = new CSS_Solution_Component__c(name='F00100550',Component_Id__c='F00100550',Service_Job__c=job1.id,Solutions__c=solutions.id,Action__c='Replaced',SRT_Fetched__c = false,Selected_Component__c=true);
            insert solComp;
            solCompAdd.add(JSON.Serialize(new solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Name)));
            solComponent = new CSS_Solution_Component__c(name='F00100550',Component_Id__c='F00100550',Service_Job__c=job1.id,Solutions__c=solutions.id);
            insert solComponent;
            sComp = [select Name from CSS_Solution_Component__c where id =:solComponent.id];
            sComp.Action__c = 'Replaced';
            scomp.Selected_Component__c = true;
            scomp.SRT_Fetched__c = false;
            update sComp;
             //solCompA.add(JSON.Serialize(new solCompWrapper(sComp.Solutions__c,sComp.Service_Job__c,sComp.Service_Model__c,sComp.Equip_ID__c,sComp.id,sComp.Engine_Family_Code__c,sComp.Name,sComp.Component_Id__c,sComp.Name)));
      solCompA.add(JSON.Serialize(new solCompWrapper(sComp.Solutions__c,sComp.Service_Job__c,sComp.Service_Model__c,sComp.Equip_ID__c,sComp.id,sComp.Engine_Family_Code__c,sComp.Name))); 
            CSS_Solution_Component__c solucomp = new CSS_Solution_Component__c();
            solucomp.Service_Job__c = job1.id;
            solucomp.Solutions__c = solutions.id;
            solucomp.Selected_Component__c = true;
            solucomp.SRT_Fetched__c = false;
            insert solucomp;
        
        }       
    }
   
    public class solCompWrapper{
        public id solID{get;set;}
        public id jobID{get;set;}
        public string serviceModel{get;set;}
        public string equipID{get;set;}
        public id compID{get;set;}
        public string efc{get;set;}
        public string compoName{get;set;}
        public solCompWrapper(id solID,id jobID,string serviceModel,string equipID,id compID,string efc,string compoName){
            this.solID = solID;
            this.jobID = jobID;
            this.serviceModel = serviceModel;
            this.equipID = equipID;
            this.compID = compID;
            this.efc = efc;            
            this.compoName = compoName;
        }
    }
}