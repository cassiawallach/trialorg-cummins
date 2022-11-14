public class FSL_ChildServiceRequestDataCloning {
    public static void chatterPostonChildSR(map<Id,Id> childTicketIdToParentTicketId){
        list<FeedItem> postInsertLst = new list<FeedItem>();
        map<Id,string> childTicketIdToParentTicketNumber= new map<Id,string>();//added
        Map<Id,Case> parentCaseMap=new Map<Id,case>([SELECT Id,CaseNumber FROM Case WHERE Id IN:childTicketIdToParentTicketId.values()]);
        for(Id childRecId:childTicketIdToParentTicketId.keySet()){
            childTicketIdToParentTicketNumber.put(childRecId,parentCaseMap.get(childTicketIdToParentTicketId.get(childRecId)).CaseNumber);   
        }
        
        for(Id childTicketId:childTicketIdToParentTicketId.keySet()){
            FeedItem post = new FeedItem();
            post.ParentId =childTicketId; 
            post.Body =  'Please note this ticket is created as a child ticket from '+childTicketIdToParentTicketNumber.get(childTicketId)+ ' ('+System.Label.FSL_CreateChildCaseSFBaseURL+childTicketIdToParentTicketId.get(childTicketId)+'), refer to this Service Request link for any possible customer interactions from prior Support Agent.';
            postInsertLst.add(post);
        }
        if(postInsertLst != null && !postInsertLst.isEmpty()){
            insert postInsertLst;
        }
    }
    
    public static void copyFilesToChildCase(map<Id,Id> ParentTicketIdTochildTicketId){
        list<ContentDocumentLink> ContentDocumentLinkInsertList = new list<ContentDocumentLink>();
        Set<Id> linkedEntityIdSet = new Set<Id>();
        Map<Id,EmailMessage> emMap=new Map<Id,EmailMessage>([SELECT Id,ParentId FROM EmailMessage WHERE ParentId IN:ParentTicketIdTochildTicketId.keyset()]);
        system.debug('emMap=='+emMap);
        
        //---Changes added By Cummins Dev Offshore team 21-06-2022
        for(Id emailMId : emMap.keySet())
        {
            for(Id ParentRecordID : ParentTicketIdTochildTicketId.keySet()){
                if(emailMId != ParentRecordID){
                    linkedEntityIdSet.add(emailMId);
                    if(!ParentTicketIdTochildTicketId.containsKey(emailMId)){
                        linkedEntityIdSet.add(ParentRecordID);
                    }
                }
            }
        }
        System.debug('linkedEntityIdSet' +  linkedEntityIdSet);
        //Changes End
        
        system.debug('ParentTicketIdTochildTicketId=='+ParentTicketIdTochildTicketId);
        Set<ContentDocumentLink> setattachmentDetails = new Set<ContentDocumentLink>();//--- Added By Cummins Dev Offshore team 14-06-2022
        list<ContentDocumentLink> ContentDocumentLinlList=new list<ContentDocumentLink>();
        if(linkedEntityIdSet != null && linkedEntityIdSet.size()>0){
            ContentDocumentLinlList=[SELECT LinkedEntityId,ContentDocumentId FROM ContentDocumentLink 
                                     WHERE LinkedEntityId IN:linkedEntityIdSet];
        }
        
        system.debug('ContentDocumentLinlList=='+ContentDocumentLinlList);       
        if(ContentDocumentLinlList != null && !ContentDocumentLinlList.isEmpty()){
            for(ContentDocumentLink conDocLnk:ContentDocumentLinlList){
                Id linkedObjId= (ParentTicketIdTochildTicketId.containsKey(conDocLnk.LinkedEntityId)) ? ParentTicketIdTochildTicketId.get(conDocLnk.LinkedEntityId) : (ParentTicketIdTochildTicketId.containsKey(emMap.get(conDocLnk.LinkedEntityId).ParentId)) ? ParentTicketIdTochildTicketId.get(emMap.get(conDocLnk.LinkedEntityId).ParentId) :null;
                system.debug('linkedObjId=='+linkedObjId);
                if(linkedObjId != null){
                    ContentDocumentLink contentlink = new ContentDocumentLink();
                    contentlink.LinkedEntityId = linkedObjId;
                    contentlink.contentdocumentid = conDocLnk.ContentDocumentId;
                    contentlink.ShareType = 'V';
                    // ContentDocumentLinkInsertList.add(contentlink);//--commented by cummins Dev Offshore Team 14-06-2022
                    setattachmentDetails.add(contentlink);//--- Added By Cummins Dev Offshore team 14-06-2022
                }
            }
            ContentDocumentLinkInsertList.addAll(setattachmentDetails);//--- Added By Cummins Dev Offshore team 14-06-2022
            
            if(ContentDocumentLinkInsertList != null && !ContentDocumentLinkInsertList.isEmpty()){
                System.debug('Before Insert record>>>>' +ContentDocumentLinkInsertList);
                insert ContentDocumentLinkInsertList;
                //system.debug('ContentDocumentLinkInsertList=='+ContentDocumentLinkInsertList);
            }
        }
    }
}