public class DBU_RequestPaypalWrpr {

    public class Payer {
        public String payment_method;
    }

    public class Transactions {
        public Amount amount;
        public String description;
        public String custom;
        public String invoice_number;
        public Payment_options payment_options;
        public String soft_descriptor;
        public Item_list item_list;
    }

    public class Details {
        public String subtotal;
        public String tax;
        public String shipping;
        public String handling_fee;
        public String shipping_discount;
        public String insurance;
    }

    public String intent;
    public Payer payer;
    public List<Transactions> transactions;
    public String note_to_payer;
    public Redirect_urls redirect_urls;

    public class Item_list {
        public List<Items> items;
        public Shipping_address shipping_address;
    }

    public class Amount {
        public String total;
        public String currency1;
        public Details details;
    }

    public class Redirect_urls {
        public String return_url;
        public String cancel_url;
    }

    public class Payment_options {
        public String allowed_payment_method;
    }

    public class Items {
        public String name;
        public String description;
        public String quantity;
        public String price;
        public String tax;
        public String sku;
        public String currency1;
    }

    public class Shipping_address {
        public String recipient_name;
        public String line1;
        public String line2;
        public String city;
        public String country_code;
        public String postal_code;
        public String phone;
        public String state;
    }

    
    public static DBU_RequestPaypalWrpr parse(String json) {
        return (DBU_RequestPaypalWrpr) System.JSON.deserialize(json, DBU_RequestPaypalWrpr.class);
    }
}