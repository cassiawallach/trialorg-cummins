global class CSS_J2Adsidclose_EDS {
    public String status{get;set;}

  public static CSS_J2Adsidclose_EDS parse(String json) {
    return (CSS_J2Adsidclose_EDS) System.JSON.deserialize(json, CSS_J2Adsidclose_EDS.class);
  }
}