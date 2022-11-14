@isTest
global class dbu_Integration_InventoryMockGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        List<Dbu_InventoryWrapper> test = new List<Dbu_InventoryWrapper>();
        Dbu_InventoryWrapper.Item itemRec = new Dbu_InventoryWrapper.Item();
        itemRec.availableQuantity = '2';
        itemRec.availableQuantityDownOrder = '3';
        itemRec.partNumber='4';
        itemRec.warehouse='5';
        
        List<Dbu_InventoryWrapper.Item> itemList = new List<Dbu_InventoryWrapper.Item>();
        itemList.add(itemRec);
        
        Dbu_InventoryWrapper.Items itemsValue = new Dbu_InventoryWrapper.Items();
        itemsValue.item = itemList;
        
        Dbu_InventoryWrapper.Inventory inv= new Dbu_InventoryWrapper.Inventory();
        inv.items = itemsValue;
         
        res.setHeader('Content-Type', 'application/json');
       // res.setBody(json.serialize(inv));
       res.setBody('[{"Inventory": {"items": {"item": [{"availableQuantity": "690","availableQuantityDownOrder": "0","partNumber": "391577200","warehouse": "MEM"},{"availableQuantity": "10040","availableQuantityDownOrder": "0","partNumber": "391577200","warehouse": "IRD"},{"availableQuantity": "21","availableQuantityDownOrder": "0","partNumber": "391577200","warehouse": "DRD"},{"availableQuantity": "21","availableQuantityDownOrder": "0","partNumber": "391577200","warehouse": "PRD"},{"availableQuantity": "23","availableQuantityDownOrder": "0","partNumber": "391577200","warehouse": "ARD"},{"availableQuantity": "10","availableQuantityDownOrder": "0","partNumber": "391577200","warehouse": "HRD"}]}}}]');
        res.setStatusCode(200);
        return res;
    }
}