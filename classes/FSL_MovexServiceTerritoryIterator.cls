global class FSL_MovexServiceTerritoryIterator implements Iterator<FSL_MovexServiceTerritoryWrapper > {
    Integer i;
    global List<FSL_MovexServiceTerritoryWrapper> fssCdsRecs{get;set;}
    global FSL_MovexServiceTerritoryIterator()
    {
        FSL_MovexServiceTerritory fsCds = new FSL_MovexServiceTerritory();
        fssCdsRecs = new List<FSL_MovexServiceTerritoryWrapper>();
        fssCdsRecs = fsCds.getServiceTerritoryResponse();
        i = 0;
        system.debug('fssCdsRecs'+fssCdsRecs);
    }
    global boolean hasNext() {
        if(fssCdsRecs != null)
            return i < fssCdsRecs.size();
        else return false;
    }
    global FSL_MovexServiceTerritoryWrapper  next() {
        if(fssCdsRecs != null && i <= fssCdsRecs.size())
        {
            system.debug('before return i value:::'+i);
            return fssCdsRecs[i++];
        }        
        else return null;
    }
}