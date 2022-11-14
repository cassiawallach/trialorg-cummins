/******************************************************************************************************************************************************************************
 Name : FSL_FlowCustomError
 Description: Class definition for throwing custom exceptions via Apex actions in Flows 


 Version				Date				Author						Summary of Change 
----------------------------------------------------------------------------------------------
1.0						4/28/2022		Naga Anusha Malepati			Created Class
2.0 					6/2/2022		Adam Tyler Glaub				Added additonal Error Catch
3.0						6/6/2022		Adam Tyler Glaub				Added logic for Generic Error display
******************************************************************************************************/
public class FSL_FlowCustomError {
    
    public class CustomException extends Exception {}
    public class FlowInput{
        @InvocableVariable public String errorMessage;
    }
    public class FlowOutput{
        @InvocableVariable public String customErrorMessage;		
        public FlowOutput(String customErrorMessage) {
            this.customErrorMessage = customErrorMessage;
        }
    }
    
    @InvocableMethod(label='Throw Custom Flow Exception')
    public static List<FlowOutput> throwCustomFlowException(List<String> inputs){
        FlowOutput[] results = new List<FlowOutput>();
        List<String> str_results = new List<String>();
        
        String excMessage = '';
        String genericMessage = System.Label.FSL_Flow_Generic_Error; //Added by Adam 6/6/2022
        if(inputs.size() > 0){
        //excMessage = inputs[0].stripHtmlTags();
            excMessage = inputs[0];
            if(excMessage.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION:')){
                excMessage = (excMessage.substringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION:'));   
                excMessage = (excMessage.substringBefore('---'));
                excMessage = (genericMessage + '\n' + excMessage); //Added by Adam 6/6/2022
                if(!str_results.contains(excMessage)){
                    results.add(new FlowOutput(excMessage));
                    str_results.add(excMessage);  
                }
                
            }
            else if(excMessage.contains('REQUIRED_FIELD_MISSING:')){
                excMessage = (excMessage.substringAfter('REQUIRED_FIELD_MISSING:'));
                excMessage = (excMessage.substringBefore(': ['));
                excMessage = (genericMessage + '\n' + excMessage); //Added by Adam 6/6/2022
                if(!str_results.contains(excMessage)){
                    results.add(new FlowOutput(excMessage));
                    str_results.add(excMessage);  
                }
            }
            //Added by Adam as part of NIN-190
            else if(excMessage.contains('NUMBER_OUTSIDE_VALID_RANGE:')){
                excMessage = (excMessage.substringAfter('NUMBER_OUTSIDE_VALID_RANGE:'));
                excMessage = (excMessage.substringBefore('---'));
                excMessage = (genericMessage + '\n' + excMessage); //Added by Adam 6/6/2022
                if(!str_results.contains(excMessage)){
                    results.add(new FlowOutput(excMessage));
                    str_results.add(excMessage);  
                }
            } 
            else if(excMessage.contains('DUPLICATES_DETECTED:')){
                String recordIdContact = excMessage.substringAfter('The flow tried to update these records:');
				recordIdContact = recordIdContact.substringBefore('.');
				System.debug(recordIdContact);
				recordIdContact = recordIdContact.trim();
                String urlForContact;
                if((recordIdContact instanceOf Id) && (((Id)recordIdContact).getSObjectType().getDescribe().getName() == 'Contact')){
                    urlForContact = URL.getSalesforceBaseUrl().toExternalForm()+'/'+recordIdContact;
                }
                excMessage = (excMessage.substringAfter('DUPLICATES_DETECTED:'));
                excMessage = (excMessage.substringBefore('---'));
                excMessage = (excMessage.substringBefore('Error ID'));
                excMessage = (genericMessage + '\n' + excMessage);
                if(urlForContact != null && urlForContact != ''){
                    excMessage = excMessage + ' <a href='+urlForContact+'>View Contact</a>';
                }
                if(!str_results.contains(excMessage)){
                    results.add(new FlowOutput(excMessage));
                    str_results.add(excMessage);  
                }
            }
            else if(excMessage.contains('INSUFFICIENT_ACCESS_OR_READONLY:')){
                excMessage = (excMessage.substringAfter('INSUFFICIENT_ACCESS_OR_READONLY:'));
                excMessage = (excMessage.substringBefore('---'));
                excMessage = (genericMessage + '\n' + excMessage); 
                if(!str_results.contains(excMessage)){
                    results.add(new FlowOutput(excMessage));
                    str_results.add(excMessage);  
                }
            }
            else{
                excMessage = 'Some error has been occurred. Please contact your System Administrator with following error message. '+excMessage;
            }
        }
        system.debug('results::'+results);
        return results;
        
    }
}