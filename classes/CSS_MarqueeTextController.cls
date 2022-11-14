public class CSS_MarqueeTextController{

public string MarqText {get;set;}
public string MarqText1 {get;set;}
public string MarqText2 {get;set;}
public string MarqText3 {get;set;}

public CSS_For_Marquee__c  Marquee {get;set;}

//public CSS_MarqueeTextController(ApexPages.StandardController controller){
//}
      //Constructor
    public CSS_MarqueeTextController(){
        Marquee = new CSS_For_Marquee__c ();
        Marquee = [Select Id,Name,Marquee_Text__c,Marquee_Text1__c,Marquee_Text2__c,Marquee_Text3__c from CSS_For_Marquee__c];
        MarqText = Marquee.Marquee_Text__c;
        MarqText1 = Marquee.Marquee_Text1__c;
        MarqText2 = Marquee.Marquee_Text2__c;
        MarqText3 = Marquee.Marquee_Text3__c;
    } 
     
public pageReference Submit(){
//CSS_For_Marquee__c MQText = CSS_For_Marquee__c.getOrgDefaults();

//Marquee = CSS_For_Marquee__c.getOrgDefaults();

//Marquee.name = MarqText+'12';
//upsert Marquee name;

Marquee = [Select Marquee_Text__c,Marquee_Text1__c,Marquee_Text2__c,Marquee_Text3__c from CSS_For_Marquee__c];
if(MarqText !=null && MarqText !=''){
Marquee.Marquee_Text__c = MarqText;
}
if(MarqText1!=null && MarqText1 !=''){
Marquee.Marquee_Text1__c = MarqText1;
}
if(MarqText2!=null && MarqText2 !=''){
Marquee.Marquee_Text2__c = MarqText2;
}
if(MarqText3!=null && MarqText3 !=''){
Marquee.Marquee_Text3__c = MarqText3;
}
upsert Marquee;
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Saved Successfully'));
return null; 

}
}