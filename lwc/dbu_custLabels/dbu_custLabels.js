/*
* @description: This component is used for refernceing all the Custom Labels being used in the site. 
                Currently being used for referencing PDP, Cart and UserAndShippingInfo component
                This is used to optimize the code and have all the labels at single place
* @author: Pratyusha Yadavilli
* @StartDate: 25/07/222
*/

import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada'; //custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French'; //custom label refres to'FR'
import currencyCodeUSA from '@salesforce/label/c.dbu_home_store_country_currency_code_USA';
import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada';
import headerBanner from '@salesforce/label/c.dbu_headerBanner';
import isBarOpen from '@salesforce/label/c.dbu_isBarOpen';
import dbu_slider_scroll_duration from '@salesforce/label/c.dbu_slider_scroll_duration';
import deals from '@salesforce/label/c.dbu_deals';//Custome Label refers to 'Deals'
import promotions from '@salesforce/label/c.dbu_promotions';//Custome Label refers to 'Promotons'
import category from '@salesforce/label/c.dbu_category';//Custome Label refers to 'Category'
import brand from '@salesforce/label/c.dbu_brand';//Custome Label refers to 'Brand'
import dbu_deals_description from '@salesforce/label/c.Dbu_deals_description';
import filter from '@salesforce/label/c.dbu_category_filter';
import home from '@salesforce/label/c.dbu_category_home';
import sortby from '@salesforce/label/c.dbu_category_sortby';
import showperpage from '@salesforce/label/c.dbu_category_showperpage';
import showingpage from '@salesforce/label/c.dbu_category_showingpage';
//import dbu_home_store_U_S_A from '@salesforce/label/c.dbu_home_store_U_S_A';
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';
//import dbu_home_store_Canada from '@salesforce/label/c.dbu_home_store_Canada';
//import dbu_home_store_Canada_French from '@salesforce/label/c.dbu_home_store_Canada_French';
import dbu_applyAndClose from "@salesforce/label/c.dbu_applyAndClose";
import loginInURL from '@salesforce/label/c.dbu_login_URL';
import communityName from '@salesforce/label/c.dbu_communityName';
import avialbleShipData from '@salesforce/label/c.dbu_Available_to_ship';
import nonReturnable from '@salesforce/label/c.dbu_Non_Returnable';
import pickUpOnlyPrdct from '@salesforce/label/c.dbu_Pick_Up_Only';
import CrateShipping from '@salesforce/label/c.dbu_Crate_Shipping';
import crateenginekit from '@salesforce/label/c.dbu_crateenginekit';
import CrateRestrictCA from '@salesforce/label/c.dbu_CrateRestrictCA';
import CrateRestrictUS from '@salesforce/label/c.dbu_CrateRestrictUS';
import CrateLaws from '@salesforce/label/c.dbu_CrateLaws';
import CrateWarrenty from '@salesforce/label/c.dbu_CrateWarrenty';
import CrateRegulations from '@salesforce/label/c.dbu_CrateRegulations';
import CrateRegulationsCA from '@salesforce/label/c.dbu_CrateRegulationsCA';
import ClickHere from '@salesforce/label/c.dbu_ClickHere';
import CrateQuickStartGuide from '@salesforce/label/c.dbu_CrateQuickStartGuide';
import CrateBrochure from '@salesforce/label/c.dbu_CrateBrochure';
import CrateInstallation from '@salesforce/label/c.dbu_CrateInstallation';
import dbu_ESN_Not_eligible from '@salesforce/label/c.dbu_ESN_Not_eligible';
import dbu_ESNReturnTimeline from '@salesforce/label/c.dbu_ESNReturnTimeline';
import dbu_ESNEligibleProducts from '@salesforce/label/c.dbu_ESNEligibleProducts';
import dbu_ESNReturnPolicy from '@salesforce/label/c.dbu_ESNReturnPolicy';
import dbu_ESNNote from '@salesforce/label/c.dbu_ESNNote';
import dbu_ESNHeader from '@salesforce/label/c.dbu_ESNHeader';
import dbu_ESNMainHeader from '@salesforce/label/c.dbu_ESNMainHeader';
import dbu_ESNText from '@salesforce/label/c.dbu_ESNText';
import coreChargeLbl from '@salesforce/label/c.dbu_Refundable_Core_Return';
import dbu_CrateMandateText from '@salesforce/label/c.dbu_CrateMandateText';
import dbu_productDetail_addToWishlist from '@salesforce/label/c.dbu_productDetail_addToWishlist';
import dbu_OnlinePriceOnly from '@salesforce/label/c.dbu_OnlinePriceOnly';
import dbu_DefaultProductImage from "@salesforce/label/c.dbu_DefaultProductImage";
import 	dbu_Close from '@salesforce/label/c.dbu_Close';
import dbu_miniCart_price from '@salesforce/label/c.dbu_miniCart_price';
import 	dbu_see from '@salesforce/label/c.dbu_see';
import dbu_home_footer_corePolicy from '@salesforce/label/c.dbu_home_footer_corePolicy';
import dbu_For_detail from '@salesforce/label/c.dbu_For_detail';
import dbu_NotifyMSG from '@salesforce/label/c.dbu_NotifyMSG';

