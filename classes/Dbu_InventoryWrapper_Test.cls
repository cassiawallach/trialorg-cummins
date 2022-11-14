@isTest
public class Dbu_InventoryWrapper_Test {
    public static testMethod void invWrapper(){
        Dbu_InventoryWrapper test = new Dbu_InventoryWrapper();
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
        
        
        test.Inventory = inv;
        
        String s = '[{"Inventory": {"items": {"item": [{"availableQuantity": "690","availableQuantityDownOrder": "0","partNumber": "391577200","warehouse": "MEM"},{"availableQuantity": "10040","availableQuantityDownOrder": "0", "partNumber":"391577200",  "warehouse": "IRD"},  {   "availableQuantity": "21","availableQuantityDownOrder": "0", "partNumber": "391577200",  "warehouse": "DRD"  }, { "availableQuantity": "21", "availableQuantityDownOrder": "0", "partNumber": "391577200","warehouse": "PRD"  },  { "availableQuantity": "23", "availableQuantityDownOrder": "0", "partNumber": "391577200", "warehouse": "ARD"}, { "availableQuantity": "10","availableQuantityDownOrder": "0",  "partNumber": "391577200",            "warehouse": "HRD"  } ]} }  }]';
                
        Dbu_InventoryWrapper.parse(s);
        
        
        
    }
}