public class DBU_ReturnPaypalWrpr {

    public class Payer {
        public String payment_method;
    }

    public class Transactions {
        public Amount amount;
        public String description;
        public String custom;
        public String invoice_number;
        public String soft_descriptor;
        public Payment_options payment_options;
        public Item_list item_list;
        public List<Related_resources> related_resources;
    }

    public class Details {
        public String subtotal;
        public String tax;
        public String shipping;
        public String insurance;
        public String handling_fee;
        public String shipping_discount;
    }

    public String id;
    public String intent;
    public String state;
    public Payer payer;
    public List<Transactions> transactions;
    public String note_to_payer;
    public String create_time;
    public List<Links> links;

    public class Item_list {
        public List<Items> items;
        public Shipping_address shipping_address;
    }

    public class Amount {
        public String total;
        public String currency1;
        public Details details;
    }

    public class Payment_options {
        public String allowed_payment_method;
        public Boolean recurring_flag;
        public Boolean skip_fmf;
    }

    public class Related_resources {
    }

    public class Links {
        public String href;
        public String rel;
        public String method;
    }

    public class Items {
        public String name;
        public String sku;
        public String description;
        public String price;
        public String currency1;
        public String tax;
        public Integer quantity;
    }

    public class Shipping_address {
        public String recipient_name;
        public String line1;
        public String line2;
        public String city;
        public String state;
        public String postal_code;
        public String country_code;
        public String phone;
    }

    
    public static DBU_ReturnPaypalWrpr parse(String json) {
        return (DBU_ReturnPaypalWrpr) System.JSON.deserialize(json, DBU_ReturnPaypalWrpr.class);
    }
}