import 	dbu_Part_Availbility from '@salesforce/label/c.dbu_Part_Availbility';
import dbu_product_notify from '@salesforce/label/c.dbu_product_notify';
import 	dbu_isBackInStock from '@salesforce/label/c.dbu_isBackInStock';
import 	dbu_product_bakcinstock from '@salesforce/label/c.dbu_product_bakcinstock';
import 	dbu_Invalid_ESN from '@salesforce/label/c.dbu_Invalid_ESN';

import dbu_product_identification from '@salesforce/label/c.dbu_product_identification';
import 	dbu_VIN from '@salesforce/label/c.dbu_VIN';
import dbu_validate_vin from '@salesforce/label/c.dbu_validate_vin';
import 	dbu_Year from '@salesforce/label/c.dbu_Year';
import 	dbu_Make  from '@salesforce/label/c.dbu_Make';
import 	dbu_Model from '@salesforce/label/c.dbu_Model';
import dbu_product_crateCAError from '@salesforce/label/c.dbu_product_crateCAError'; 
import 	dbu_product_crateUSError from '@salesforce/label/c.dbu_product_crateUSError';
import	dbu_productDetail_addToCart from '@salesforce/label/c.dbu_productDetail_addToCart';
import dbu_product_IAgree from '@salesforce/label/c.dbu_product_IAgree';
import 	dbu_product_AcceptAgreement  from '@salesforce/label/c.dbu_product_AcceptAgreement';
import dbu_IAccept  from '@salesforce/label/c.dbu_IAccept';
import dbu_shopCart_youAreNotSigned from '@salesforce/label/c.dbu_shopCart_youAreNotSigned';

import dbu_SignInCumminsAccount  from '@salesforce/label/c.dbu_SignInCumminsAccount';
import dbu_shopCart_dontHaveAccount  from '@salesforce/label/c.dbu_shopCart_dontHaveAccount';
import dbu_createaccount from '@salesforce/label/c.dbu_createaccount';
import dbu_shopCart_continueAsGuest  from '@salesforce/label/c.dbu_shopCart_continueAsGuest';

import dbu_productDetail_productOverview from '@salesforce/label/c.dbu_productDetail_productOverview';
import dbu_Agreed from '@salesforce/label/c.dbu_Agreed';
import dbu_Core_Charge from '@salesforce/label/c.dbu_Core_Charge';
import dbu_shopCart_continueShopping from '@salesforce/label/c.dbu_shopCart_continueShopping';
import dbu_miniCart_proceedToCart from '@salesforce/label/c.dbu_miniCart_proceedToCart';
import dbu_Inside_Kit from '@salesforce/label/c.dbu_Inside_Kit';
import dbu_productDetail_specifications from '@salesforce/label/c.dbu_productDetail_specifications';

import dbu_Supersession from '@salesforce/label/c.dbu_Supersession';
import dbu_ReconEquivalentPartNumber from '@salesforce/label/c.dbu_ReconEquivalentPartNumber';
import dbu_IncludeKit from '@salesforce/label/c.dbu_IncludeKit';
import dbu_HowtoLocateSpec from '@salesforce/label/c.dbu_HowtoLocateSpec';

