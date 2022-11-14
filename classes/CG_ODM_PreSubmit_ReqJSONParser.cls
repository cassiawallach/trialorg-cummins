public class CG_ODM_PreSubmit_ReqJSONParser {   

    public Header Header {get;set;} 
    public Request Request {get;set;} 

    public class Sender {
        public String ServiceName {get;set;} 
        public String SenderID {get;set;} 
    }

    public class Target {
        public String TargetID {get;set;} 
    }

    public class Header {
        public Sender Sender {get;set;} 
        public Target Target {get;set;} 
    }

    public class Request {
        public String DecisionID {get;set;} 
        public Claim claim {get;set;} 
    }

    public class Claim {
        public String bisFlag {get;set;} 
        public String claimCreatedDate {get;set;} 
        public String claimNumber {get;set;} 
        public String claimReceivedDate {get;set;} 
        public String claimSource {get;set;} 
        public String claimStatus {get;set;} 
        public String claimSubmittedDate {get;set;} 
        public String claimTotal {get;set;} 
        public String cmiEngineSerialNumber {get;set;} 
        public String cmiServiceProviderCode {get;set;} 
        public Engine engine {get;set;} 
        public String engineApplicationCode {get;set;} 
        public String engineFamily {get;set;} 
        public String failureDate {get;set;} 
        public String failureMeasure {get;set;} 
        public String failurePoint {get;set;} 
        public AdditionalESN AdditionalESN {get;set;} 
        public List<Failures> failures {get;set;} 
        public String historyClaimFlag {get;set;} 
        public String manualAdjudicationFlag {get;set;} 
        public Messages messages {get;set;} 
        public String multiESNFlag {get;set;} 
        public String productApplicationCode {get;set;} 
        public String reconPartsWarrantyFlag {get;set;} 
        public String serviceModelName {get;set;} 
        public ServiceProvider serviceProvider {get;set;} 
        public String status {get;set;} 
        public string roNumber {get;set;} 
        public String serviceProviderName {get;set;} 
        public String distributorCode {get;set;} 
        public String totalClaimAmt {get;set;} 
        public String groupName {get;set;} 
        public String thresholdAmount {get;set;} 
        public String thresholdHrs {get;set;} 
        public String ownerName {get;set;} 
        public String warrantyStartDate {get;set;} 
        public String approverName {get;set;} 
        public String level {get;set;} 
        public String button {get;set;} 
        public String newPartsWarrantyFlag {get;set;} 
        public String possessionFlag {get;set;} 
        public String ecmCalibBefore {get;set;} 
        public String ecmCalibAfter {get;set;} 
        public String manufacturer {get;set;} 
        public String paccarFlag {get;set;} 
        public String paccarCertifiedLocationFlag {get;set;} 
        public String paccarPaymentRoutingFlag {get;set;} 
        public String countryCode {get;set;} 
        public Integer penalty {get;set;} 
        public String certificationFlag {get;set;} 
        public String roadRelayWarrantyFlag {get;set;} 
        public String modelSeries {get;set;} 
        public String applicationName {get;set;} 
        public String claimSubSource {get;set;} 
        public ComplaintCode ComplaintCode {get;set;} 
    }

    public class Engine {
        public String billToCode {get;set;} 
        public String buildDate {get;set;} 
        public String etoConversionDate {get;set;} 
        public String marineFlag {get;set;} 
        public String warrantyIndicatorFlag {get;set;} 
        public String productApplicationDesp {get;set;} 
        public String oemCode {get;set;} 
        public String designPhaseCode {get;set;} 
        public String engineFamilyCode {get;set;} 
        public String serviceModel {get;set;} 
    }

    public class AdditionalESN {
        public String ESN {get;set;} 
    }

    public class Messages {
        public String code {get;set;} 
        public String description {get;set;} 
        public String type {get;set;} // in json: type
    }

    public class ServiceProvider {
        public String channelOfDistribution {get;set;} 
        public String claimAllowedDays {get;set;} 
        public String region {get;set;} 
        public String territory {get;set;} 
        public String outfileAllClaimsFlag {get;set;} 
        public String regionCode {get;set;} 
        public String inactiveDate {get;set;} 
        public String status {get;set;} 
        public String groupName {get;set;} 
        public String channelDescription {get;set;} 
        public String paccarChecked {get;set;} 
        public String ltaChecked {get;set;} 
        public String engineEffectiveDate {get;set;} 
        public String engineExpirationdate {get;set;} 
        public String serviceModelName {get;set;} 
        public String oemCode {get;set;} 
        public String spState {get;set;} 
        public String spCountry {get;set;} 
        public String spServiceLevel {get;set;} 
        public String spWarrantyTrainingStatus {get;set;} 
        public String spCertificationEndDate {get;set;} 
        public String spSCMDollarAmt {get;set;} 
        public String spSCMDeductiblePct {get;set;} 
    }

    public class ComplaintCode {
        public String code {get;set;} 
    }

    public class Failures {
        public String accountCode {get;set;} 
        public AcctCodeInfo acctCodeInfo {get;set;} 
        public String approvalCode {get;set;} 
        public String authorizationNumber {get;set;} 
        public Campaign campaign {get;set;} 
        public String coverageType {get;set;} 
        public String failCode {get;set;} 
        public String failMode {get;set;} 
        public String totalLaborAmt {get;set;} 
        public String totalSRTHours {get;set;} 
        public String totalTowingAmt {get;set;} 
        public String accountCodeDesp {get;set;} 
        public String policyFlag {get;set;} 
        public String lineNumber {get;set;} 
        public List<OtherClaimables> otherClaimables {get;set;} 
        public List<Parts> parts {get;set;} 
        public String payCode {get;set;} 
        public List<SrtList> srtList {get;set;} 
        public String status {get;set;} 
        public List<Travels> travels {get;set;} 
        public String programID {get;set;} 
        public String overrideFlag {get;set;} 
        public String inShopCampaignFlag {get;set;} 
        public String travelCoveredFlag {get;set;} 
        public String GSQID {get;set;} 
    }

    public class AcctCodeInfo {
        public String accountCodeType {get;set;} 
        public String chryslerFlag {get;set;} 
        public String multiESNFlag {get;set;} 
        public String accountCodeWarrantyFlag {get;set;} 
    }

    public class SrtList {
        public String code {get;set;} 
        public String hours {get;set;} 
        public String lineNumber {get;set;} 
        public String offsiteCheck {get;set;} 
        public String description {get;set;} 
        public String quantity {get;set;} 
        public String srtAllowedFlag {get;set;} 
    }

    public class Campaign {
        public String accountCode {get;set;} 
        public String campaignId {get;set;} 
        public String campaignType {get;set;} 
        public String completeIndicator {get;set;} 
        public String effectiveDate {get;set;} 
        public String engineComponentCode {get;set;} 
        public String expiryDateIntl {get;set;} 
        public String expiryDateNA {get;set;} 
        public String failMode {get;set;} 
        public String multiFlag {get;set;} 
        public String status {get;set;} 
        public String systemCode {get;set;} 
        public String cmpEngineStatusCode {get;set;} 
    }

    public class Parts {
        public String lineNumber {get;set;} 
        public String partId {get;set;} 
        public String partPrice {get;set;} 
        public String priceBook {get;set;} 
        public String partName {get;set;} 
        public String reconPartFlag {get;set;} 
        public String exceptionPriceBook {get;set;} 
        public String channelCode {get;set;} 
        public String standardPriceBook {get;set;} 
        public String pricingRegion {get;set;} 
        public String partAllowedFlag {get;set;} 
        public String partReturnFlag {get;set;} 
        public String qtyApproved {get;set;} 
        public String adjPartPercentage {get;set;} 
    }

    public class OtherClaimables {
        public String item {get;set;} 
        public String lineNumber {get;set;} 
        public String details {get;set;} 
        public String amount {get;set;} 
    }

    public class Travels {
        public String hours {get;set;} 
        public String lineNumber {get;set;} 
        public String mealsCharges {get;set;} 
        public String towingCharges {get;set;} 
        public String travelDistance {get;set;} 
    }

    public static CG_ODM_PreSubmit_ReqJSONParser parse(String json) {
        return (CG_ODM_PreSubmit_ReqJSONParser) System.JSON.deserialize(json, CG_ODM_PreSubmit_ReqJSONParser.class);

    }
}