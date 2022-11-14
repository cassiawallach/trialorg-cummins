public class CMI_SW_ProductDetailWrapper {

    
	//Start-fields to be parsed from backend
	public String sfdcName{get;
	set{
		this.sfdcName = value;
		this.name = value;
	}}
	public String sfId{get;set;}
    public String storefront{get;set;}
	public String shortDesc{get;set;}
	public String groupName{get;set;}
	public String SKU{get;set;}
    public String termNcond{get;set;}
    
	//End-fields to be parsed from backend
	
    public List<MediaWrapper> EProductMediasS {get;set;}
    
	//Start-fields to display on UI
	public String name{get;set;}
	//End-fields to display on UI
    
    
	//Start - Util Variables
	Map<String,List<MediaWrapper>> mediaTypeVsMediaMap;
	//End - Util Variables
	
    public class MediaWrapper{
        public String sfId {get;set;}
        public String uri {get;set;}
        public String enabled {get;set;}
        public Date srcDate {get;set;}
        public Date endDate {get;set;}
        public String filePath {get;set;}
        public String imageFullPath {get;set;}
        public String locale {get;set;}
        public String mediaName {get;set;}
        public String mediaType {get;set;}
        public String productId {get;set;}
        public String productMediaSource {get;
		set{
		 this.productMediaSource = value;
		 this.sourceType = value;
		}}
		public String termNcond{get;set;}
        public String sourceType {get;set;}
        public String sequence {get;set;}
        public String sfdcName {get;set;}
        public String srcType {get;set;}
        public String staticResourceName {get;set;}
       
    }
	
	public Map<String,List<MediaWrapper>> getSpecificMediaType(List<String> mediaTypeLst)
	{
	
		Map<String,List<MediaWrapper>> returnMap = new Map<String,List<MediaWrapper>>();
			if(mediaTypeVsMediaMap==null)
			{
				mediaTypeVsMediaMap = new Map<String,List<MediaWrapper>>(); 
			    for(MediaWrapper mediaWrapper :  EProductMediasS)
				{
					if(mediaTypeVsMediaMap.containsKey(mediaWrapper.mediaType))
					{
					   List<MediaWrapper> lst = mediaTypeVsMediaMap.get(mediaWrapper.mediaType);
					   lst.add(mediaWrapper);
					}
					else
					{
					  List<MediaWrapper> lst = new List<MediaWrapper>();
					  lst.add(mediaWrapper);
					  mediaTypeVsMediaMap.put(mediaWrapper.mediaType,lst);
					}
				}
			}
			
			
			
	       for(String mediaType : mediaTypeLst)
		   {
		      if(mediaTypeVsMediaMap.containsKey(mediaType))
			  {
			      returnMap.put(mediaType,cloneEntries(mediaTypeVsMediaMap.get(mediaType)));
			  }
			  
		   }
		   //return only required media types and make the source which contains all media types as null
		   //EProductMediasS = null;
		   return returnMap;
	}
	
	//Util method to clone
	private List<MediaWrapper> cloneEntries(List<MediaWrapper> mediaWrapperLst)
	{
	   List<MediaWrapper> returnLst = new List<MediaWrapper>();
	   MediaWrapper mediaTarget;
	   
	   for(MediaWrapper mediaSrc : mediaWrapperLst)
	   {
	      mediaTarget = new MediaWrapper();
		  mediaTarget.sfId = mediaSrc.sfId;
		  mediaTarget.uri = mediaSrc.uri;
		  mediaTarget.enabled = mediaSrc.enabled;
		  mediaTarget.srcDate = mediaSrc.srcDate;
		  mediaTarget.endDate = mediaSrc.endDate;
		  mediaTarget.filePath = mediaSrc.filePath;
		  mediaTarget.imageFullPath = mediaSrc.imageFullPath;
		  mediaTarget.locale = mediaSrc.locale;
		  mediaTarget.mediaName = mediaSrc.mediaName;
		  mediaTarget.mediaType = mediaSrc.mediaType;
		  mediaTarget.productId = mediaSrc.productId;
		  mediaTarget.productMediaSource = mediaSrc.productMediaSource;
		  mediaTarget.sequence = mediaSrc.sequence;
		  mediaTarget.sfdcName = mediaSrc.sfdcName;
		  mediaTarget.srcType = mediaSrc.srcType;
		  mediaTarget.staticResourceName = mediaSrc.staticResourceName;
		  returnLst.add(mediaTarget);
	   }
	   
	   return returnLst;
	}
    
}