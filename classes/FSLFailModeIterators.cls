public class FSLFailModeIterators implements Iterator<FSLFailModeWrapper> {
    Integer i;
    public List<FSLFailModeWrapper> fssCdsRecs{get;set;}
    public FSLFailModeIterators ()
    {
        FSLFailModeService fsCds = new FSLFailModeService();
        fssCdsRecs = new List<FSLFailModeWrapper>();
        fssCdsRecs=FSLFailModeService.storeApplicationOrCategoryComplaintList();
        i=0;
    }
    public boolean hasNext() {
        if(fssCdsRecs != null)
            return i < fssCdsRecs.size();
        else return false;
    }
    public FSLFailModeWrapper next() {
        if(i <= fssCdsRecs.size())
        {
            system.debug('before return i value:::'+i);
            return fssCdsRecs[i++];//new Account(Name='Test '+Counter--);
        }        
        else return null;
    }
}