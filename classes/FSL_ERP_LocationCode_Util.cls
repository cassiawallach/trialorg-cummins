/******************************************************************************************************************************************************************************
 Name : FSL_ERP_LocationCode_Util
 Description: Utility Classs to split the Service Territory - Location Code and pass it to corresponding ERP instances

 Version				Date				Author						Summary of Change 
----------------------------------------------------------------------------------------------
1.0						7/16/2022		Trupthi Kyatham		               Created Class
**********************************************************************************************************************************************************************************/

public class FSL_ERP_LocationCode_Util {
    
    public static string getLocationCode(string sLoc){ 
        //sample: sLoc = 23456-78655-I, 23456-78655-746, 23456-78655-657-I
       if(sLoc != null && sLoc != ' ')
       {
        if(sLoc.split('-').size()>3)
        	{
          sLoc = sLoc.split('-')[0]+'-'+sLoc.split('-')[1]+'-'+sLoc.split('-')[2];                 
        	}
        
        else if(sLoc.split('-').size()>2 && sLoc.split('-')[2].length()>1)
             {
 		sLoc = sLoc.split('-')[0]+'-'+sLoc.split('-')[1]+'-'+sLoc.split('-')[2];                      
       		 }
                
        else if (sLoc.split('-').size()>2 && sLoc.split('-')[2].length()<=1)
      	 	 {
 		sLoc = sLoc.split('-')[0]+'-'+sLoc.split('-')[1];                   
       		 }
    }
        system.debug('Util Location Code:' + sLoc);
        return sLoc;
		}
	}