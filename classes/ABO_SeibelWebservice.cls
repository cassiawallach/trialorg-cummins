Global Class ABO_SeibelWebservice
{
    @future(Callout=true)
    public static void sendSMS(String phone,String message)
    {
        siebelComAsi.CDOSSMS cdos = new siebelComAsi.CDOSSMS();
        cdos.timeout_x=120000;
        cdos.inputHttpHeaders_x= new Map<String,String>();
        //cdos.inputHttpHeaders_x.put('Content-Type', 'text/xml; charset=utf-8');
        cdos.inputHttpHeaders_x.put('ocp-apim-subscription-key', system.label.ABO_Sibel_Subscription_key);
        String msg2='hi this message is with OTP';
        cdos.SendSMS(phone,message);
    }
}