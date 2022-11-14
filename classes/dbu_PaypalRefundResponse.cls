public class dbu_PaypalRefundResponse {

    public class Refund_from_transaction_fee {
        public String currency1;
        public String value;
    }

    public class Amount {
        public String total;
        public String currency1;
    }

    public class Links {
        public String href;
        public String rel;
        public String method;
    }

        public String id;
        public String create_time;
        public String update_time;
        public String state;
        public Amount amount;
        public Refund_from_transaction_fee refund_from_transaction_fee;
        public Refund_from_transaction_fee total_refunded_amount;
        public Refund_from_transaction_fee refund_from_received_amount;
        public String sale_id;
        public String parent_payment;
        public List<Links> links;
    

    
    public static Dbu_PaypalRefundResponse parse(String json) {
        return (Dbu_PaypalRefundResponse) System.JSON.deserialize(json, Dbu_PaypalRefundResponse.class);
    }
}