/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-24-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class dbu_ProcessShippingLabelEmail_Test {

    @isTest public static void sendMailTest(){
        //deployment Comment 
        ccrz__E_Product__c productObj = dbu_TestDataCreationUtility.createProduct();
        insert productObj;
        
        ccrz__E_ContactAddr__c  ShipFromAddr = new ccrz__E_ContactAddr__c();
        ShipFromAddr.ccrz__AddressFirstline__c = '2815 Exposition Blvd';
        ShipFromAddr.ccrz__AddressSecondline__c = 'Ste 2353242';
        ShipFromAddr.ccrz__AddressThirdline__c = null;
        ShipFromAddr.ccrz__City__c = 'Austin';
        ShipFromAddr.ccrz__State__c = 'TX';
        ShipFromAddr.ccrz__PostalCode__c = '78703';
        ShipFromAddr.ccrz__Country__c = 'US';
        insert ShipFromAddr;//dont add admin email in To
        
        ccrz__E_Cart__c cartObj = dbu_TestDataCreationUtility.createCart();
        insert cartObj;
        
        ccrz__E_CartItem__c cartItemObj = dbu_TestDataCreationUtility.createCartItem(productObj.Id,cartObj.Id);
        insert cartItemObj;
        
        Id iamRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Contact contactObj = new Contact();
        contactObj.FirstName = 'Test';
        contactObj.LastName = 'Test';
        contactObj.Email = 'test@test.com';
        contactObj.Username__c  = 'ranadip@test.com';
        contactObj.IAM_Contact_Status__c = 'Active';
        contactObj.RecordTypeId = iamRecordTypeId;
        insert contactObj;
        
        ccrz__E_Order__c orderObj = new ccrz__E_Order__c();
        orderObj.ccrz__Name__c = 'My Cart';
        orderObj.ccrz__OrderNumber__c = 1253656;
        orderObj.ccrz__Storefront__c = 'CSSNAStore';
        orderObj.ccrz__OrderStatus__c = 'Delivered';
        orderObj.ccrz__CurrencyISOCode__c = 'USD';
        orderObj.ccrz__BuyerFirstName__c = 'name';
        orderObj.ccrz__BuyerLastName__c = '';
        orderObj.ccrz__BuyerEmail__c = 'test@test.com';
        orderObj.ccrz__BuyerPhone__c = '123456789';
        orderObj.ccrz__Contact__c = contactObj.Id;
        orderObj.ccrz__OrderDate__c= System.today();
        //orderObj.ccrz__Storefront__c ='CSSNAStore';
        orderObj.ccrz__OriginatedCart__c=cartObj.Id;
        //orderObj.ccrz__BillTo__c =billingAddr;
        orderObj.ccrz__ShipTo__c =ShipFromAddr.Id;
        orderObj.dbu_IsShippingLabelSent__c = false;
        orderObj.dbu_Shipping_Label__c = 'JVBERi0xLjQKJeLjz9MKMiAwIG9iago8PC9MZW5ndGggNjEvRmlsdGVyL0ZsYXRlRGVjb2RlPj5zdHJlYW0KeJwr5HIK4TI2UzC2NFMISeFyDeEK5CpUMFQwAEJDBV1jIz1LIGlsqGekkJyroB+RZqjgkq8QyAUARuULswplbmRzdHJlYW0KZW5kb2JqCjQgMCBvYmoKPDwvVHlwZS9QYWdlL01lZGlhQm94WzAgMCAyODggNDMyXS9SZXNvdXJjZXM8PC9Qcm9jU2V0IFsvUERGIC9UZXh0IC9JbWFnZUIgL0ltYWdlQyAvSW1hZ2VJXS9YT2JqZWN0PDwvWGYxIDEgMCBSPj4+Pi9Db250ZW50cyAyIDAgUi9QYXJlbnQgMyAwIFI+PgplbmRvYmoKMSAwIG9iago8PC9MZW5ndGggMjUxNS9GaWx0ZXJbL0FTQ0lJODVEZWNvZGUvRmxhdGVEZWNvZGVdL1Jlc291cmNlczw8L1Byb2NTZXQgNSAwIFIvRm9udDw8L0YxIDYgMCBSL0YyIDcgMCBSL0YzIDggMCBSL0Y0IDkgMCBSL0Y1IDEwIDAgUi9GNiAxMSAwIFIvRjcgMTIgMCBSL0Y4IDEzIDAgUi9GOSAxNCAwIFIvRjEwIDE1IDAgUi9GMTEgMTYgMCBSL0YxMiAxNyAwIFI+Pi9YT2JqZWN0PDwvRmVkRXhHcm91bmQgMTggMCBSL0dyb3VuZEcgMTkgMCBSL2JhcmNvZGUwIDIwIDAgUj4+Pj4vVHlwZS9YT2JqZWN0L1N1YnR5cGUvRm9ybS9CQm94WzAgMCA2MTIgNzkyXS9NYXRyaXhbMSAwIDAgMSAwIDBdL0Zvcm1UeXBlIDE+PnN0cmVhbQpHYXQ9Lj8jTlwmJnErXFRzJ1RQSTVbI2NtUVgrMW9RQjZqQ24yXV9TaSNzYSlBMGs5MG0uKiQvclVrTVJWYFJLSUhBSzIuNysnOGlrSTxdXAowJidmIVoqWDRlT3BIJWE4b0NyUy44O05dW2VSczJfVChUP3EvV28nPl1COUkhOUwlNi5LMlUtIktTLVRnLlI0ZWBJbDNBVTA3TTNUdSFpMQpba00+RF47dFBmNksuTiU8RVJhYWFGZFRlMD9pN20tU00pVl1YUm43QF8hUUBuNnM2KXE7KGwiPzUrQTwnYDVSPVMoQ3JBQCRaPEBrTWtnSgpEXV5WclMmOCNkNTN0YCZbUlJDNVNKZkohU1RmRTgmVD0nOT1JR2Q7JkQ5VzsoX0QjPlRMIltKayltT3BkP25oQmtSPE5ZI10zPGdNNiwsJQoodVY9ISthUzZMb0ZPcFdWXElXRkdkRF5DYmVgJCFadTRfYz4/TlA0KGQnbEI4VHIiXzUnZCJKOWFcMjhqLGMqYSExaWpBOi5iI2A4M1plXwpgKmhadHEvXj5sQ28+K3NuYWtwOnBkV000J0NbVTlwcjFRPmFpRE5kVFIhcl5kR2BFZ2dDLSxHNSg3MG86Pyk1OjRUXzVZNm9iITlpY0lQLgpyOFJDYCxkYStKWT9wKD9LOyxSI1RdU2Q9aFhQYEtVWkpRTDAkQSswX0RdT0Fobk9YO3B0O2IrLCsqK2peU2tFUVlMVGhzWUtZRDFIQVNIKwo4Jz1FSm1gMFFQYXBvSnBoYFFJXEcrck49KlVaRkFBYWVVSlpZKm1YSHVaTVVcXWs3a0sqV2lBa08vKjlvOGZOWVJhbyNHQjQmb3FjUUNCcgptKXRITm4nQjQrb0IsaGVVTDBAZ3JBNWQqMDMoZSNJWEtuNjglNlRcbjlUQSNdTyUpaGdLLGNHZWBuNlBlaWB0QnAlN0BwIjdwMz4tYl0iNwpaJ1piRGZhc1wxOWR1WGkxXGM1O2hlPmtRXkdZZEEhOi9hJ0gkcyhqJ0MwUFBsIWcwV2NZXDJqSmI6QU8uQUNnLm11bGVJJFBSY2JtbD9pQApyYTVPXmorPE1FX0JxbmMrI1k7LWArPz0sV086LWQ1Sz5iLzR0UV9bbyZcam1QMzslPG5VJS0lPD1YX2tyOFBYaEFiSUonVElIO2VoMz8ubwpiYE5PczhMQ0dXOkZhS0ptI1l1ZUImaT1CZEJeX3JhPkZwLU5kME1Wa1ZqOlZMPDUnJFg1a2pccylFK2NWJj1iOzpUaFdkPlo8QUIwZ0UqXwpsXihcZUVdLVVbWSdqYmYjaGNiaTtvbS48amgpNSJOQTpPO2JyI21DJDM7SDZNaUlhYXBaO0BtTEdPOyU4OCRUNERJTVNdS29NOEhyJzs2Ogpecmtbaj5EMFlCUShbbD9eSGhGdGswSGIkL0AkdXU3TzpBNXFYX3VWPj9jaG5daDknbEhmSkJfaT1OOjcuIzg4bkhrc2RvVyNhZm80LF9YWwoibW5XXlE0YzhuSCZUIWdiQSdDN0MnTj1VZyd0TD4rcilGUyIrWyM9IkN1W0dXUE9TSlBVOWBSWkdhUiZIJF9qZVh0LWptPjpnJS5mLDg1PwpaYS1GITo1XiZKI1Q2JUxUaSUhXClUblhKS0JpbGgtWE5USGVQSlo8YTlTJjo4I1hDZCQ+RTNIRWM/ZSxkUycnRjJeaj5jZjljRlMxUWlOVQpHWG5eT049J1puamQoOWJqSl0sYyRRR0BuYj5vUCk2a24xQ2onKDYyJjZZSCxuVkRwUSYvMDJOQXE3Y3NANEk8ZTBpPmYwbHEwLk5fM21cbgplTW9kOzJBMmNgbU9JVmAjKWFMYVJqODZtM0I1KWEvRjRDUigtIWlLaFNTM0E3dCIiQyZqP0M7LnNVOFNWSENKVFVsZyI4Vy5CcDRhaVBlZwpjOyNaaDo7KzNmaWVFMDZgPiswJE0qaVRUOXI4W2IuYD9MJmA/UF0sYl9KXE9WJXUkT1JGJF8mSWEvX1IwKHVkMWFqXkFeJytbMUVkTSI8SQpGV1wzJFc8SjtjS29LRidyO11TTmA7WGpuSlx0TXNsQmgpXk9iPS08SUFtRTFSTU9OZUxaMCxwNi5eUl9cJWxFJC8tdSYjLVY1Li5HQjpHJApObEVRRT4sQldBVVcuISlXKlMyVyYzQGNOOTA1YHRFN0I6S0NCZi5TOFs0dVMtOko6XmJzLT9ZOSlGLTInN0k/bFMsblgyOm8rcUJUP2hqPApKP0k8UURVXiFpTio7N3ImbT9mJUYxWD88XnNQXEE/Um1OXyVgKGcpIy0sTSEzXFNLVjVELnVZZXVtOi5DZkRhbFJfKytTLj47b0ktZSYzUQpWNTE5amZOJkI7OVhkREhcM1Y6Tj5FQCFqXDdlVT1wNk5UNmkqXFQqLyUnRFBqUllBQG9xYFNiWVouXjcucDBJZ0NKVi8nYmxDNlNMby5HSQplWTlsSCZ1MF5GVWZ1XVQ8TVsjOSgwNThEVUBdKEgidW4qb0NpK20ya3BKZG1rVl1ZJV5wLUFbXFBUYl49USVSJEU3XUxJRFFyVWpvUS1qIQo1aWBVdTU0K2ZnIV85ckU+U0Bya1VJYTg4RmVwIzdZWi5QLVhHIjhUS1BTLnMlPCxFQUNISjc9ViFScjUvMlApWFNGQmJvMiYqWUk3WylPOAo8PTlkKGIlbzcvJT5yYklHPCkvb05gTSRiNkNPTl5gOW5MW0M9ZkkkMywyST9SX2tOYVdaXi1yaT0nW0k+KUJAMSozalxvI1hfQ2VfMlsubwo+XihZRTswNFBkS20lSTJFPiM3KSlTJGRncDlTJXU/LzJBSTkhcT5fLzksQDhdKyowc0UqMTk3bSNDIV5bajlkX0JSdGVXPTYiRSRpM1UwPgpbX1U5VTdHYlNaa3BTRiFkMlw0SGYkOHJrbDF1Y28vVCpDPUJIMFltTjpmcDpAN2o9b18yWiNZS2gyVVBGdDgmYFU9ZUo6NkNVJXRSXyc6Pgo5bFs2O09oPmhhUkc0OiMkZlxxMyFnQlxibGouWSxSc1U3RCRVNlVNT2UiUiRTZipVYUg0PCtaQFl1PEgrMUtqai4oVTV1M2ZKSF9tQjtfcQosb0tqNGUlM2ZsM0tSJWhyLE0xdC5XLyY/QGktRSolUCQmLiJKU2tVJ1hUZSU1S0E6ZzsyOmVXZlEiVi8jaHJRTFA8Wzw/WEJgY1ZWK1BrYQpuNm9kZFxVX3MxKVtuTEZZVUwjX0c5P0RaU0xcLG5VU1BPSW0pUUJZYkJKZUlEZFxdSy1EK0tdMHJLNUgxNy1ubG9ObSIoUmI4LEU1OFRUTAo+UX4+CmVuZHN0cmVhbQplbmRvYmoKNSAwIG9iagpbL1BERi9UZXh0L0ltYWdlQi9JbWFnZUMvSW1hZ2VJXQplbmRvYmoKNiAwIG9iago8PC9UeXBlL0ZvbnQvU3VidHlwZS9UeXBlMS9CYXNlRm9udC9IZWx2ZXRpY2EvRW5jb2RpbmcvTWFjUm9tYW5FbmNvZGluZz4+CmVuZG9iago3IDAgb2JqCjw8L1R5cGUvRm9udC9TdWJ0eXBlL1R5cGUxL0Jhc2VGb250L0hlbHZldGljYS1Cb2xkL0VuY29kaW5nL01hY1JvbWFuRW5jb2Rpbmc+PgplbmRvYmoKOCAwIG9iago8PC9UeXBlL0ZvbnQvU3VidHlwZS9UeXBlMS9CYXNlRm9udC9IZWx2ZXRpY2EtT2JsaXF1ZS9FbmNvZGluZy9NYWNSb21hbkVuY29kaW5nPj4KZW5kb2JqCjkgMCBvYmoKPDwvVHlwZS9Gb250L1N1YnR5cGUvVHlwZTEvQmFzZUZvbnQvSGVsdmV0aWNhLUJvbGRPYmxpcXVlL0VuY29kaW5nL01hY1JvbWFuRW5jb2Rpbmc+PgplbmRvYmoKMTAgMCBvYmoKPDwvVHlwZS9Gb250L1N1YnR5cGUvVHlwZTEvQmFzZUZvbnQvQ291cmllci9FbmNvZGluZy9NYWNSb21hbkVuY29kaW5nPj4KZW5kb2JqCjExIDAgb2JqCjw8L1R5cGUvRm9udC9TdWJ0eXBlL1R5cGUxL0Jhc2VGb250L0NvdXJpZXItQm9sZC9FbmNvZGluZy9NYWNSb21hbkVuY29kaW5nPj4KZW5kb2JqCjEyIDAgb2JqCjw8L1R5cGUvRm9udC9TdWJ0eXBlL1R5cGUxL0Jhc2VGb250L0NvdXJpZXItT2JsaXF1ZS9FbmNvZGluZy9NYWNSb21hbkVuY29kaW5nPj4KZW5kb2JqCjEzIDAgb2JqCjw8L1R5cGUvRm9udC9TdWJ0eXBlL1R5cGUxL0Jhc2VGb250L0NvdXJpZXItQm9sZE9ibGlxdWUvRW5jb2RpbmcvTWFjUm9tYW5FbmNvZGluZz4+CmVuZG9iagoxNCAwIG9iago8PC9UeXBlL0ZvbnQvU3VidHlwZS9UeXBlMS9CYXNlRm9udC9UaW1lcy1Sb21hbi9FbmNvZGluZy9NYWNSb21hbkVuY29kaW5nPj4KZW5kb2JqCjE1IDAgb2JqCjw8L1R5cGUvRm9udC9TdWJ0eXBlL1R5cGUxL0Jhc2VGb250L1RpbWVzLUJvbGQvRW5jb2RpbmcvTWFjUm9tYW5FbmNvZGluZz4+CmVuZG9iagoxNiAwIG9iago8PC9UeXBlL0ZvbnQvU3VidHlwZS9UeXBlMS9CYXNlRm9udC9UaW1lcy1JdGFsaWMvRW5jb2RpbmcvTWFjUm9tYW5FbmNvZGluZz4+CmVuZG9iagoxNyAwIG9iago8PC9UeXBlL0ZvbnQvU3VidHlwZS9UeXBlMS9CYXNlRm9udC9UaW1lcy1Cb2xkSXRhbGljL0VuY29kaW5nL01hY1JvbWFuRW5jb2Rpbmc+PgplbmRvYmoKMTggMCBvYmoKPDwvVHlwZS9YT2JqZWN0L1N1YnR5cGUvSW1hZ2UvV2lkdGggMTE4L0hlaWdodCA0Ny9Db2xvclNwYWNlL0RldmljZUdyYXkvQml0c1BlckNvbXBvbmVudCA4L0xlbmd0aCA0NTAvRmlsdGVyWy9BU0NJSTg1RGVjb2RlL0ZsYXRlRGVjb2RlXT4+c3RyZWFtCkdiIi9lSkldUj8jWG5MZ1Q2PGRmL0kuJj9CPWhjRGFnLXJENF0wJVBmTVRaK2BRU0krSl1DXiZyRDNBOGxNOG5uRkZQIUkuZipqWUMyVG5bCjw3aSg3XDxKSCE8dVZ1bTNISmZrPDgpKyVaTipNZi1zJWw+VlpVQ3MsOWA5b1cmVE0lL2NnbUpVJS5mTGhiSSQnPkJndV9pQFErQyZiV3I2CjNEQ002L0ZVTXQsREJeLCpSMDBzIl1XRkdDMGo6I1dhNGdXPCpRZVQ7LD87QlMhb3J1NXUkXzNCMmpcMkMuJ2IuRlhxQFgxQSosYVxTYUdKCjpuTWtjSVFcLkpmOjA1N18tTDRKPCUyUU1tSWFvQFw4OEZLR2IxcCxtVzslLkhOQy47Vi4rYGQpczpyQmhVakxIQlgyUkNeOV9xODFuVltLCkw9MlFCRnQ7clRDbjZbZnBtcHI3U19jRyFkV1ssc1gxKys4UjwpLSVGY1Uua1JwV1MpWEU7OSs7NGxTK182QXNyY0ViUUxjSUVjXzslTUtFCjNjakdUOSpOW0oucE4yV21JOFc/JGw7YzZdNWQvP3A4dDxzRWFKMmVybCt+PgplbmRzdHJlYW0KZW5kb2JqCjE5IDAgb2JqCjw8L1R5cGUvWE9iamVjdC9TdWJ0eXBlL0ltYWdlL1dpZHRoIDU0L0hlaWdodCA1NC9Db2xvclNwYWNlL0RldmljZUdyYXkvQml0c1BlckNvbXBvbmVudCA4L0xlbmd0aCAxOTYvRmlsdGVyWy9BU0NJSTg1RGVjb2RlL0ZsYXRlRGVjb2RlXT4+c3RyZWFtCkdiIjBPM3UzPmgkcS9NMEooJVM3LEt1WTwtcy5sSC0ncUVTKHBST0hDclBuJDdaOSlhNiJMUidTI29DNToiRWxoTCQyMyUyPzpfJ2xjWS90CjkmQzQvTkByT1tbRSdqYmBzPlw6UHBqbTU8QyxNPSZYO28sQVFqbWZha0ptRyQwRHBUPGAvV0hDSUtkaDhwPDBrSTI/YWFVaUlMMVczIkMhCjZEZDY2bCw+V15IW2YuPSQpckxuVGlTZkk0M0A5STxXfj4KZW5kc3RyZWFtCmVuZG9iagoyMCAwIG9iago8PC9UeXBlL1hPYmplY3QvU3VidHlwZS9JbWFnZS9XaWR0aCAyOTQvSGVpZ2h0IDU4L0NvbG9yU3BhY2UvRGV2aWNlR3JheS9CaXRzUGVyQ29tcG9uZW50IDgvTGVuZ3RoIDExNzUvRmlsdGVyWy9BU0NJSTg1RGVjb2RlL0ZsYXRlRGVjb2RlXT4+c3RyZWFtCkdiIi9jPWAyLDIkcSxDQDkyPy5lWmQ6PjkhMyxmXihKI1InLCVockEhck0+amNjTipdXz1jQ2ZmL20+SGhsP0VXVEBaQVgwTENdLnBIIl5eCm8zZUlxUHRZIlVlYytiaUk6bVI3WzlYL1pDYlBGLUt0YGZOYlleIi40QTBCO3JAT2wzLFZyKEhiPyIzQisxSElrMCdhO2ZyRSVQX1BVTlJMCkNKcy5rKUppRUVAOSdYND1yNVxPbllOVVdyZTZMZkM7aTIpa2J1YztDKTNbV09idTo7NkZzZ3VeWHRQSUVwWGkmOytNIkZnKFlgXmlHN1pDClcyNmtjOi9fTUddXjlfMW0/TCQ9KiRjTDU6c2svM0liMF4mJnN0THRtTF9hOGw6Jl5JVGRgXC82WEdSbD8kOiE0L1ojZTwxYDw1MF0hJ11SCmxnLWRVNko1aHNJNzJqOyFsaF5qaT4vWT9bT3ImbGVqbDtuPXJAMkYwZVUpJlFJOFcmcCtXQVtORVA+VDwwVi9oQDtrZU9bayhYXTk4XEtNCk8lLkptLFpZSUY1N1gvY3JqLFI3X3UrOlA4a1xDa1YyZzZuPkc/JVdLcihzJClrN1pILlEuUUwwR3FBI1stWzIkXW5BLkNRbmJNaEBLPyksCjRlVnJuW1ptKis7K19rKF1MPDpSKmNscHQ0PjJmSlRCVmNuSEU1JHRZPWorWlBXXz5XPGZgS21gQWZCTUpoLjFOaClSbEkuNHFCW1BpLzlnCj1ASDYlI0ArZSZXIjBVRF0zXSctNEhnQzAsTHItTFA+dClNPC5IQmlVZTleaUFWK1k9RlkwR2RGSW5ZWSNZS0tBSz1nNHJWP0AhXT8nNzolCnJFZCROUFghVi8sOnBpcyMxcjVPVk0qMSRQYTlgcDhvW18pXydTV0MiXWUpMjEvLHAlYkpfP0w4aEpRbGZySy5VUDIjM1lRcU1WN1BhOWBoCjhuMEZGN1toamYuISNgXyEnOHNINzgsMGtOZWRcVl9nJz00RCVsNm41JldHTDk+U2g8YCRQNWleNkZyMzsrX2xNPChXKGBnZGpYTitdKjIiCllnXEZZVk4xODtaLW10bT1fL3JZXSdOTlJzMjk5MVpCVVsnQmhHLE01JTZiYClwOjkvOjNjXk5NKF8oblEqZ3NWJnFqMVgpYFlYXUYwbjFuClxfX1ljJSo0I09Zb1xPYGRTYCwlQmhYOllRPyZhVkkwYDVrRmFTJ01AVVlFVCdPQzhJSEN1QVItUToiK1I/RjhkQEYxUmcrRlomM1FJOFpXCihTck8/JkYwLXUpR1hfW19vMF9ULT1JVyYsSDpwYiZCR288JnIsUlhIV208MzBsKShhcWJLKCddVlchInJlJEEiMFRvJGktUUwzZVRuWyhoCjBNOEQyIWpXK1leZzRqV01AOj1oLi4zaTk6cWlYKF5aPVRiYnNWPUYvPl0xYlFyOWtNUFk+N0A8YVwxa0tOIlFNZE11RmpPUypFI0BcWXByCkQ6I0chPSZhMTdaRW5eSWtGZjdMSG1wWUReU0o2X3BXaihAIXVmKX4+CmVuZHN0cmVhbQplbmRvYmoKMyAwIG9iago8PC9UeXBlL1BhZ2VzL0NvdW50IDEvS2lkc1s0IDAgUl0vSVRYVCg1LjEuMSk+PgplbmRvYmoKMjEgMCBvYmoKPDwvVHlwZS9DYXRhbG9nL1BhZ2VzIDMgMCBSPj4KZW5kb2JqCjIyIDAgb2JqCjw8L1Byb2R1Y2VyKGlUZXh0U2hhcnAgNS4xLjEgXChjXCkgMVQzWFQgQlZCQSkvQ3JlYXRpb25EYXRlKEQ6MjAyMDEyMTAwMjI2NDctMDgnMDAnKS9Nb2REYXRlKEQ6MjAyMDEyMTAwMjI2NDctMDgnMDAnKT4+CmVuZG9iagp4cmVmCjAgMjMKMDAwMDAwMDAwMCA2NTUzNSBmIAowMDAwMDAwMzAzIDAwMDAwIG4gCjAwMDAwMDAwMTUgMDAwMDAgbiAKMDAwMDAwNjcxMSAwMDAwMCBuIAowMDAwMDAwMTQyIDAwMDAwIG4gCjAwMDAwMDMxOTUgMDAwMDAgbiAKMDAwMDAwMzI0MyAwMDAwMCBuIAowMDAwMDAzMzMyIDAwMDAwIG4gCjAwMDAwMDM0MjYgMDAwMDAgbiAKMDAwMDAwMzUyMyAwMDAwMCBuIAowMDAwMDAzNjI0IDAwMDAwIG4gCjAwMDAwMDM3MTIgMDAwMDAgbiAKMDAwMDAwMzgwNSAwMDAwMCBuIAowMDAwMDAzOTAxIDAwMDAwIG4gCjAwMDAwMDQwMDEgMDAwMDAgbiAKMDAwMDAwNDA5MyAwMDAwMCBuIAowMDAwMDA0MTg0IDAwMDAwIG4gCjAwMDAwMDQyNzcgMDAwMDAgbiAKMDAwMDAwNDM3NCAwMDAwMCBuIAowMDAwMDA0OTk2IDAwMDAwIG4gCjAwMDAwMDUzNjMgMDAwMDAgbiAKMDAwMDAwNjc3NCAwMDAwMCBuIAowMDAwMDA2ODIwIDAwMDAwIG4gCnRyYWlsZXIKPDwvU2l6ZSAyMy9Sb290IDIxIDAgUi9JbmZvIDIyIDAgUi9JRCBbPDE4MWQwOGQ1ODljNmJmYzNlZWIzZDA5YzdlODYwZTZkPjw5ZDIzMjY2MjExY2EyMTQ4NzJjNmUwYmJhMGQwOWU1Yj5dPj4Kc3RhcnR4cmVmCjY5NTYKJSVFT0YK';
        insert orderObj;
    
   ccrz__E_OrderItem__c orderItemObj = new ccrz__E_OrderItem__c();
        orderItemObj.ccrz__Price__c = 10.00;
        orderItemObj.ccrz__Quantity__c = 5;
        orderItemObj.ccrz__SubAmount__c = 50.00;
        orderItemObj.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj.ccrz__OrderItemStatus__c = 'Return Approved';
        orderItemObj.dbu_Shipto__c = true;
        orderItemObj.dbu_Reason_for_Return__c = 'Damaged in shipping'; 
        orderItemObj.ccrz__Order__c = orderObj.Id;
        orderItemObj.ccrz__Product__c = productObj.Id;
        orderItemObj.ccrz__OrderItemId__c = cartItemObj.id;
        orderItemObj.dbu_Estimated_Return_Amount__c = 50.00;
        orderItemObj.dbu_store_language__c = 'US';
        insert orderItemObj;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.End_Point__c =  'https://api-ue-devnf3-aw-ex.cummins.com:443/api/core-security-api/v1/auth/token';
            conDetails.Key__c = '54ed575c-9a70-4f17-ad3c-a2c02a146cf0';
            conDetails.Passcode__c =  'O.4HVa0.g68Qo_A7QZVIG6i0sEpE5~.Yi5';
            conDetails.Method_Type__c = 'POST';
            conDetails.Name = 'dbu_ShipStation_AccessToken';
        insert conDetails;
        
          CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
            conDetails1.End_Point__c =  'https://api-ue-devnf5-aw-ex.cummins.com:443/cmi/om/v1/shipments/label';
            conDetails1.Method_Type__c = 'POST';
            conDetails1.grant_type__c = 'application/json';
        	conDetails1.Key__c = '54ed575c-9a70-4f17-ad3c-a2c02a146cf0';
        	conDetails1.Passcode__c =  'O.4HVa0.g68Qo_A7QZVIG6i0sEpE5~.Yi5';
            conDetails1.Name = 'dbu_Shipstation';
        insert conDetails1;
        
        EmailTemplate emailTemplate = new EmailTemplate();
        emailTemplate.isActive = true;
        emailTemplate.Name = 'dbu Return Documents';
        emailTemplate.DeveloperName = 'dbu_Return_Documents';
        emailTemplate.TemplateType = 'text';
        
        ccrz__E_Order__c order =[SELECT Id,ccrz__CurrencyISOCode__c,ccrz__OrderDate__c,dbu_Shipping_Label__c ,ccrz__BuyerEmail__c,ccrz__BuyerCompanyName__c,ccrz__BuyerFirstName__c,ccrz__BuyerMobilePhone__c,ccrz__BuyerPhone__c,ccrz__BuyerLastName__c,ccrz__User__c,dbu_Shipto__c,ccrz__Contact__c,ccrz__ShipTo__r.ccrz__FirstName__c,ccrz__ShipTo__r.ccrz__LastName__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,
                     ccrz__ShipTo__r.ccrz__CompanyName__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c, ccrz__ShipTo__r.ccrz__City__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__PostalCode__c,
                     ccrz__ShipTo__r.ccrz__Country__c,ccrz__ShipTo__r.ccrz__HomePhone__c,Name,(SELECT Id,ccrz__Order__r.ccrz__CurrencyISOCode__c,ccrz__Price__c,dbu_Reason_for_Return__c,dbu_IsShippingLabelSent__c,dbu_Dropoff_Location__c,dbu_Estimated_Return_Amount__c,ccrz__Quantity__c,ccrz__Product_Name__c,dbu_Shipto__c,ccrz__Product__c,ccrz__OrderItemStatus__c,ccrz__Order__c
                                                                                               FROM ccrz__E_OrderItems__r WHERE Id=:orderItemObj.id ) FROM ccrz__E_Order__c where id=:orderObj.id];
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.identity@cummins.com'];
        emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu Return Documents'];
        List<dbu_OrderItemShippingLabelEmailData> emailDataList = new List<dbu_OrderItemShippingLabelEmailData>();
        dbu_OrderItemShippingLabelEmailData emailData = new dbu_OrderItemShippingLabelEmailData();
        emailData.orderObject = order;
        emailData.template = emailTemplate;
        emailData.owea = owea;
        emailData.localData = 'US';
        emailData.pdf_ShippingIns = 'test';
        emailDataList.add(emailData);
        
        dbu_ProcessShippingLabelEmail processEmail = new dbu_ProcessShippingLabelEmail(emailDataList);
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new dbu_Integration_ShipStation_Mock());
        ID jobID = System.enqueueJob(processEmail);
        Test.stopTest();//
    }
    @isTest public static void sendMailTest1(){
        
        ccrz__E_Product__c productObj = dbu_TestDataCreationUtility.createProduct();
        insert productObj;
        
        ccrz__E_ContactAddr__c  ShipFromAddr = new ccrz__E_ContactAddr__c();
        ShipFromAddr.ccrz__AddressFirstline__c = '2815 Exposition Blvd';
        ShipFromAddr.ccrz__AddressSecondline__c = 'Ste 2353242';
        ShipFromAddr.ccrz__AddressThirdline__c = null;
        ShipFromAddr.ccrz__City__c = 'Austin';
        ShipFromAddr.ccrz__State__c = 'TX';
        ShipFromAddr.ccrz__PostalCode__c = '78703';
        ShipFromAddr.ccrz__Country__c = 'US';
        insert ShipFromAddr;
        
        ccrz__E_Cart__c cartObj = dbu_TestDataCreationUtility.createCart();
        insert cartObj;
        
        ccrz__E_CartItem__c cartItemObj = dbu_TestDataCreationUtility.createCartItem(productObj.Id,cartObj.Id);
        insert cartItemObj;
        
        Id iamRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Contact contactObj = new Contact();
        contactObj.FirstName = 'Test';
        contactObj.LastName = 'Test';
        contactObj.Email = 'test@test.com';
        contactObj.Username__c  = 'ranadip@test.com';
        contactObj.IAM_Contact_Status__c = 'Active';
        contactObj.RecordTypeId = iamRecordTypeId;
        insert contactObj;
        
        ccrz__E_Order__c orderObj = new ccrz__E_Order__c();
        orderObj.ccrz__Name__c = 'My Cart';
        orderObj.ccrz__OrderNumber__c = 1253656;
        orderObj.ccrz__Storefront__c = 'CSSNAStore';
        orderObj.ccrz__OrderStatus__c = 'Delivered';
        orderObj.ccrz__CurrencyISOCode__c = 'USD';
        orderObj.ccrz__BuyerFirstName__c = 'name';
        orderObj.ccrz__BuyerLastName__c = '';
        orderObj.ccrz__BuyerEmail__c = 'test@test.com';
        orderObj.ccrz__BuyerPhone__c = '123456789';
        orderObj.ccrz__Contact__c = contactObj.Id;
        orderObj.ccrz__OrderDate__c= System.today();
        //orderObj.ccrz__Storefront__c ='CSSNAStore';
        orderObj.ccrz__OriginatedCart__c=cartObj.Id;
        //orderObj.ccrz__BillTo__c =billingAddr;
        orderObj.ccrz__ShipTo__c =ShipFromAddr.Id;
        orderObj.dbu_IsShippingLabelSent__c = false;
        orderObj.dbu_Shipping_Label__c = '';
        insert orderObj;
    
   ccrz__E_OrderItem__c orderItemObj = new ccrz__E_OrderItem__c();
        orderItemObj.ccrz__Price__c = 10.00;
        orderItemObj.ccrz__Quantity__c = 5;
        orderItemObj.ccrz__SubAmount__c = 50.00;
        orderItemObj.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj.ccrz__OrderItemStatus__c = 'Return Approved';
        orderItemObj.dbu_Shipto__c = false;
        orderItemObj.dbu_Reason_for_Return__c = 'Damaged in shipping'; 
        orderItemObj.ccrz__Order__c = orderObj.Id;
        orderItemObj.ccrz__Product__c = productObj.Id;
        orderItemObj.ccrz__OrderItemId__c = cartItemObj.id;
        orderItemObj.dbu_Estimated_Return_Amount__c = 50.00;
        orderItemObj.dbu_Dropoff_Location__c = 'Cummins Sales & Service - Fairbanks,Fairbanks,1921 Sanduri Avenue,AK,U.S.A,99701';
        orderItemObj.dbu_store_language__c = 'US';
        insert orderItemObj;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.End_Point__c =  'https://api-ue-devnf3-aw-ex.cummins.com:443/api/core-security-api/v1/auth/token';
            conDetails.Key__c = '54ed575c-9a70-4f17-ad3c-a2c02a146cf0';
            conDetails.Passcode__c =  'O.4HVa0.g68Qo_A7QZVIG6i0sEpE5~.Yi5';
            conDetails.Method_Type__c = 'POST';
            conDetails.Name = 'dbu_ShipStation_AccessToken';
        insert conDetails;
        
          CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
            conDetails1.End_Point__c =  'https://api-ue-devnf5-aw-ex.cummins.com:443/cmi/om/v1/shipments/label';
            conDetails1.Method_Type__c = 'POST';
            conDetails1.grant_type__c = 'application/json';
        	conDetails1.Key__c = '54ed575c-9a70-4f17-ad3c-a2c02a146cf0';
        	conDetails1.Passcode__c =  'O.4HVa0.g68Qo_A7QZVIG6i0sEpE5~.Yi5';
            conDetails1.Name = 'dbu_Shipstation';
        insert conDetails1;
        
        EmailTemplate emailTemplate = new EmailTemplate();
        emailTemplate.isActive = true;
        emailTemplate.Name = 'dbu Return Documents';
        emailTemplate.DeveloperName = 'dbu_Return_Documents';
        emailTemplate.TemplateType = 'text';
        
        ccrz__E_Order__c order =[SELECT Id,ccrz__CurrencyISOCode__c,ccrz__OrderDate__c,dbu_Shipping_Label__c ,ccrz__BuyerEmail__c,ccrz__BuyerCompanyName__c,ccrz__BuyerFirstName__c,ccrz__BuyerMobilePhone__c,ccrz__BuyerPhone__c,ccrz__BuyerLastName__c,ccrz__User__c,dbu_Shipto__c,ccrz__Contact__c,ccrz__ShipTo__r.ccrz__FirstName__c,ccrz__ShipTo__r.ccrz__LastName__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,
                     ccrz__ShipTo__r.ccrz__CompanyName__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c, ccrz__ShipTo__r.ccrz__City__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__PostalCode__c,
                     ccrz__ShipTo__r.ccrz__Country__c,ccrz__ShipTo__r.ccrz__HomePhone__c,Name,(SELECT Id,ccrz__Order__r.ccrz__CurrencyISOCode__c,ccrz__Price__c,dbu_Reason_for_Return__c,dbu_IsShippingLabelSent__c,dbu_Dropoff_Location__c,dbu_Estimated_Return_Amount__c,ccrz__Quantity__c,ccrz__Product_Name__c,dbu_Shipto__c,ccrz__Product__c,ccrz__OrderItemStatus__c,ccrz__Order__c
                                                                                               FROM ccrz__E_OrderItems__r WHERE Id=:orderItemObj.id ) FROM ccrz__E_Order__c where id=:orderObj.id];
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.identity@cummins.com'];
        emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu Return Documents'];
        List<dbu_OrderItemShippingLabelEmailData> emailDataList = new List<dbu_OrderItemShippingLabelEmailData>();
        dbu_OrderItemShippingLabelEmailData emailData = new dbu_OrderItemShippingLabelEmailData();
        emailData.orderObject = order;
        emailData.template = emailTemplate;
        emailData.owea = owea;
        emailData.localData = 'US';
        emailData.pdf_ShippingIns = 'test';
        emailDataList.add(emailData);
        
        dbu_ProcessShippingLabelEmail processEmail = new dbu_ProcessShippingLabelEmail(emailDataList);
        Test.startTest();
        ID jobID = System.enqueueJob(processEmail);
        Test.stopTest();
    }
    
    @isTest public static void sendMailTest2(){
        
        ccrz__E_Product__c productObj = dbu_TestDataCreationUtility.createProduct();
        insert productObj;
        
        ccrz__E_ContactAddr__c  ShipFromAddr = new ccrz__E_ContactAddr__c();
        ShipFromAddr.ccrz__AddressFirstline__c = '2815 Exposition Blvd';
        ShipFromAddr.ccrz__AddressSecondline__c = 'Ste 2353242';
        ShipFromAddr.ccrz__AddressThirdline__c = null;
        ShipFromAddr.ccrz__City__c = 'Austin';
        ShipFromAddr.ccrz__State__c = 'TX';
        ShipFromAddr.ccrz__PostalCode__c = '78703';
        ShipFromAddr.ccrz__Country__c = 'CA';
        insert ShipFromAddr;
        
        ccrz__E_Cart__c cartObj = dbu_TestDataCreationUtility.createCart();
        insert cartObj;
        
        ccrz__E_CartItem__c cartItemObj = dbu_TestDataCreationUtility.createCartItem(productObj.Id,cartObj.Id);
        insert cartItemObj;
        
        Id iamRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Contact contactObj = new Contact();
        contactObj.FirstName = 'Test';
        contactObj.LastName = 'Test';
        contactObj.Email = 'test@test.com';
        contactObj.Username__c  = 'ranadip@test.com';
        contactObj.IAM_Contact_Status__c = 'Active';
        contactObj.RecordTypeId = iamRecordTypeId;
        insert contactObj;
        
        ccrz__E_Order__c orderObj = new ccrz__E_Order__c();
        orderObj.ccrz__Name__c = 'My Cart';
        orderObj.ccrz__OrderNumber__c = 1253656;
        orderObj.ccrz__Storefront__c = 'CSSNAStore';
        orderObj.ccrz__OrderStatus__c = 'Delivered';
        orderObj.ccrz__CurrencyISOCode__c = 'CAD';
        orderObj.ccrz__BuyerFirstName__c = 'name';
        orderObj.ccrz__BuyerLastName__c = '';
        orderObj.ccrz__BuyerEmail__c = 'test@test.com';
        orderObj.ccrz__BuyerPhone__c = '123456789';
        orderObj.ccrz__Contact__c = contactObj.Id;
        orderObj.ccrz__OrderDate__c= System.today();
        //orderObj.ccrz__Storefront__c ='CSSNAStore';
        orderObj.ccrz__OriginatedCart__c=cartObj.Id;
        //orderObj.ccrz__BillTo__c =billingAddr;
        orderObj.ccrz__ShipTo__c =ShipFromAddr.Id;
        orderObj.dbu_IsShippingLabelSent__c = false;
        orderObj.dbu_Shipping_Label__c = '';
        insert orderObj;
    
   ccrz__E_OrderItem__c orderItemObj = new ccrz__E_OrderItem__c();
        orderItemObj.ccrz__Price__c = 10.00;
        orderItemObj.ccrz__Quantity__c = 5;
        orderItemObj.ccrz__SubAmount__c = 50.00;
        orderItemObj.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj.ccrz__OrderItemStatus__c = 'Return Approved';
        orderItemObj.dbu_Shipto__c = false;
        orderItemObj.dbu_Reason_for_Return__c = 'Incorrect part was received'; 
        orderItemObj.ccrz__Order__c = orderObj.Id;
        orderItemObj.ccrz__Product__c = productObj.Id;
        orderItemObj.ccrz__OrderItemId__c = cartItemObj.id;
        orderItemObj.dbu_Estimated_Return_Amount__c = 50.00;
        orderItemObj.dbu_Dropoff_Location__c = 'Cummins Sales & Service - Fairbanks,Fairbanks,1921 Sanduri Avenue,AK,U.S.A,99701';
        orderItemObj.dbu_store_language__c = 'FR';
        insert orderItemObj;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.End_Point__c =  'https://api-ue-devnf3-aw-ex.cummins.com:443/api/core-security-api/v1/auth/token';
            conDetails.Key__c = '54ed575c-9a70-4f17-ad3c-a2c02a146cf0';
            conDetails.Passcode__c =  'O.4HVa0.g68Qo_A7QZVIG6i0sEpE5~.Yi5';
            conDetails.Method_Type__c = 'POST';
            conDetails.Name = 'dbu_ShipStation_AccessToken';
        insert conDetails;
        
          CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
            conDetails1.End_Point__c =  'https://api-ue-devnf5-aw-ex.cummins.com:443/cmi/om/v1/shipments/label';
            conDetails1.Method_Type__c = 'POST';
            conDetails1.grant_type__c = 'application/json';
        	conDetails1.Key__c = '54ed575c-9a70-4f17-ad3c-a2c02a146cf0';
        	conDetails1.Passcode__c =  'O.4HVa0.g68Qo_A7QZVIG6i0sEpE5~.Yi5';
            conDetails1.Name = 'dbu_Shipstation';
        insert conDetails1;
        
        EmailTemplate emailTemplate = new EmailTemplate();
        emailTemplate.isActive = true;
        emailTemplate.Name = 'dbu Return Documents';
        emailTemplate.DeveloperName = 'dbu_Return_Documents';
        emailTemplate.TemplateType = 'text';
        
        ccrz__E_Order__c order =[SELECT Id,ccrz__CurrencyISOCode__c,ccrz__OrderDate__c,dbu_Shipping_Label__c ,ccrz__BuyerEmail__c,ccrz__BuyerCompanyName__c,ccrz__BuyerFirstName__c,ccrz__BuyerMobilePhone__c,ccrz__BuyerPhone__c,ccrz__BuyerLastName__c,ccrz__User__c,dbu_Shipto__c,ccrz__Contact__c,ccrz__ShipTo__r.ccrz__FirstName__c,ccrz__ShipTo__r.ccrz__LastName__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,
                     ccrz__ShipTo__r.ccrz__CompanyName__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c, ccrz__ShipTo__r.ccrz__City__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__PostalCode__c,
                     ccrz__ShipTo__r.ccrz__Country__c,ccrz__ShipTo__r.ccrz__HomePhone__c,Name,(SELECT Id,ccrz__Order__r.ccrz__CurrencyISOCode__c,ccrz__Price__c,dbu_Reason_for_Return__c,dbu_IsShippingLabelSent__c,dbu_Dropoff_Location__c,dbu_Estimated_Return_Amount__c,ccrz__Quantity__c,ccrz__Product_Name__c,dbu_Shipto__c,ccrz__Product__c,ccrz__OrderItemStatus__c,ccrz__Order__c
                                                                                               FROM ccrz__E_OrderItems__r WHERE Id=:orderItemObj.id ) FROM ccrz__E_Order__c where id=:orderObj.id];
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.identity@cummins.com'];
        emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu Return Documents'];
        List<dbu_OrderItemShippingLabelEmailData> emailDataList = new List<dbu_OrderItemShippingLabelEmailData>();
        dbu_OrderItemShippingLabelEmailData emailData = new dbu_OrderItemShippingLabelEmailData();
        emailData.orderObject = order;
        emailData.template = emailTemplate;
        emailData.owea = owea;
        emailData.localData = 'FR';
        emailData.pdf_ShippingIns = 'test';
        emailData.shippingInstructions ='';
        emailDataList.add(emailData);
        
        dbu_ProcessShippingLabelEmail processEmail = new dbu_ProcessShippingLabelEmail(emailDataList);
        Test.startTest();
        ID jobID = System.enqueueJob(processEmail);
        Test.stopTest();
    }
    @isTest public static void sendMailTest3(){
        
        ccrz__E_Product__c productObj = dbu_TestDataCreationUtility.createProduct();
        insert productObj;
        
        ccrz__E_ContactAddr__c  ShipFromAddr = new ccrz__E_ContactAddr__c();
        ShipFromAddr.ccrz__AddressFirstline__c = '2815 Exposition Blvd';
        ShipFromAddr.ccrz__AddressSecondline__c = 'Ste 2353242';
        ShipFromAddr.ccrz__AddressThirdline__c = null;
        ShipFromAddr.ccrz__City__c = 'Austin';
        ShipFromAddr.ccrz__State__c = 'TX';
        ShipFromAddr.ccrz__PostalCode__c = '78703';
        ShipFromAddr.ccrz__Country__c = 'CA';
        insert ShipFromAddr;
        
        ccrz__E_Cart__c cartObj = dbu_TestDataCreationUtility.createCart();
        insert cartObj;
        
        ccrz__E_CartItem__c cartItemObj = dbu_TestDataCreationUtility.createCartItem(productObj.Id,cartObj.Id);
        insert cartItemObj;
        
        Id iamRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Contact contactObj = new Contact();
        contactObj.FirstName = 'Test';
        contactObj.LastName = 'Test';
        contactObj.Email = 'test@test.com';
        contactObj.Username__c  = 'ranadip@test.com';
        contactObj.IAM_Contact_Status__c = 'Active';
        contactObj.RecordTypeId = iamRecordTypeId;
        insert contactObj;
        
        ccrz__E_Order__c orderObj = new ccrz__E_Order__c();
        orderObj.ccrz__Name__c = 'My Cart';
        orderObj.ccrz__OrderNumber__c = 1253656;
        orderObj.ccrz__Storefront__c = 'CSSNAStore';
        orderObj.ccrz__OrderStatus__c = 'Delivered';
        orderObj.ccrz__CurrencyISOCode__c = 'CAD';
        orderObj.ccrz__BuyerFirstName__c = 'name';
        orderObj.ccrz__BuyerLastName__c = '';
        orderObj.ccrz__BuyerEmail__c = 'test@test.com';
        orderObj.ccrz__BuyerPhone__c = '123456789';
        orderObj.ccrz__Contact__c = contactObj.Id;
        orderObj.ccrz__OrderDate__c= System.today();
        //orderObj.ccrz__Storefront__c ='CSSNAStore';
        orderObj.ccrz__OriginatedCart__c=cartObj.Id;
        //orderObj.ccrz__BillTo__c =billingAddr;
        orderObj.ccrz__ShipTo__c =ShipFromAddr.Id;
        orderObj.dbu_IsShippingLabelSent__c = false;
        orderObj.dbu_Shipping_Label__c = 'JVBERi0xLjQKJeLjz9MKMiAwIG9iago8PC9MZW5ndGggNjEvRmlsdGVyL0ZsYXRlRGVjb2RlPj5zdHJlYW0KeJwr5HIK4TI2UzC2NFMISeFyDeEK5CpUMFQwAEJDBV1jIz1LIGlsqGekkJyroB+RZqjgkq8QyAUARuULswplbmRzdHJlYW0KZW5kb2JqCjQgMCBvYmoKPDwvVHlwZS9QYWdlL01lZGlhQm94WzAgMCAyODggNDMyXS9SZXNvdXJjZXM8PC9Qcm9jU2V0IFsvUERGIC9UZXh0IC9JbWFnZUIgL0ltYWdlQyAvSW1hZ2VJXS9YT2JqZWN0PDwvWGYxIDEgMCBSPj4+Pi9Db250ZW50cyAyIDAgUi9QYXJlbnQgMyAwIFI+PgplbmRvYmoKMSAwIG9iago8PC9MZW5ndGggMjUxNS9GaWx0ZXJbL0FTQ0lJODVEZWNvZGUvRmxhdGVEZWNvZGVdL1Jlc291cmNlczw8L1Byb2NTZXQgNSAwIFIvRm9udDw8L0YxIDYgMCBSL0YyIDcgMCBSL0YzIDggMCBSL0Y0IDkgMCBSL0Y1IDEwIDAgUi9GNiAxMSAwIFIvRjcgMTIgMCBSL0Y4IDEzIDAgUi9GOSAxNCAwIFIvRjEwIDE1IDAgUi9GMTEgMTYgMCBSL0YxMiAxNyAwIFI+Pi9YT2JqZWN0PDwvRmVkRXhHcm91bmQgMTggMCBSL0dyb3VuZEcgMTkgMCBSL2JhcmNvZGUwIDIwIDAgUj4+Pj4vVHlwZS9YT2JqZWN0L1N1YnR5cGUvRm9ybS9CQm94WzAgMCA2MTIgNzkyXS9NYXRyaXhbMSAwIDAgMSAwIDBdL0Zvcm1UeXBlIDE+PnN0cmVhbQpHYXQ9Lj8jTlwmJnErXFRzJ1RQSTVbI2NtUVgrMW9RQjZqQ24yXV9TaSNzYSlBMGs5MG0uKiQvclVrTVJWYFJLSUhBSzIuNysnOGlrSTxdXAowJidmIVoqWDRlT3BIJWE4b0NyUy44O05dW2VSczJfVChUP3EvV28nPl1COUkhOUwlNi5LMlUtIktTLVRnLlI0ZWBJbDNBVTA3TTNUdSFpMQpba00+RF47dFBmNksuTiU8RVJhYWFGZFRlMD9pN20tU00pVl1YUm43QF8hUUBuNnM2KXE7KGwiPzUrQTwnYDVSPVMoQ3JBQCRaPEBrTWtnSgpEXV5WclMmOCNkNTN0YCZbUlJDNVNKZkohU1RmRTgmVD0nOT1JR2Q7JkQ5VzsoX0QjPlRMIltKayltT3BkP25oQmtSPE5ZI10zPGdNNiwsJQoodVY9ISthUzZMb0ZPcFdWXElXRkdkRF5DYmVgJCFadTRfYz4/TlA0KGQnbEI4VHIiXzUnZCJKOWFcMjhqLGMqYSExaWpBOi5iI2A4M1plXwpgKmhadHEvXj5sQ28+K3NuYWtwOnBkV000J0NbVTlwcjFRPmFpRE5kVFIhcl5kR2BFZ2dDLSxHNSg3MG86Pyk1OjRUXzVZNm9iITlpY0lQLgpyOFJDYCxkYStKWT9wKD9LOyxSI1RdU2Q9aFhQYEtVWkpRTDAkQSswX0RdT0Fobk9YO3B0O2IrLCsqK2peU2tFUVlMVGhzWUtZRDFIQVNIKwo4Jz1FSm1gMFFQYXBvSnBoYFFJXEcrck49KlVaRkFBYWVVSlpZKm1YSHVaTVVcXWs3a0sqV2lBa08vKjlvOGZOWVJhbyNHQjQmb3FjUUNCcgptKXRITm4nQjQrb0IsaGVVTDBAZ3JBNWQqMDMoZSNJWEtuNjglNlRcbjlUQSNdTyUpaGdLLGNHZWBuNlBlaWB0QnAlN0BwIjdwMz4tYl0iNwpaJ1piRGZhc1wxOWR1WGkxXGM1O2hlPmtRXkdZZEEhOi9hJ0gkcyhqJ0MwUFBsIWcwV2NZXDJqSmI6QU8uQUNnLm11bGVJJFBSY2JtbD9pQApyYTVPXmorPE1FX0JxbmMrI1k7LWArPz0sV086LWQ1Sz5iLzR0UV9bbyZcam1QMzslPG5VJS0lPD1YX2tyOFBYaEFiSUonVElIO2VoMz8ubwpiYE5PczhMQ0dXOkZhS0ptI1l1ZUImaT1CZEJeX3JhPkZwLU5kME1Wa1ZqOlZMPDUnJFg1a2pccylFK2NWJj1iOzpUaFdkPlo8QUIwZ0UqXwpsXihcZUVdLVVbWSdqYmYjaGNiaTtvbS48amgpNSJOQTpPO2JyI21DJDM7SDZNaUlhYXBaO0BtTEdPOyU4OCRUNERJTVNdS29NOEhyJzs2Ogpecmtbaj5EMFlCUShbbD9eSGhGdGswSGIkL0AkdXU3TzpBNXFYX3VWPj9jaG5daDknbEhmSkJfaT1OOjcuIzg4bkhrc2RvVyNhZm80LF9YWwoibW5XXlE0YzhuSCZUIWdiQSdDN0MnTj1VZyd0TD4rcilGUyIrWyM9IkN1W0dXUE9TSlBVOWBSWkdhUiZIJF9qZVh0LWptPjpnJS5mLDg1PwpaYS1GITo1XiZKI1Q2JUxUaSUhXClUblhKS0JpbGgtWE5USGVQSlo8YTlTJjo4I1hDZCQ+RTNIRWM/ZSxkUycnRjJeaj5jZjljRlMxUWlOVQpHWG5eT049J1puamQoOWJqSl0sYyRRR0BuYj5vUCk2a24xQ2onKDYyJjZZSCxuVkRwUSYvMDJOQXE3Y3NANEk8ZTBpPmYwbHEwLk5fM21cbgplTW9kOzJBMmNgbU9JVmAjKWFMYVJqODZtM0I1KWEvRjRDUigtIWlLaFNTM0E3dCIiQyZqP0M7LnNVOFNWSENKVFVsZyI4Vy5CcDRhaVBlZwpjOyNaaDo7KzNmaWVFMDZgPiswJE0qaVRUOXI4W2IuYD9MJmA/UF0sYl9KXE9WJXUkT1JGJF8mSWEvX1IwKHVkMWFqXkFeJytbMUVkTSI8SQpGV1wzJFc8SjtjS29LRidyO11TTmA7WGpuSlx0TXNsQmgpXk9iPS08SUFtRTFSTU9OZUxaMCxwNi5eUl9cJWxFJC8tdSYjLVY1Li5HQjpHJApObEVRRT4sQldBVVcuISlXKlMyVyYzQGNOOTA1YHRFN0I6S0NCZi5TOFs0dVMtOko6XmJzLT9ZOSlGLTInN0k/bFMsblgyOm8rcUJUP2hqPApKP0k8UURVXiFpTio7N3ImbT9mJUYxWD88XnNQXEE/Um1OXyVgKGcpIy0sTSEzXFNLVjVELnVZZXVtOi5DZkRhbFJfKytTLj47b0ktZSYzUQpWNTE5amZOJkI7OVhkREhcM1Y6Tj5FQCFqXDdlVT1wNk5UNmkqXFQqLyUnRFBqUllBQG9xYFNiWVouXjcucDBJZ0NKVi8nYmxDNlNMby5HSQplWTlsSCZ1MF5GVWZ1XVQ8TVsjOSgwNThEVUBdKEgidW4qb0NpK20ya3BKZG1rVl1ZJV5wLUFbXFBUYl49USVSJEU3XUxJRFFyVWpvUS1qIQo1aWBVdTU0K2ZnIV85ckU+U0Bya1VJYTg4RmVwIzdZWi5QLVhHIjhUS1BTLnMlPCxFQUNISjc9ViFScjUvMlApWFNGQmJvMiYqWUk3WylPOAo8PTlkKGIlbzcvJT5yYklHPCkvb05gTSRiNkNPTl5gOW5MW0M9ZkkkMywyST9SX2tOYVdaXi1yaT0nW0k+KUJAMSozalxvI1hfQ2VfMlsubwo+XihZRTswNFBkS20lSTJFPiM3KSlTJGRncDlTJXU/LzJBSTkhcT5fLzksQDhdKyowc0UqMTk3bSNDIV5bajlkX0JSdGVXPTYiRSRpM1UwPgpbX1U5VTdHYlNaa3BTRiFkMlw0SGYkOHJrbDF1Y28vVCpDPUJIMFltTjpmcDpAN2o9b18yWiNZS2gyVVBGdDgmYFU9ZUo6NkNVJXRSXyc6Pgo5bFs2O09oPmhhUkc0OiMkZlxxMyFnQlxibGouWSxSc1U3RCRVNlVNT2UiUiRTZipVYUg0PCtaQFl1PEgrMUtqai4oVTV1M2ZKSF9tQjtfcQosb0tqNGUlM2ZsM0tSJWhyLE0xdC5XLyY/QGktRSolUCQmLiJKU2tVJ1hUZSU1S0E6ZzsyOmVXZlEiVi8jaHJRTFA8Wzw/WEJgY1ZWK1BrYQpuNm9kZFxVX3MxKVtuTEZZVUwjX0c5P0RaU0xcLG5VU1BPSW0pUUJZYkJKZUlEZFxdSy1EK0tdMHJLNUgxNy1ubG9ObSIoUmI4LEU1OFRUTAo+UX4+CmVuZHN0cmVhbQplbmRvYmoKNSAwIG9iagpbL1BERi9UZXh0L0ltYWdlQi9JbWFnZUMvSW1hZ2VJXQplbmRvYmoKNiAwIG9iago8PC9UeXBlL0ZvbnQvU3VidHlwZS9UeXBlMS9CYXNlRm9udC9IZWx2ZXRpY2EvRW5jb2RpbmcvTWFjUm9tYW5FbmNvZGluZz4+CmVuZG9iago3IDAgb2JqCjw8L1R5cGUvRm9udC9TdWJ0eXBlL1R5cGUxL0Jhc2VGb250L0hlbHZldGljYS1Cb2xkL0VuY29kaW5nL01hY1JvbWFuRW5jb2Rpbmc+PgplbmRvYmoKOCAwIG9iago8PC9UeXBlL0ZvbnQvU3VidHlwZS9UeXBlMS9CYXNlRm9udC9IZWx2ZXRpY2EtT2JsaXF1ZS9FbmNvZGluZy9NYWNSb21hbkVuY29kaW5nPj4KZW5kb2JqCjkgMCBvYmoKPDwvVHlwZS9Gb250L1N1YnR5cGUvVHlwZTEvQmFzZUZvbnQvSGVsdmV0aWNhLUJvbGRPYmxpcXVlL0VuY29kaW5nL01hY1JvbWFuRW5jb2Rpbmc+PgplbmRvYmoKMTAgMCBvYmoKPDwvVHlwZS9Gb250L1N1YnR5cGUvVHlwZTEvQmFzZUZvbnQvQ291cmllci9FbmNvZGluZy9NYWNSb21hbkVuY29kaW5nPj4KZW5kb2JqCjExIDAgb2JqCjw8L1R5cGUvRm9udC9TdWJ0eXBlL1R5cGUxL0Jhc2VGb250L0NvdXJpZXItQm9sZC9FbmNvZGluZy9NYWNSb21hbkVuY29kaW5nPj4KZW5kb2JqCjEyIDAgb2JqCjw8L1R5cGUvRm9udC9TdWJ0eXBlL1R5cGUxL0Jhc2VGb250L0NvdXJpZXItT2JsaXF1ZS9FbmNvZGluZy9NYWNSb21hbkVuY29kaW5nPj4KZW5kb2JqCjEzIDAgb2JqCjw8L1R5cGUvRm9udC9TdWJ0eXBlL1R5cGUxL0Jhc2VGb250L0NvdXJpZXItQm9sZE9ibGlxdWUvRW5jb2RpbmcvTWFjUm9tYW5FbmNvZGluZz4+CmVuZG9iagoxNCAwIG9iago8PC9UeXBlL0ZvbnQvU3VidHlwZS9UeXBlMS9CYXNlRm9udC9UaW1lcy1Sb21hbi9FbmNvZGluZy9NYWNSb21hbkVuY29kaW5nPj4KZW5kb2JqCjE1IDAgb2JqCjw8L1R5cGUvRm9udC9TdWJ0eXBlL1R5cGUxL0Jhc2VGb250L1RpbWVzLUJvbGQvRW5jb2RpbmcvTWFjUm9tYW5FbmNvZGluZz4+CmVuZG9iagoxNiAwIG9iago8PC9UeXBlL0ZvbnQvU3VidHlwZS9UeXBlMS9CYXNlRm9udC9UaW1lcy1JdGFsaWMvRW5jb2RpbmcvTWFjUm9tYW5FbmNvZGluZz4+CmVuZG9iagoxNyAwIG9iago8PC9UeXBlL0ZvbnQvU3VidHlwZS9UeXBlMS9CYXNlRm9udC9UaW1lcy1Cb2xkSXRhbGljL0VuY29kaW5nL01hY1JvbWFuRW5jb2Rpbmc+PgplbmRvYmoKMTggMCBvYmoKPDwvVHlwZS9YT2JqZWN0L1N1YnR5cGUvSW1hZ2UvV2lkdGggMTE4L0hlaWdodCA0Ny9Db2xvclNwYWNlL0RldmljZUdyYXkvQml0c1BlckNvbXBvbmVudCA4L0xlbmd0aCA0NTAvRmlsdGVyWy9BU0NJSTg1RGVjb2RlL0ZsYXRlRGVjb2RlXT4+c3RyZWFtCkdiIi9lSkldUj8jWG5MZ1Q2PGRmL0kuJj9CPWhjRGFnLXJENF0wJVBmTVRaK2BRU0krSl1DXiZyRDNBOGxNOG5uRkZQIUkuZipqWUMyVG5bCjw3aSg3XDxKSCE8dVZ1bTNISmZrPDgpKyVaTipNZi1zJWw+VlpVQ3MsOWA5b1cmVE0lL2NnbUpVJS5mTGhiSSQnPkJndV9pQFErQyZiV3I2CjNEQ002L0ZVTXQsREJeLCpSMDBzIl1XRkdDMGo6I1dhNGdXPCpRZVQ7LD87QlMhb3J1NXUkXzNCMmpcMkMuJ2IuRlhxQFgxQSosYVxTYUdKCjpuTWtjSVFcLkpmOjA1N18tTDRKPCUyUU1tSWFvQFw4OEZLR2IxcCxtVzslLkhOQy47Vi4rYGQpczpyQmhVakxIQlgyUkNeOV9xODFuVltLCkw9MlFCRnQ7clRDbjZbZnBtcHI3U19jRyFkV1ssc1gxKys4UjwpLSVGY1Uua1JwV1MpWEU7OSs7NGxTK182QXNyY0ViUUxjSUVjXzslTUtFCjNjakdUOSpOW0oucE4yV21JOFc/JGw7YzZdNWQvP3A4dDxzRWFKMmVybCt+PgplbmRzdHJlYW0KZW5kb2JqCjE5IDAgb2JqCjw8L1R5cGUvWE9iamVjdC9TdWJ0eXBlL0ltYWdlL1dpZHRoIDU0L0hlaWdodCA1NC9Db2xvclNwYWNlL0RldmljZUdyYXkvQml0c1BlckNvbXBvbmVudCA4L0xlbmd0aCAxOTYvRmlsdGVyWy9BU0NJSTg1RGVjb2RlL0ZsYXRlRGVjb2RlXT4+c3RyZWFtCkdiIjBPM3UzPmgkcS9NMEooJVM3LEt1WTwtcy5sSC0ncUVTKHBST0hDclBuJDdaOSlhNiJMUidTI29DNToiRWxoTCQyMyUyPzpfJ2xjWS90CjkmQzQvTkByT1tbRSdqYmBzPlw6UHBqbTU8QyxNPSZYO28sQVFqbWZha0ptRyQwRHBUPGAvV0hDSUtkaDhwPDBrSTI/YWFVaUlMMVczIkMhCjZEZDY2bCw+V15IW2YuPSQpckxuVGlTZkk0M0A5STxXfj4KZW5kc3RyZWFtCmVuZG9iagoyMCAwIG9iago8PC9UeXBlL1hPYmplY3QvU3VidHlwZS9JbWFnZS9XaWR0aCAyOTQvSGVpZ2h0IDU4L0NvbG9yU3BhY2UvRGV2aWNlR3JheS9CaXRzUGVyQ29tcG9uZW50IDgvTGVuZ3RoIDExNzUvRmlsdGVyWy9BU0NJSTg1RGVjb2RlL0ZsYXRlRGVjb2RlXT4+c3RyZWFtCkdiIi9jPWAyLDIkcSxDQDkyPy5lWmQ6PjkhMyxmXihKI1InLCVockEhck0+amNjTipdXz1jQ2ZmL20+SGhsP0VXVEBaQVgwTENdLnBIIl5eCm8zZUlxUHRZIlVlYytiaUk6bVI3WzlYL1pDYlBGLUt0YGZOYlleIi40QTBCO3JAT2wzLFZyKEhiPyIzQisxSElrMCdhO2ZyRSVQX1BVTlJMCkNKcy5rKUppRUVAOSdYND1yNVxPbllOVVdyZTZMZkM7aTIpa2J1YztDKTNbV09idTo7NkZzZ3VeWHRQSUVwWGkmOytNIkZnKFlgXmlHN1pDClcyNmtjOi9fTUddXjlfMW0/TCQ9KiRjTDU6c2svM0liMF4mJnN0THRtTF9hOGw6Jl5JVGRgXC82WEdSbD8kOiE0L1ojZTwxYDw1MF0hJ11SCmxnLWRVNko1aHNJNzJqOyFsaF5qaT4vWT9bT3ImbGVqbDtuPXJAMkYwZVUpJlFJOFcmcCtXQVtORVA+VDwwVi9oQDtrZU9bayhYXTk4XEtNCk8lLkptLFpZSUY1N1gvY3JqLFI3X3UrOlA4a1xDa1YyZzZuPkc/JVdLcihzJClrN1pILlEuUUwwR3FBI1stWzIkXW5BLkNRbmJNaEBLPyksCjRlVnJuW1ptKis7K19rKF1MPDpSKmNscHQ0PjJmSlRCVmNuSEU1JHRZPWorWlBXXz5XPGZgS21gQWZCTUpoLjFOaClSbEkuNHFCW1BpLzlnCj1ASDYlI0ArZSZXIjBVRF0zXSctNEhnQzAsTHItTFA+dClNPC5IQmlVZTleaUFWK1k9RlkwR2RGSW5ZWSNZS0tBSz1nNHJWP0AhXT8nNzolCnJFZCROUFghVi8sOnBpcyMxcjVPVk0qMSRQYTlgcDhvW18pXydTV0MiXWUpMjEvLHAlYkpfP0w4aEpRbGZySy5VUDIjM1lRcU1WN1BhOWBoCjhuMEZGN1toamYuISNgXyEnOHNINzgsMGtOZWRcVl9nJz00RCVsNm41JldHTDk+U2g8YCRQNWleNkZyMzsrX2xNPChXKGBnZGpYTitdKjIiCllnXEZZVk4xODtaLW10bT1fL3JZXSdOTlJzMjk5MVpCVVsnQmhHLE01JTZiYClwOjkvOjNjXk5NKF8oblEqZ3NWJnFqMVgpYFlYXUYwbjFuClxfX1ljJSo0I09Zb1xPYGRTYCwlQmhYOllRPyZhVkkwYDVrRmFTJ01AVVlFVCdPQzhJSEN1QVItUToiK1I/RjhkQEYxUmcrRlomM1FJOFpXCihTck8/JkYwLXUpR1hfW19vMF9ULT1JVyYsSDpwYiZCR288JnIsUlhIV208MzBsKShhcWJLKCddVlchInJlJEEiMFRvJGktUUwzZVRuWyhoCjBNOEQyIWpXK1leZzRqV01AOj1oLi4zaTk6cWlYKF5aPVRiYnNWPUYvPl0xYlFyOWtNUFk+N0A8YVwxa0tOIlFNZE11RmpPUypFI0BcWXByCkQ6I0chPSZhMTdaRW5eSWtGZjdMSG1wWUReU0o2X3BXaihAIXVmKX4+CmVuZHN0cmVhbQplbmRvYmoKMyAwIG9iago8PC9UeXBlL1BhZ2VzL0NvdW50IDEvS2lkc1s0IDAgUl0vSVRYVCg1LjEuMSk+PgplbmRvYmoKMjEgMCBvYmoKPDwvVHlwZS9DYXRhbG9nL1BhZ2VzIDMgMCBSPj4KZW5kb2JqCjIyIDAgb2JqCjw8L1Byb2R1Y2VyKGlUZXh0U2hhcnAgNS4xLjEgXChjXCkgMVQzWFQgQlZCQSkvQ3JlYXRpb25EYXRlKEQ6MjAyMDEyMTAwMjI2NDctMDgnMDAnKS9Nb2REYXRlKEQ6MjAyMDEyMTAwMjI2NDctMDgnMDAnKT4+CmVuZG9iagp4cmVmCjAgMjMKMDAwMDAwMDAwMCA2NTUzNSBmIAowMDAwMDAwMzAzIDAwMDAwIG4gCjAwMDAwMDAwMTUgMDAwMDAgbiAKMDAwMDAwNjcxMSAwMDAwMCBuIAowMDAwMDAwMTQyIDAwMDAwIG4gCjAwMDAwMDMxOTUgMDAwMDAgbiAKMDAwMDAwMzI0MyAwMDAwMCBuIAowMDAwMDAzMzMyIDAwMDAwIG4gCjAwMDAwMDM0MjYgMDAwMDAgbiAKMDAwMDAwMzUyMyAwMDAwMCBuIAowMDAwMDAzNjI0IDAwMDAwIG4gCjAwMDAwMDM3MTIgMDAwMDAgbiAKMDAwMDAwMzgwNSAwMDAwMCBuIAowMDAwMDAzOTAxIDAwMDAwIG4gCjAwMDAwMDQwMDEgMDAwMDAgbiAKMDAwMDAwNDA5MyAwMDAwMCBuIAowMDAwMDA0MTg0IDAwMDAwIG4gCjAwMDAwMDQyNzcgMDAwMDAgbiAKMDAwMDAwNDM3NCAwMDAwMCBuIAowMDAwMDA0OTk2IDAwMDAwIG4gCjAwMDAwMDUzNjMgMDAwMDAgbiAKMDAwMDAwNjc3NCAwMDAwMCBuIAowMDAwMDA2ODIwIDAwMDAwIG4gCnRyYWlsZXIKPDwvU2l6ZSAyMy9Sb290IDIxIDAgUi9JbmZvIDIyIDAgUi9JRCBbPDE4MWQwOGQ1ODljNmJmYzNlZWIzZDA5YzdlODYwZTZkPjw5ZDIzMjY2MjExY2EyMTQ4NzJjNmUwYmJhMGQwOWU1Yj5dPj4Kc3RhcnR4cmVmCjY5NTYKJSVFT0YK';
        insert orderObj;
    
   ccrz__E_OrderItem__c orderItemObj = new ccrz__E_OrderItem__c();
        orderItemObj.ccrz__Price__c = 10.00;
        orderItemObj.ccrz__Quantity__c = 5;
        orderItemObj.ccrz__SubAmount__c = 50.00;
        orderItemObj.ccrz__StoreId__c = 'CSSNAStore';
        orderItemObj.ccrz__OrderItemStatus__c = 'Return Approved';
        orderItemObj.dbu_Shipto__c = true;
        orderItemObj.dbu_Reason_for_Return__c = 'Incorrect part was received'; 
        orderItemObj.ccrz__Order__c = orderObj.Id;
        orderItemObj.ccrz__Product__c = productObj.Id;
        orderItemObj.ccrz__OrderItemId__c = cartItemObj.id;
        orderItemObj.dbu_Estimated_Return_Amount__c = 50.00;
        //orderItemObj.dbu_Dropoff_Location__c = 'Ventes et service Cummins - Montrose,Montrose,2121 Route 152,Prince Edward Island,Canada,C0B 1B0';
        orderItemObj.dbu_store_language__c = 'US';
        insert orderItemObj;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.End_Point__c =  'https://api-ue-devnf3-aw-ex.cummins.com:443/api/core-security-api/v1/auth/token';
            conDetails.Key__c = '54ed575c-9a70-4f17-ad3c-a2c02a146cf0';
            conDetails.Passcode__c =  'O.4HVa0.g68Qo_A7QZVIG6i0sEpE5~.Yi5';
            conDetails.Method_Type__c = 'POST';
            conDetails.Name = 'dbu_ShipStation_AccessToken';
        insert conDetails;
        
          CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
            conDetails1.End_Point__c =  'https://api-ue-devnf5-aw-ex.cummins.com:443/cmi/om/v1/shipments/label';
            conDetails1.Method_Type__c = 'POST';
            conDetails1.grant_type__c = 'application/json';
        	conDetails1.Key__c = '54ed575c-9a70-4f17-ad3c-a2c02a146cf0';
        	conDetails1.Passcode__c =  'O.4HVa0.g68Qo_A7QZVIG6i0sEpE5~.Yi5';
            conDetails1.Name = 'dbu_Shipstation';
        insert conDetails1;
        
        EmailTemplate emailTemplate = new EmailTemplate();
        emailTemplate.isActive = true;
        emailTemplate.Name = 'dbu Return Documents';
        emailTemplate.DeveloperName = 'dbu_Return_Documents';
        emailTemplate.TemplateType = 'text';
        
        ccrz__E_Order__c order =[SELECT Id,ccrz__CurrencyISOCode__c,ccrz__OrderDate__c,dbu_Shipping_Label__c ,ccrz__BuyerEmail__c,ccrz__BuyerCompanyName__c,ccrz__BuyerFirstName__c,ccrz__BuyerMobilePhone__c,ccrz__BuyerPhone__c,ccrz__BuyerLastName__c,ccrz__User__c,dbu_Shipto__c,ccrz__Contact__c,ccrz__ShipTo__r.ccrz__FirstName__c,ccrz__ShipTo__r.ccrz__LastName__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,
                     ccrz__ShipTo__r.ccrz__CompanyName__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c, ccrz__ShipTo__r.ccrz__City__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__PostalCode__c,
                     ccrz__ShipTo__r.ccrz__Country__c,ccrz__ShipTo__r.ccrz__HomePhone__c,Name,(SELECT Id,ccrz__Order__r.ccrz__CurrencyISOCode__c,ccrz__Price__c,dbu_Reason_for_Return__c,dbu_IsShippingLabelSent__c,dbu_Dropoff_Location__c,dbu_Estimated_Return_Amount__c,ccrz__Quantity__c,ccrz__Product_Name__c,dbu_Shipto__c,ccrz__Product__c,ccrz__OrderItemStatus__c,ccrz__Order__c
                                                                                               FROM ccrz__E_OrderItems__r WHERE Id=:orderItemObj.id ) FROM ccrz__E_Order__c where id=:orderObj.id];
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.identity@cummins.com'];
        emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu Return Documents'];
        List<dbu_OrderItemShippingLabelEmailData> emailDataList = new List<dbu_OrderItemShippingLabelEmailData>();
        dbu_OrderItemShippingLabelEmailData emailData = new dbu_OrderItemShippingLabelEmailData();
        emailData.orderObject = order;
        emailData.template = emailTemplate;
        emailData.owea = owea;
        emailData.localData = 'EN';
        emailData.pdf_ShippingIns = 'test';
        emailData.shippingInstructions ='CORE';
        emailDataList.add(emailData);
        
        dbu_ProcessShippingLabelEmail processEmail = new dbu_ProcessShippingLabelEmail(emailDataList);
        Test.startTest();
        ID jobID = System.enqueueJob(processEmail);
        Test.stopTest();
    }
} //uat deployment