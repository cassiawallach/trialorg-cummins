public class Dbu_InventoryWrapper {

	public class Item {
		public String availableQuantity;
		public String availableQuantityDownOrder;
		public String partNumber;
		public String warehouse;
		public String errors;
	}

	public Inventory Inventory;

	public class Items {
		public List<Item> item;
	}

	public class Inventory {
		public Items items;
	}

	
	public static List<Dbu_InventoryWrapper> parse(String json) {
		return (List<Dbu_InventoryWrapper>) System.JSON.deserialize(json, List<Dbu_InventoryWrapper>.class);
	}
}