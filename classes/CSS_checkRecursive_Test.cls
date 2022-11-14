@IsTest(seealldata = true)
public class CSS_checkRecursive_Test {
     static testMethod void CSS_checkRecursive_Test_Method1(){
          Test.startTest();
         
         CSS_checkRecursive chkrec=new CSS_checkRecursive();
         CSS_checkRecursive.runOnce();
         //chkrec.run='false';
        //  chkrec.runOnce();

	 //  System.assertEquals(true, chkrec.runOnce);
      // 
              Test.stopTest();
        
    }

}