import dbu_productDetail_warranty from '@salesforce/label/c.dbu_productDetail_warranty';
import 	dbu_Warrentypart from '@salesforce/label/c.dbu_Warrentypart';
import dbu_product_warrentykms from '@salesforce/label/c.dbu_product_warrentykms';
import dbu_product_warrentycomplete from '@salesforce/label/c.dbu_product_warrentycomplete';
import dbu_product_soldon from '@salesforce/label/c.dbu_product_soldon';
import dbu_crate_ViewAggreements from '@salesforce/label/c.dbu_crate_ViewAggreements';
import dbu_Frequently_Bought_Together from '@salesforce/label/c.dbu_Frequently_Bought_Together';
import 	dbu_Total_Price_for_all from '@salesforce/label/c.dbu_Total_Price_for_all';
import 	dbu_locateheader from '@salesforce/label/c.dbu_locateheader';
import 	dbu_locatecontent1 from '@salesforce/label/c.dbu_locatecontent1';
import 	dbu_locatecontent2 from '@salesforce/label/c.dbu_locatecontent2';
import 	dbu_locateassit from '@salesforce/label/c.dbu_locateassit';
import 	dbu_locatecontactus from '@salesforce/label/c.dbu_locatecontactus';
import dbu_free_shipping_info from '@salesforce/label/c.dbu_free_shipping_info';
import dbu_free_shipping_info_Canada_PDP from '@salesforce/label/c.dbu_free_shipping_info_Canada_PDP';
import dbu_restrictions_apply_link from '@salesforce/label/c.dbu_restrictions_apply_link';
import dbu_CrateEngineCanadadisclaimer from '@salesforce/label/c.dbu_CrateEngineCanadadisclaimer';// Canada Disclaimer sri
import dbu_CrateEngineCanadaYearValidation from '@salesforce/label/c.dbu_CrateEngineCanadaYearValidation';// Canada Year validation sri
import dbu_shippingonOrders from '@salesforce/label/c.dbu_Free_shipping_on_orders_100';
import dbu_percentOff from '@salesforce/label/c.Dbu_percentOff';
import 	dbu_PDP_max_quantity_2 from '@salesforce/label/c.dbu_PDP_max_quantity_2';
import 	dbu_maximum_quantity from '@salesforce/label/c.dbu_maximum_quantity';
import 	dbu_product_max_allowed_qty from '@salesforce/label/c.dbu_product_max_allowed_qty';
import 	dbu_PDP_max_quantity from '@salesforce/label/c.dbu_PDP_max_quantity';
import dbu_adjusted_disc from '@salesforce/label/c.dbu_adjusted_disc';
import dbu_disc_tooltip from '@salesforce/label/c.dbu_disc_tooltip';

