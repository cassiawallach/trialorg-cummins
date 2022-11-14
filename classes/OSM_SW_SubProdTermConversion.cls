/**
 *      @author             Vineet 
 *      @date               17/05/2018
 *      @description        Class 

        Modification Log:   OSM_SW_SubProdTermConversion use to enumarate SubprodTerm's billing frequencies & pricing
        ------------------------------------------------------------------------------------
        Developer                       Date                Description
        ------------------------------------------------------------------------------------
        Vineet                         17/05/2018           Initial Setup
        
 */
 
 Public class OSM_SW_SubProdTermConversion{
 
 public enum billingFrequencies{Weekly,Monthly,Quarterly,Yearly,OneTime}
 
  private static Map<String, Decimal> typeMap = new Map<String, Decimal>
  {
    'Weekly' => 0,
    'Monthly' => 1,
    'Quarterly' => 2,
    'Yearly' => 3,
    'OneTime' => 4,
    'One-Time' => 4,
    'One Time' => 4
  };

private static Map<String, Decimal> ferquenciesMap = new Map<String, Decimal>
  {
    'Weekly' => 52,
    'Monthly' => 12,
    'Quarterly' => 4,
    'Yearly' => 1,
    'OneTime' => 1,
    'One-Time' => 1,
    'One Time' => 1
  };

private static Map<String, Decimal> rfqFerquenciesPerMonth = new Map<String, Decimal>
  {
    'Weekly' => (52/12),
    'Monthly' => 1,
    'Quarterly' => 3,
    'Yearly' => 12,
    'OneTime' => 12,
    'One-Time' => 12,
    'One Time' => 12
  };

private static Map<String, Decimal> rfqFerquenciesPerYear = new Map<String, Decimal>
  {
    'Weekly' => 52,
    'Monthly' => 12,
    'Quarterly' => 4,
    'Yearly' => 1,
    'OneTime' => 1,
    'One-Time' => 1,
    'One Time' => 1
  };
    
  public Decimal multiplier(String s)
  {
    return typeMap.get(s);
  }
 
 
 public static decimal getMultilier(String bFrom, String bTo){
 
     if(typeMap.get(bFrom) > typeMap.get(bTo)){
     
         return ferquenciesMap.get(bFrom) * ferquenciesMap.get(bTo);
     }
 
     if(typeMap.get(bFrom) < typeMap.get(bTo)){
     
         return ferquenciesMap.get(bFrom) / ferquenciesMap.get(bTo);
     }
     
 return 1;
 }
 
 public static decimal getRFQMultilier(String bFrom, String bTo){
     return rfqFerquenciesPerMonth.get(bFrom) * rfqFerquenciesPerMonth.get(bTo);
 }
 
 public static decimal calculatePriceForSelectedSubs(Decimal yearlyPrice, String bTo){
        Decimal price = 0;
        try{
         if(yearlyPrice != 0){
             price = (yearlyPrice / rfqFerquenciesPerYear.get(bTo));
         }
         }catch(exception ex){system.debug(ex);}
         
     return price;
 }
 
 
 }