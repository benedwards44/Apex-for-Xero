/**
* @author Ben Edwards (beedwards@deloitte.co.nz)
* @date 20th August 2019
* @description Wrapper class for serialising and de-serialising Xero Purchase ORders
*
* CHANGE LOG
**/
public class XeroPurchaseOrder {
    
    public String PurchaseOrderID;	//44d3f8a4-7031-45e8-b252-e92914e43c7e
    public String PurchaseOrderNumber;	//PO-0001
    public String Date_x;
    public String DeliveryDateString;	//2017-02-22T00:00:00
    public String DeliveryDate;	///Date(1487721600000+0000)/
    public String DeliveryAddress;	//23 Main Street
    public String AttentionTo;	//FOH
    public String Telephone;	//0800 1234 5678
    public String DeliveryInstructions;	//Deliver to reception. As agreed, table needs to be assembled prior to delivery.
    public Boolean IsDiscounted;
    public String Reference;	//710
    public String Type;	//PURCHASEORDER
    public Decimal CurrencyRate;	//1
    public String CurrencyCode;	//NZD
    public String BrandingThemeID;	//7889a0ac-262a-40e3-8a63-9a769b1a18af
    public String Status;	//BILLED
    public String LineAmountTypes;	//Exclusive
    public Decimal SubTotal;	//1000
    public Decimal TotalTax;	//150
    public Decimal Total;	//1150
    public String UpdatedDateUTC;	///Date(1385147725247+0000)/
    public String Url;	///Date(1385147725247+0000)/
    public List<XeroValidationError> ValidationErrors;

    public XeroContact Contact;
    public LineItem[] LineItems;
    
    public class LineItem {
        public String LineItemID;	//1aa3bf00-a5fe-420f-b4b3-d64349a13108
		public String Description;	//Coffee table for reception
		public Decimal UnitAmount;	//1000
		public String TaxType;	//INPUT2
		public Decimal TaxAmount;	//150
		public Decimal LineAmount;	//1000
		public Decimal Quantity;	//1
        public String AccountCode;

        /*
        public LineItem(Purchase_Order_Line__c poLine) {
            this.Description = poLine.Tour_Code__c;
            this.UnitAmount = poLine.Amount__c;
            this.Quantity = 1;
            this.AccountCode = poLine.Account_Code__c;
        }
        */
	}
    
    /*
    public XeroPurchaseOrder(Purchase_Order__c purchaseOrder, String accountXeroId) {

        this.PurchaseOrderID = purchaseOrder.Xero_Id__c;
        this.PurchaseOrderNumber = purchaseOrder.Name;
        this.Date_x = String.valueOf(purchaseOrder.Date__c);
        this.LineAmountTypes = 'Exclusive';
        this.Url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + purchaseOrder.Id;
        this.Contact = new XeroContact(accountXeroId);
        this.Status = 'DRAFT';

        this.LineItems = new List<LineItem>();

        for (Purchase_Order_Line__c poLine :purchaseOrder.Purchase_Order_Lines__r) {

            this.LineItems.add(new LineItem(poLine));
        }
    }
    */

    public String serialize() {
        
        // Serialise the full XeroInvoice object into a string
        String serialized = JSON.serialize(this, true);

        // Replace the _x with the correct format
        serialized = serialized.replace('"Date_x"', '"Date"');

        return serialized;
    }

    // Custom deserialize method to remove the Contact info from
    // the Purchase Order response
    public static String deserialize(String jsonBody) {

        // Cast to array based on response
        List<Object> jsonObjectArray = (List<Object>) JSON.deserializeUntyped(jsonBody);

        // Cast to map/value pair
        Map<String, Object> jsonObject = (Map<String, Object>) jsonObjectArray[0];

        // Remove the Contact object - causing all sorts of problems
        jsonObject.remove('Contact');

        // Re-serialise the string
        return JSON.serialize(jsonObject);
    }
}