public class CG_ODM_PreSubmit_ResJSONParser { 
    
    public class AcctCodeInfo {
        public String chryslerFlag {get;set;} 
        public String accountCodeType {get;set;} 
        public String multiESNFlag {get;set;} 
        public String accountCodeWarrantyFlag {get;set;} 
    }
    
    public class Messages {
        public String description {get;set;} 
        public String code {get;set;} 
        public String type {get;set;} // in json: type
    }
    
    public class SrtList {
        public String description {get;set;} 
        public String hours {get;set;} //updated
        public String offsiteCheck {get;set;} 
        public String lineNumber {get;set;} //updated
        public String quantity {get;set;} //updated
        public String code {get;set;} 
    }
    
    public class Failures {
        public String GSQID {get;set;} //updated
        public List<SrtList> srtList {get;set;} 
        public String accountCodeDesp {get;set;} 
        public String payCode {get;set;} 
        public String status {get;set;} 
        public String totalLaborAmt {get;set;} //updated
        public String authorizationNumber {get;set;} //updated
        public List<Parts> parts {get;set;} 
        public String approvalCode {get;set;} //updated
        public AcctCodeInfo acctCodeInfo {get;set;} //updated based on response
        public String overrideFlag {get;set;} 
        public String totalTowingAmt {get;set;} //updated
        public String programID {get;set;} //updated
        public String accountCode {get;set;} //updated
        public List<Travels> travels {get;set;} 
        public List<OtherClaimables> otherClaimables {get;set;} 
        public String failCode {get;set;} 
        public String coverageType {get;set;} 
        public String failMode {get;set;} //updated
        public String lineNumber {get;set;} //updated
        public String policyFlag {get;set;} 
        public String totalSRTHours {get;set;} //updated
        public Campaign campaign {get;set;} 
        public String travelCoveredFlag {get;set;} 
    }
    
    public class Sender {
        public String ServiceName {get;set;} 
        public String SenderID {get;set;} 
    }
    
    public class Response {
        public String DecisionID {get;set;} 
        public Claim claim {get;set;} 
    }
    
    public class Target {
        public String TargetID {get;set;} 
    }
    
    public class ComplaintCode {
        public String code {get;set;} //updated
    }
    
    public class Campaign {
        public String campaignId {get;set;} //updated
        public String engineComponentCode {get;set;} 
        public String completeIndicator {get;set;} 
        public String cmpEngineStatusCode {get;set;} 
        public String campaignType {get;set;} 
        public String status {get;set;} 
        public String systemCode {get;set;} 
        public String expiryDateNA {get;set;} 
        public String expiryDateIntl {get;set;} 
        public String accountCode {get;set;} //updated
        public String failMode {get;set;} 
        public String effectiveDate {get;set;} 
        public String multiFlag {get;set;} 
    }
    
    public class Header {
        public Sender Sender {get;set;} 
        public Target Target {get;set;} 
    }
    
    public class AdditionalESN {
        public String ESN {get;set;} //updated
    }
    
    public class Parts {
        public String partReturnFlag {get;set;} 
        public String channelCode {get;set;} //updated
        public String standardPriceBook {get;set;} 
        public String partName {get;set;} 
        public String pricingRegion {get;set;} 
        public String exceptionPriceBook {get;set;} 
        public String partPrice {get;set;} //updated
        public String lineNumber {get;set;} //updated
        public String partId {get;set;} //updated
        public String adjPartPercentage {get;set;} //updated
    }
    
    public class ServiceProvider {
        public String region {get;set;} 
        public String regionCode {get;set;} //updated
        public String groupName {get;set;} 
        public String territory {get;set;} //updated
        public String status {get;set;} 
        public String outfileAllClaimsFlag {get;set;} 
        public String engineEffectiveDate {get;set;} 
        public String spState {get;set;} 
        public String oemCode {get;set;} //updated
        public String channelOfDistribution {get;set;} //updated
        public String spSCMDollarAmt {get;set;} //updated
        public String spCountry {get;set;} 
        public String engineExpirationdate {get;set;} 
        public String spCertificationEndDate {get;set;} 
        public String serviceModelName {get;set;} 
        public String ltaChecked {get;set;} 
        public String channelDescription {get;set;} 
        public String spServiceLevel {get;set;} //updated
        public String spWarrantyTrainingStatus {get;set;} 
        public String inactiveDate {get;set;} 
        public String claimAllowedDays {get;set;} //updated
        public string spSCMDeductiblePct{get;set;}
    }
    