//dbu_cart custom labels start
import registrationURL from '@salesforce/label/c.dbu_registration_URL';
import coreChargeAvailabilityMsg from '@salesforce/label/c.dbu_CoreCharge_Availability_Msg';
import dbu_shopCart_shoppingCart from '@salesforce/label/c.dbu_shopCart_shoppingCart';
import dbu_shopCart_quantity from '@salesforce/label/c.dbu_shopCart_quantity';
import dbu_shopCart_unitPrice from '@salesforce/label/c.dbu_shopCart_unitPrice';
import dbu_shopCart_savedItems from '@salesforce/label/c.dbu_shopCart_savedItems';
import dbu_myAccount_addAllItemsToCart from '@salesforce/label/c.dbu_myAccount_addAllItemsToCart';
import dbu_shopCart_orderSummary from '@salesforce/label/c.dbu_shopCart_orderSummary';
import dbu_shopCart_items from '@salesforce/label/c.dbu_shopCart_items';
import dbu_shopCart_discount from '@salesforce/label/c.dbu_shopCart_discount';
import dbu_shopCart_subTotal from '@salesforce/label/c.dbu_shopCart_subTotal';
import dbu_shopCart_total from '@salesforce/label/c.dbu_shopCart_total';
import dbu_shopCart_proceedToCheckout from '@salesforce/label/c.dbu_shopCart_proceedToCheckout';
import dbu_notSignedIn from '@salesforce/label/c.dbu_notSignedIn';
import dbu_miniCart_oopsYourCartIsEmpty from '@salesforce/label/c.dbu_miniCart_oopsYourCartIsEmpty';
import dbu_myAccount_inStock from '@salesforce/label/c.dbu_myAccount_inStock';
import dbu_myAccount_outOfStock from '@salesforce/label/c.dbu_myAccount_outOfStock';
import dbu_myAccount_addToCart from '@salesforce/label/c.dbu_myAccount_addToCart';
import dbu_miniCart_pleaseAcceptOurCookiePolicy from '@salesforce/label/c.dbu_miniCart_pleaseAcceptOurCookiePolicy';
import dbu_shopCart_product from '@salesforce/label/c.dbu_shopCart_product';
import dbu_shopCart_tax from '@salesforce/label/c.dbu_shopCart_tax';
import dbu_shopCart_agreeWith from '@salesforce/label/c.dbu_shopCart_agreeWith';
import dbu_shopCart_createAccount from '@salesforce/label/c.dbu_shopCart_createAccount';
import dbu_miniCart_or from '@salesforce/label/c.dbu_miniCart_or';
import dbu_miniCart_doYouWant from '@salesforce/label/c.dbu_miniCart_doYouWant';
import dbu_miniCart_signIn from '@salesforce/label/c.dbu_miniCart_signIn';
import dbu_miniCart_register from '@salesforce/label/c.dbu_miniCart_register';
import dbu_miniCart_accept from '@salesforce/label/c.dbu_miniCart_accept';
import dbu_miniCart_noThanks from '@salesforce/label/c.dbu_miniCart_noThanks';
import dbu_done from '@salesforce/label/c.dbu_done';
import dbu_myAccount_saveForLater from '@salesforce/label/c.dbu_myAccount_saveForLater';
import dbu_shopCart_calculatedAtCheckout from '@salesforce/label/c.dbu_shopCart_calculatedAtCheckout';
import dbu_shopCart_termsConditions from '@salesforce/label/c.dbu_shopCart_termsConditions';
import dbu_cart_page_outofstock_msg from '@salesforce/label/c.dbu_cart_page_outofstock_msg';
import dbu_cart_page_Aggreed from '@salesforce/label/c.dbu_cart_page_Aggreed';
import dbu_checkoutPage_shippingMethod from "@salesforce/label/c.dbu_checkoutPage_shippingMethod";
import dbu_checkoutPage_shipToAddress from "@salesforce/label/c.dbu_checkoutPage_shipToAddress";
import dbu_storepickuplocation from "@salesforce/label/c.dbu_storepickuplocation";
import dbu_fromShipping from '@salesforce/label/c.dbu_from_FREE_Shipping';//Sandeep
import dbu_gotFreeShipping from '@salesforce/label/c.dbu_You_ve_got_Free_Shipping';//sandeep
import dbu_shippingonOrders_canada from '@salesforce/label/c.dbu_Free_shipping_on_orders_35_Canada';//sandeep
import dbu_partialInStockMsg from '@salesforce/label/c.dbu_partialInStockMsg';
import dbu_taxMsg from '@salesforce/label/c.dbu_taxMsg';
import dbu_taxMsg1 from '@salesforce/label/c.dbu_taxMsg1';
import dbu_taxMsg2 from '@salesforce/label/c.dbu_taxMsg2';
import dbu_PickupOnlyErrorMsg from '@salesforce/label/c.dbu_PickupOnlyErrorMsg';
import dbu_PickupFromStoreFree from '@salesforce/label/c.dbu_PickupFromStoreFree';
import dbu_EstimatedDelivery from '@salesforce/label/c.dbu_EstimatedDelivery';
import dbu_EstimatedPickup from '@salesforce/label/c.dbu_EstimatedPickup';
import dbu_SelectAnotherStore from '@salesforce/label/c.dbu_SelectAnotherStore';
import dbu_promoCouponMsg from '@salesforce/label/c.dbu_promoCouponMsg';
import dbu_ShippingCost_TotalAmout from '@salesforce/label/c.dbu_ShippingCost_TotalAmout';
import dbu_shopCart_marketingEmail from '@salesforce/label/c.dbu_shopCart_marketingEmail';
import 	dbu_cart_page_max_quantity from '@salesforce/label/c.dbu_cart_page_max_quantity';
//dbu_cart custom labels end


