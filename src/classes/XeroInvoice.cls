/**
* @author Ben Edwards (ben@edwards.nz)
* @date 3rd February 2020
* @description Wrapper class for serialising and de-serialising Xero Invoices
*
* CHANGE LOG
**/
public class XeroInvoice {

    public XeroInvoice() {}
    
    public String Type;	//ACCREC
	public String InvoiceID;	//94b8a8d6-31fd-4d8c-8791-d1a2a7dfe898
	public String InvoiceNumber;	//asdsdasd 
	public String Reference;	//ABC123
    public XeroContact Contact;
    public String Date_x;	//2019-08-20T00:00:00
	public String DueDate;	//2019-08-20T00:00:00

	public Boolean SentToContact;
    public Decimal AmountDue;	//115
	public Decimal AmountPaid;	//0
	public Decimal AmountCredited;	//0
	public Decimal CurrencyRate;	//1
	public Boolean IsDiscounted;
	public Boolean HasAttachments;
	public Boolean HasErrors;
	
	public String Status;	//AUTHORISED
	public String LineAmountTypes;	//Exclusive
	public Decimal SubTotal;	//100
	public Decimal TotalTax;	//15
	public Decimal Total;	//115
	public String UpdatedDateUTC;	///Date(1566260876040+0000)/
	public String CurrencyCode;	//NZD
    public String Url;
    
    public List<LineItem> LineItems;
    public List<Payment> Payments;
	public List<CreditNote> CreditNotes;
	public List<PrePayment> Prepayments;
	public List<OverPayment> Overpayments;
	public List<TrackingCategory> TrackingCategorys;

    public List<XeroValidationError> ValidationErrors;

	public class Payment {}

	public class CreditNote {}

	public class PrePayment {}

	public class OverPayment {}

	public class LineItem {

        public String LineItemID;	//006fc261-ee0b-4f4c-bb55-c96ca97cdb53
        public String Description;	//Some Stufff
        public String AccountCode;	//200
        public String TaxType;	//OUTPUT2
		public Decimal UnitAmount;	//100
		public Decimal TaxAmount;	//15
		public Decimal LineAmount;	//100
		public Decimal Quantity;	//1
        public List<TrackingCategory> Tracking;
		public List<XeroValidationError> ValidationErrors;
	}

    public class TrackingCategory {

        public String Name;
        public String Option;
        
        public TrackingCategory(String name, String option) {
            this.Name = name;
            this.Option = option;
        }
	}
	
	public XeroInvoice(String xeroContactId) {

		// Pass in default values here
		this.Type = 'ACCREC';

		// Set the parent account
		this.Contact = new XeroContact(xeroContactId);
	}

    public String serialize() {
        
        // Serialise the full XeroInvoice object into a string
        String serialized = JSON.serialize(this, true);

        // Replace the _x with the correct format
        serialized = serialized.replace('"Date_x"', '"Date"');

        return serialized;
    }
}