    public class OtherClaimables {
        public String amount {get;set;} //updated
        public String details {get;set;} 
        public String item {get;set;} 
        public String lineNumber {get;set;} //updated
    }
    
    public class Travels {//updated all
        public String mealsCharges {get;set;} 
        public String towingCharges {get;set;} 
        public String hours {get;set;} 
        public String lineNumber {get;set;} 
        public String travelDistance {get;set;} 
    }
    
    public class Engine {
        public String serviceModel {get;set;} 
        public String productApplicationDesp {get;set;} 
        public String marineFlag {get;set;} 
        public String designPhaseCode {get;set;} //updated
        public String engineFamilyCode {get;set;} //updated
        public String warrantyIndicatorFlag {get;set;} 
        public String buildDate {get;set;} 
        public String billToCode {get;set;} //updated
        public String etoConversionDate {get;set;} 
        public String oemCode {get;set;} //updated
    }
    
    public class Claim {
        public String thresholdAmount {get;set;} //updated
        public ComplaintCode ComplaintCode {get;set;} 
        public String cmiEngineSerialNumber {get;set;} //updated
        public String claimSource {get;set;} 
        public String paccarCertifiedLocationFlag {get;set;} 
        public string AdditionalESN {get;set;} //string as per latest response public AdditionalESN AdditionalESN {get;set;} 
        public String paccarPaymentRoutingFlag {get;set;} 
        public String newPartsWarrantyFlag {get;set;} 
        public String paccarFlag {get;set;} 
        public String level {get;set;} //updated
        public String button {get;set;} 
        public String roadRelayWarrantyFlag {get;set;} 
        public String penalty {get;set;} //updated
        public ServiceProvider serviceProvider {get;set;} 
        public String serviceProviderName {get;set;} 
        public String thresholdHrs {get;set;} //updated
        public String status {get;set;} 
        public string productApplicationCode {get;set;} //updated based on response
        public Engine engine {get;set;} 
        public String countryCode {get;set;} //updated
        public String claimSubmittedDate {get;set;} 
        public String ecmCalibBefore {get;set;} 
        public String manualAdjudicationFlag {get;set;} 
        public String manufacturer {get;set;} 
        public String claimCreatedDate {get;set;} 
        public String claimNumber {get;set;} 
        public String claimSubSource {get;set;} 
        public String groupName {get;set;} 
        public String reconPartsWarrantyFlag {get;set;} 
        public String historyClaimFlag {get;set;} 
        public String failureDate {get;set;} 
        public String multiESNFlag {get;set;} 
        public String totalClaimAmt {get;set;} //updated
        public List<Messages> messages {get;set;} 
        public String distributorCode {get;set;} //updated
        public String roNumber {get;set;} //updated
        public String serviceModelName {get;set;} 
        public String modelSeries {get;set;} 
        public String engineApplicationCode {get;set;} //updated
        public String warrantyStartDate {get;set;} 
        public String approverName {get;set;} 
        public String engineFamily {get;set;} //updated
        public String certificationFlag {get;set;} 
        public List<Failures> failures {get;set;} 
        public String failurePoint {get;set;} //updated
        public String applicationName {get;set;} 
        public String claimStatus {get;set;} 
        public String failureMeasure {get;set;} 
        public String cmiServiceProviderCode {get;set;} 
        public String ecmCalibAfter {get;set;} 
        public String bisFlag {get;set;} 
        public String possessionFlag {get;set;} 
    }
    
    public Header Header {get;set;} 
    public Response Response {get;set;} 
    
    public static CG_ODM_PreSubmit_ResJSONParser parse(String json) {
        return (CG_ODM_PreSubmit_ResJSONParser) System.JSON.deserialize(json, CG_ODM_PreSubmit_ResJSONParser.class);
    }
    
}