//dbu_UserAndShippingInfo Custom labels
import standardShippingData from '@salesforce/label/c.dbu_Standard_Shipping';
import freeShippingData from '@salesforce/label/c.dbu_Free_Shipping';
import flatRateWgt100To149Data from '@salesforce/label/c.dbu_Flat_Rate_weight_100_149_99_lbs';
import flatRateBelow100Data from '@salesforce/label/c.dbu_Flat_Rate_Shipping_orders_below_100';
import flatRateGreaterThan150Data from '@salesforce/label/c.dbu_Flat_Rate_Shipping_grater_150_lbs';
import dbu_checkoutPage_customerInfo from "@salesforce/label/c.dbu_checkoutPage_customerInfo";
import dbu_checkoutPage_Company_optional from "@salesforce/label/c.dbu_checkoutPage_Company_optional";
import dbu_checkoutPage_firstName from "@salesforce/label/c.dbu_checkoutPage_firstName";
import dbu_checkoutPage_lastName from "@salesforce/label/c.dbu_checkoutPage_lastName";
import dbu_checkoutPage_emailAddress from "@salesforce/label/c.dbu_checkoutPage_emailAddress";
import dbu_checkoutPage_phoneNumber from "@salesforce/label/c.dbu_checkoutPage_phoneNumber";
import dbu_checkoutPage_pickupFromStore from "@salesforce/label/c.dbu_checkoutPage_pickupFromStore";
import dbu_checkoutPage_shippingAddress from "@salesforce/label/c.dbu_checkoutPage_shippingAddress";
import dbu_checkoutPage_Select_Address from "@salesforce/label/c.dbu_checkoutPage_Select_Address";
import dbu_checkoutPage_Apply from "@salesforce/label/c.dbu_checkoutPage_Apply";
import dbu_checkoutPage_address1 from "@salesforce/label/c.dbu_checkoutPage_address1";
import dbu_checkoutPage_address2 from "@salesforce/label/c.dbu_checkoutPage_address2";
import dbu_checkoutPage_address2Label from "@salesforce/label/c.dbu_checkoutPage_address2Label";
import dbu_checkoutPage_city from "@salesforce/label/c.dbu_checkoutPage_city";
import dbu_checkoutPage_zipCode from "@salesforce/label/c.dbu_checkoutPage_zipCode";
import dbu_checkoutPage_postalCode from "@salesforce/label/c.dbu_checkoutPage_postalCode";
import dbu_checkoutPage_select from "@salesforce/label/c.dbu_checkoutPage_select";
import dbu_checkoutPage_Prev from "@salesforce/label/c.dbu_checkoutPage_Prev";
import dbu_checkoutPage_Next from "@salesforce/label/c.dbu_checkoutPage_Next";
import dbu_checkoutPage_billingAddress from "@salesforce/label/c.dbu_checkoutPage_billingAddress";
import dbu_checkoutPage_enterbillingAddress from "@salesforce/label/c.dbu_checkoutPage_enterbillingAddress";
import dbu_checkoutPage_sameAsShippingAddress from "@salesforce/label/c.dbu_checkoutPage_sameAsShippingAddress";
import dbu_checkoutPage_shippingOptions from "@salesforce/label/c.dbu_checkoutPage_shippingOptions";
import dbu_checkoutPage_standardShipping from "@salesforce/label/c.dbu_checkoutPage_standardShipping";
import dbu_checkoutPage_MandatoryFields from "@salesforce/label/c.dbu_checkoutPage_MandatoryFields";
import dbu_checkoutPage_ReadComplete from "@salesforce/label/c.dbu_checkoutPage_ReadComplete";
import dbu_checkoutPage_Proceed_Order_Review from "@salesforce/label/c.dbu_checkoutPage_Proceed_Order_Review";
import dbu_checkoutPage_orderSummary from "@salesforce/label/c.dbu_checkoutPage_orderSummary";
import dbu_checkoutPage_storeName from "@salesforce/label/c.dbu_checkoutPage_storeName";
import dbu_checkoutPage_Open_Hours from "@salesforce/label/c.dbu_checkoutPage_Open_Hours";
import dbu_checkoutPage_Business_Hours from "@salesforce/label/c.dbu_checkoutPage_Business_Hours";
import dbu_checkoutPage_distance from "@salesforce/label/c.dbu_checkoutPage_distance";
import dbu_checkoutPage_contact from "@salesforce/label/c.dbu_checkoutPage_contact";
import dbu_checkoutPage_items from "@salesforce/label/c.dbu_checkoutPage_items";
import dbu_checkoutPage_discount from "@salesforce/label/c.dbu_checkoutPage_discount";
import dbu_checkoutPage_Tax from "@salesforce/label/c.dbu_checkoutPage_Tax";
import dbu_checkoutPage_shippingCost from "@salesforce/label/c.dbu_checkoutPage_shippingCost";
import dbu_checkoutPage_total from "@salesforce/label/c.dbu_checkoutPage_total";
import dbu_reviewOrder_Subtotal from "@salesforce/label/c.dbu_reviewOrder_Subtotal";
import dbu_checkoutPage_calculatedAtCheckout from "@salesforce/label/c.dbu_checkoutPage_calculatedAtCheckout";
import dbu_checkoutPage_Original_Shipping_Address from "@salesforce/label/c.dbu_checkoutPage_Original_Shipping_Address";
import dbu_checkoutPage_country from "@salesforce/label/c.dbu_checkoutPage_country";
import dbu_checkoutPage_state from "@salesforce/label/c.dbu_checkoutPage_state";
import dbu_checkoutPage_Suggested_Shipping_Address from "@salesforce/label/c.dbu_checkoutPage_Suggested_Shipping_Address";
import dbu_checkoutPage_ErrorDesc from "@salesforce/label/c.dbu_checkoutPage_ErrorDesc";
import dbu_checkoutPage_Original_Billing_Address from "@salesforce/label/c.dbu_checkoutPage_Original_Billing_Address";
import dbu_checkoutPage_Suggested_Billing_Address from "@salesforce/label/c.dbu_checkoutPage_Suggested_Billing_Address";
import dbu_checkoutPage_Continue_with_Original_Address from "@salesforce/label/c.dbu_checkoutPage_Continue_with_Original_Address";
import dbu_checkoutPage_Apply_Suggested_Address from "@salesforce/label/c.dbu_checkoutPage_Apply_Suggested_Address";
import dbu_checkoutPage_CookiePolicy_Msg from "@salesforce/label/c.dbu_checkoutPage_CookiePolicy_Msg";
import dbu_checkoutPage_CookieMsg2 from "@salesforce/label/c.dbu_checkoutPage_CookieMsg2";
import dbu_checkoutPage_OR from "@salesforce/label/c.dbu_checkoutPage_OR";
import dbu_checkoutPage_Register from "@salesforce/label/c.dbu_checkoutPage_Register";
import dbu_checkoutPage_Accept from "@salesforce/label/c.dbu_checkoutPage_Accept";
import dbu_checkoutPage_NoThanks from "@salesforce/label/c.dbu_checkoutPage_NoThanks";
import dbu_checkoutPage_serachList from "@salesforce/label/c.dbu_checkoutPage_serachList";
import dbu_checkoutPage_Pickedup_Msg from "@salesforce/label/c.dbu_checkoutPage_Pickedup_Msg";
import dbu_checkoutPage_ContinueToPickup from "@salesforce/label/c.dbu_checkoutPage_ContinueToPickup";
import dbu_reviewPage_ShippedMsg from "@salesforce/label/c.dbu_reviewPage_ShippedMsg";
import dbu_checkoutPage_Continue_to_Ship from "@salesforce/label/c.dbu_checkoutPage_Continue_to_Ship";
import dbu_checkoutPage_Cancel from "@salesforce/label/c.dbu_checkoutPage_Cancel";
import dbu_checkout_phone from '@salesforce/label/c.dbu_checkout_phone';
import dbu_home_footer_returnAndRefundPolicy from '@salesforce/label/c.dbu_home_footer_returnAndRefundPolicy';
import dbu_checkout_PickUPSFL_msg from '@salesforce/label/c.dbu_checkout_PickUPSFL_msg';
import dbu_checkout_ShiponlySFL_msg from '@salesforce/label/c.dbu_checkout_ShiponlySFL_msg';
import dbu_checkoutPage_poMessage from '@salesforce/label/c.dbu_checkoutPage_poMessage';
import dbu_CrateEnginePartnumber from '@salesforce/label/c.dbu_CrateEnginePartnumber';//sri
import dbu_POBoxValidation from '@salesforce/label/c.dbu_POBoxValidation';// Sri
import dbu_ca_province_shipping_error from '@salesforce/label/c.dbu_ca_province_shipping_error';

