@IsTest
public class CSS_MarqueeTextController_Test {

    public static testMethod void marqueeMeth(){
      Test.startTest();
         CSS_For_Marquee__c mq = new CSS_For_Marquee__c();
         
               mq.Marquee_Text__c='Test';
               mq.Marquee_Text1__c='Test1';
               mq.Marquee_Text2__c='Test2';
               mq.Marquee_Text3__c='Test3';
              
           insert mq;   
           CSS_MarqueeTextController mqCont = new CSS_MarqueeTextController();
           mqCont.Submit();
           Test.stopTest();
   }
    
}