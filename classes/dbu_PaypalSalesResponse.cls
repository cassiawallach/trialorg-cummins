public class dbu_PaypalSalesResponse {

    public class Payer {
        public String payment_method;
        public String status;
        public Payer_info payer_info;
    }

    public class Sale {
        public String id;
        public String state;
        public Amount amount;
        public String payment_mode;
        public String protection_eligibility;
        public Transaction_fee transaction_fee;
        public String parent_payment;
        public String create_time;
        public String update_time;
        public List<Links> links;
    }

    public class Payer_info {
        public String email;
        public String first_name;
        public String last_name;
        public String payer_id;
        public Shipping_address shipping_address;
        public String country_code;
    }

    public class Item_list {
        public List<Items> items;
        public Shipping_address shipping_address;
        public String shipping_phone_number;
    }

    public class Amount {
        public String total;
        public String currency1;
        public Details details;
    }

    public class Failed_transactions {
    }

    public class Amount_Z {
        public String total;
        public String currency1;
    }

    public class Transactions {
        public Amount amount;
        public Payee payee;
        public String description;
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
        public String discount;
    }

    public class Refund {
        public String id;
        public String state;
        public Amount_Z amount;
        public String parent_payment;
        public String sale_id;
        public String create_time;
        public String update_time;
        public List<Links> links;
    }

    public class Links {
        public String href;
        public String rel;
        public String method;
    }

    public class Related_resources {
        public Sale sale;
        public Refund refund;
    }

    public String id;
    public String intent;
    public String state;
    public String cart;
    public Payer payer;
    public List<Transactions> transactions;
    public List<Failed_transactions> failed_transactions;
    public String create_time;
    public String update_time;
    public List<Links> links;

    public class Items {
        public String name;
        public String sku;
        public String price;
        public String currency1;
        public String tax;
        public Integer quantity;
    }

    public class Transaction_fee {
        public String value;
        public String currency1;
    }

    public class Payee {
        public String merchant_id;
        public String email;
    }

    public class Shipping_address {
        public String recipient_name;
        public String line1;
        public String city;
        public String state;
        public String postal_code;
        public String country_code;
    }

    
    public static dbu_PaypalSalesResponse parse(String json) {
        return (dbu_PaypalSalesResponse) System.JSON.deserialize(json, dbu_PaypalSalesResponse.class);
    }
}