const labels = {
        storeUSA,
        storeCA,
        storeCAF,
        currencyCodeUSA,
        currencyCodeCanada,
        headerBanner,
        isBarOpen,
        dbu_slider_scroll_duration,
        deals,
        promotions,
        category,
        brand,
        dbu_deals_description,
        filter,
        home,
        sortby,
        showperpage,
        showingpage,
        storeCanada,
        dbu_applyAndClose,
        loginInURL,
        communityName,
        avialbleShipData,
        nonReturnable,
        pickUpOnlyPrdct,
        CrateShipping,
        crateenginekit,
        CrateRestrictCA,
        CrateRestrictUS,
        CrateLaws,
        CrateWarrenty,
        CrateRegulations,
        CrateRegulationsCA,
        ClickHere,
        CrateQuickStartGuide,
        CrateBrochure,
        CrateInstallation,
        dbu_ESN_Not_eligible,
        dbu_ESNReturnTimeline,
        dbu_ESNEligibleProducts,
        dbu_ESNReturnPolicy,
        dbu_ESNNote,
        dbu_ESNHeader,
        dbu_ESNMainHeader,
        dbu_ESNText,
        coreChargeLbl,
        dbu_CrateMandateText,
        dbu_productDetail_addToWishlist,
        dbu_OnlinePriceOnly,
        dbu_DefaultProductImage,
        dbu_Close,
        dbu_miniCart_price,
        dbu_see,
        dbu_home_footer_corePolicy,
        dbu_For_detail,
        dbu_NotifyMSG,
        dbu_Part_Availbility,
        dbu_product_notify,
        dbu_isBackInStock,
        dbu_product_bakcinstock,
        dbu_Invalid_ESN,
        dbu_product_identification,
        dbu_VIN,
        dbu_validate_vin,	
        dbu_Year,
        dbu_Make,
        dbu_Model,
        dbu_free_shipping_info,
        dbu_free_shipping_info_Canada_PDP,
        dbu_shippingonOrders,
        dbu_restrictions_apply_link,
        dbu_product_crateUSError,
        dbu_product_crateCAError,
        dbu_productDetail_addToCart,
        dbu_product_IAgree,
        dbu_product_AcceptAgreement,
        dbu_shopCart_youAreNotSigned,
        dbu_SignInCumminsAccount,
        dbu_shopCart_dontHaveAccount,
        dbu_createaccount,
        dbu_IAccept,
        dbu_shopCart_continueAsGuest,
        dbu_productDetail_productOverview,
        dbu_Agreed,
        dbu_Core_Charge,
        dbu_shopCart_continueShopping,
        dbu_miniCart_proceedToCart,
        dbu_Inside_Kit,
        dbu_productDetail_specifications,
        dbu_Supersession,
        dbu_ReconEquivalentPartNumber,
        dbu_IncludeKit,
        dbu_HowtoLocateSpec,
        dbu_productDetail_warranty,
        dbu_Warrentypart,
        dbu_product_warrentykms,
        dbu_product_warrentycomplete,
        dbu_product_soldon,
        dbu_crate_ViewAggreements,
        dbu_Frequently_Bought_Together,
        dbu_Total_Price_for_all,
        dbu_CrateEngineCanadadisclaimer,// Canada disclaimer label sri
        dbu_CrateEngineCanadaYearValidation,// Canada Year validation label sri
        dbu_product_max_allowed_qty,/*Aakriti CECI-693*/
        dbu_maximum_quantity,/*Aakriti CECI-693*/
        dbu_PDP_max_quantity,/*Aakriti CECI-693*/
        dbu_PDP_max_quantity_2,/*Aakriti CECI-693*/
        dbu_percentOff,
        dbu_locateheader,
        dbu_locatecontent1,
        dbu_locatecontent2,
        dbu_locateassit,
        dbu_locatecontactus,
        registrationURL,
        coreChargeAvailabilityMsg,
        dbu_shopCart_shoppingCart,
        dbu_shopCart_quantity,
        dbu_shopCart_unitPrice,
        dbu_shopCart_savedItems,
        dbu_myAccount_addAllItemsToCart,
        dbu_shopCart_orderSummary,
        dbu_adjusted_disc,
        dbu_disc_tooltip,
        dbu_shopCart_items,
        dbu_shopCart_discount,
        dbu_shopCart_subTotal,
        dbu_shopCart_total,
        dbu_shopCart_proceedToCheckout,
        dbu_notSignedIn,
        dbu_miniCart_oopsYourCartIsEmpty,
        dbu_myAccount_inStock,
        dbu_myAccount_outOfStock,
        dbu_myAccount_addToCart,
        dbu_miniCart_pleaseAcceptOurCookiePolicy,
        dbu_shopCart_product,
        dbu_shopCart_tax,
        dbu_shopCart_agreeWith,
        dbu_shopCart_createAccount,
        dbu_miniCart_or,
        dbu_miniCart_doYouWant,
        dbu_miniCart_signIn,
        dbu_miniCart_register,
        dbu_miniCart_accept,
        dbu_miniCart_noThanks,
        dbu_done,
        dbu_myAccount_saveForLater,
        dbu_shopCart_calculatedAtCheckout,
        dbu_shopCart_termsConditions,
        dbu_cart_page_outofstock_msg,
        dbu_cart_page_Aggreed,
        dbu_checkoutPage_shippingMethod,
        dbu_checkoutPage_shipToAddress,
        dbu_storepickuplocation,
        dbu_fromShipping,
        dbu_gotFreeShipping,
        dbu_shippingonOrders_canada,
        dbu_partialInStockMsg,
        dbu_taxMsg,
        dbu_taxMsg1,
        dbu_taxMsg2,
        dbu_PickupOnlyErrorMsg,
        dbu_PickupFromStoreFree,
        dbu_EstimatedDelivery,
        dbu_EstimatedPickup,
        dbu_SelectAnotherStore,
        dbu_promoCouponMsg,
        dbu_ShippingCost_TotalAmout,
        dbu_shopCart_marketingEmail,
        dbu_cart_page_max_quantity,
        standardShippingData,
        freeShippingData,
        flatRateWgt100To149Data,
        flatRateBelow100Data,
        flatRateGreaterThan150Data,
        dbu_checkoutPage_customerInfo,
        dbu_checkoutPage_Company_optional,
        dbu_checkoutPage_firstName,
        dbu_checkoutPage_lastName,
        dbu_checkoutPage_emailAddress,
        dbu_checkoutPage_phoneNumber,
        dbu_checkoutPage_pickupFromStore,
        dbu_checkoutPage_shippingAddress,
        dbu_checkoutPage_Select_Address,
        dbu_checkoutPage_Apply,
        dbu_checkoutPage_address1,
        dbu_checkoutPage_address2,
        dbu_checkoutPage_address2Label,
        dbu_checkoutPage_city,
        dbu_checkoutPage_zipCode,
        dbu_checkoutPage_postalCode,
        dbu_checkoutPage_enterbillingAddress,
        dbu_checkoutPage_sameAsShippingAddress,
        dbu_checkoutPage_shippingOptions,
        dbu_checkoutPage_standardShipping,
        dbu_checkoutPage_MandatoryFields,
        dbu_checkoutPage_ReadComplete,
        dbu_checkoutPage_Proceed_Order_Review,
        dbu_checkoutPage_orderSummary,
        dbu_checkoutPage_items,
        dbu_checkoutPage_discount,
        dbu_checkoutPage_Tax,
        dbu_checkoutPage_shippingCost,
        dbu_checkoutPage_total,
        dbu_checkoutPage_country,
        dbu_checkoutPage_state,
        dbu_checkoutPage_calculatedAtCheckout,
        dbu_checkoutPage_Original_Shipping_Address,
        dbu_checkoutPage_Suggested_Shipping_Address,
        dbu_checkoutPage_ErrorDesc,
        dbu_checkoutPage_Original_Billing_Address,
        dbu_checkoutPage_Suggested_Billing_Address,
        dbu_checkoutPage_Continue_with_Original_Address,
        dbu_checkoutPage_Apply_Suggested_Address,
        dbu_checkoutPage_CookiePolicy_Msg,
        dbu_checkoutPage_CookieMsg2,
        dbu_checkoutPage_OR,
        dbu_checkoutPage_Register,
        dbu_checkoutPage_Cancel,
        dbu_checkout_phone,
        dbu_home_footer_returnAndRefundPolicy,
        dbu_checkout_PickUPSFL_msg,
        dbu_checkout_ShiponlySFL_msg,
	dbu_checkoutPage_poMessage,
        dbu_CrateEnginePartnumber,
        dbu_POBoxValidation,
        dbu_ca_province_shipping_error,

        //NotBeingUsed
        dbu_checkoutPage_storeName,
        dbu_checkoutPage_Open_Hours,
        dbu_checkoutPage_Business_Hours,
        dbu_checkoutPage_distance,
        dbu_checkoutPage_contact,
        dbu_checkoutPage_select,
        dbu_checkoutPage_Prev,
        dbu_checkoutPage_Next,
        dbu_checkoutPage_billingAddress,
        dbu_reviewOrder_Subtotal,
        dbu_checkoutPage_Accept,
        dbu_checkoutPage_NoThanks,
        dbu_checkoutPage_serachList,
        dbu_checkoutPage_Pickedup_Msg,
        dbu_checkoutPage_ContinueToPickup,
        dbu_reviewPage_ShippedMsg,
        dbu_checkoutPage_Continue_to_Ship
        
}

export default {
        labels
}