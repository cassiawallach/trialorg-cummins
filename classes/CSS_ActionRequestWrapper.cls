global class CSS_ActionRequestWrapper {
    	public map<String,List<CSS_srt__c>> mapkNumSRTS {get;set;}
    	public String dsid{set;get;}
        public CSS_ActionRequestWrapper(List<CSS_srt__c> accList,String dsid){
            this.dsid = dsid;
        	mapkNumSRTS = new map<String,List<CSS_srt__c>>();
            for(CSS_srt__c srt:accList){
                if(mapkNumSRTS.containsKey(srt.CaseName__c)){
                    mapkNumSRTS.get(srt.CaseName__c).add(srt);
                }else{
                    List<CSS_srt__c> srtList = new List<CSS_srt__c>();
                    srtList.add(srt);
                    mapkNumSRTS.put(srt.CaseName__c,srtList );
                }
            }
        }
}