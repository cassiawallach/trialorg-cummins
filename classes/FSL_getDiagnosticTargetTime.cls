/**********************************************************************
Name: FSL_getDiagnosticTargetTime
Copyright © 2022  Cummins
=======================================================================
=======================================================================
Purpose:    This is used for DiagnosticTargetTime Integration
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0      Charan         18/08/2022         INITIAL DEVELOPMENT
***********************************************************************/
public class FSL_getDiagnosticTargetTime {
    public static FSL_DiagTargetTimeResponse getDiagnosticTargetTime(Set<String> solIds, String equipID, String SMN, String engFamily, String langCode){
        try{
            FSL_DiagTargetTimeRequest diagTargetTimeRequest = new FSL_DiagTargetTimeRequest();
            FSL_DiagTargetTimeResponse diagTargetTimeResponse = new FSL_DiagTargetTimeResponse();
            CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
            system.debug('inside getDiagnosticTargetTime');
            system.debug(SMN+' ** '+engFamily+' ** '+langCode+' ** '+equipID);
            if(solIds != null && (SMN!=null && SMN!='') && (engFamily!=null && engFamily!='') && (langCode!=null && langCode!='') && (equipID!=null && equipID!='')){
                FSL_DiagTargetTimeRequest.Header HeaderDetails = new FSL_DiagTargetTimeRequest.Header();
                FSL_DiagTargetTimeRequest.Sender SenderDetails = new FSL_DiagTargetTimeRequest.Sender();
                SenderDetails.ServiceName = 'GetDiagnosticTargetTime';
                SenderDetails.MessageID = 'Unique Message ID at SF';
                SenderDetails.SenderID = 'SF';
                HeaderDetails.Sender = SenderDetails;
                FSL_DiagTargetTimeRequest.Target TargetDetails = new FSL_DiagTargetTimeRequest.Target();
                TargetDetails.TargetID = 'SRT';
                HeaderDetails.Target = TargetDetails;
                diagTargetTimeRequest.Header = HeaderDetails;
                FSL_DiagTargetTimeRequest.DataArea dArea = new FSL_DiagTargetTimeRequest.DataArea();
                String dateTemp;
                dateTemp = String.valueof(system.now());
                List<String> tempString = new List<String>();
                tempString = dateTemp.split(' ');
                dArea.EffectiveDateTime = tempString[0] + 'T' + tempString[1];
                dArea.ServiceModelName = SMN;
                dArea.EquipmentID = equipID;
                dArea.LanguageCode = langCode;
                dArea.EngineFamily = engFamily;
                diagTargetTimeRequest.DataArea = dArea;
                dArea.SolutionIds = new List<String>();

                for(String solutionId : solIds){
                    diagTargetTimeRequest.DataArea.SolutionIds.add(solutionId);
                }
        
                String diagTimeTargetReqBody = JSON.serialize(diagTargetTimeRequest);
                system.debug('diagTimeTargetReqBody-->'+diagTimeTargetReqBody);
                
                FSL_IP_NamedCredentialWrapper reqWrapper = null;  //code changes by Charan , PHOEN-259
                reqWrapper= new FSL_IP_NamedCredentialWrapper();
                reqWrapper.methodType = 'POST';
                reqWrapper.NamedCredential = 'FSL_NC_Engine';
                reqWrapper.Path = '/diagnostictargettime';
                reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
				
                reqWrapper.jsonReqBody = diagTimeTargetReqBody;
                reqWrapper.timeOut = 120000;
                system.debug('parts req >>>>>>>>>>>'+reqWrapper.jsonReqBody);
                
                returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
                system.debug('parts res >>>>>>>>>>>'+returnWrapper);
                HttpResponse resp = returnWrapper.response;
                system.debug('RESPONSEEEE '+resp);

                system.debug('returnWrapper--'+returnWrapper);
                HttpResponse httpRes = returnWrapper.response;
                system.debug('httpRes--'+httpRes);
                diagTargetTimeResponse = (FSL_DiagTargetTimeResponse)JSON.deserializeStrict(httpRes.getBody(), FSL_DiagTargetTimeResponse.class);
                return diagTargetTimeResponse;        
            }
            else
                return null;
        }
        catch (exception ex) {
            system.debug('In catch block of Diagnosis Target Time service callout with message' + ex.getMessage() + ' in the line ' + ex.getLineNumber());
            return null;
        }
    }
}