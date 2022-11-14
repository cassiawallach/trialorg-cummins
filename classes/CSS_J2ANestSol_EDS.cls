public class CSS_J2ANestSol_EDS {
  
  public string status;
  public static CSS_J2ANestSol_EDS parse(String json) {
    return (CSS_J2ANestSol_EDS) System.JSON.deserialize(json, CSS_J2ANestSol_EDS.class);
  }
}