global class CSS_ComponentRequestWrapper {
    public String dsid{set;get;}
    public map<String,List<String>> kNumSolComps{set;get;}
    public CSS_ComponentRequestWrapper(List<CSS_Solution_Component__c> solComps,String dsid){
        this.dsid = dsid;
        kNumSolComps = new map<String,List<String>>();
        for(CSS_Solution_Component__c solComp:solComps){
            if(kNumSolComps.containsKey(solComp.Solutions__r.Name)){
                kNumSolComps.get(solComp.Solutions__r.Name).add(solComp.Name);
            }else{
                List<String> compList = new List<String>();
                compList.add(solComp.Name);
                kNumSolComps.put(solComp.Solutions__r.Name,compList );
            }
        }       
        
    }
}