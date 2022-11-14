public class OSM_DataLoader_CommonUtilities 
{   
    public static final String SUCCESS = 'SUCCESS';
    public static final String FAILURE = 'FAILURE';
    public static final String ERROR = 'ERROR';
    
    public static Date getEndDate()
    {
        return Date.newInstance(2099, 01, 01);
    }
    
    public static Date getStartDate()
    {
        return Date.today().addDays(-1);
    }
    
    public static String getNonNullString(String str)
    {
        if(String.isEmpty(str))
            return '';
        if(null == str)
            return '';
        
        return str;
    }
    
    // check if list is empty or null
    public static boolean notListIsEmptyOrNull(List<String> strList)
    {
        if(strList != null && strList.size()>0)
            return true;
        else
            return false;
    } 
    
    // validate the list and return String list of the blocks
    public static List<String> splitAndValidate_DetailsList(String validateString)
    {
        List<String> detailsList = new List<String>();
        
        Boolean errorFlag = false;
        
        if(validateString.length() > 4 && validateString.substring(0,1) == '[' && validateString.substring(validateString.length()-1,validateString.length()) == ']')
        {
            // data is enclosed within [ ] 
            List<String> blockList = validateString.substring(1, validateString.length()-1).split('#');
            
            for(String block : blockList)
            {
                if(block.substring(0,1) == '{' && block.substring(block.length()-1,block.length()) == '}')
                {
                    // block is enclosed within { }
                    String str = block.substring(1, block.length()-1);
                    
                    // Make sure no { or } exists within the string....this is to make sure a # is not missed out
                    if(!str.contains('{') && !str.contains('}'))
                    {
                        detailsList.add(str);
                    }
                    else
                    {
                        errorFlag = true;
                        break;
                    }
                }
                else
                {
                    // block is not enclosed within { }
                    errorFlag = true;
                    break;
                }
            }
        }
        else
        {
            // data not enclosed within [ ]
            errorFlag = true;
        }
        
        if(errorFlag)
            return null;
        else
            return detailsList;
    }
}