/**
* @author       Ben Edwards (ben@benedwards.co.nz)
* @description  Wrapper class to hold details for a Xero Invoice
**/
public class XeroInvoice {

	public String Type;	//ACCREC
	public String InvoiceID;	//920cce71-7495-4c93-a2d3-e4cf9b91a781
	public String InvoiceNumber;	//INV-0002
	public String Reference;	//
	public Payment[] Payments;
	public CreditNote[] CreditNotes;
	public PrePayment[] Prepayments;
	public Overpayment[] Overpayments;
	public Decimal AmountDue;	//600
	public Decimal AmountPaid;	//0
	public Boolean SentToContact;
	public Decimal CurrencyRate;	//1
	public Boolean HasErrors;
	public Boolean IsDiscounted;
	public XeroContact Contact;
	public String DateString;	//2015-12-01T00:00:00
	public String DueDateString;	//2015-12-31T00:00:00
	public String Status;	//DRAFT
	public String LineAmountTypes;	//Exclusive
	public LineItem[] LineItems;
	public Decimal SubTotal;	//600
	public Decimal TotalTax;	//0
	public Decimal Total;	//600
	public String UpdatedDateUTC;	///Date(1447665863507+1300)/
	public String CurrencyCode;	//NZD
	public cls_Warnings[] Warnings;

	class Payment {
	}
	class CreditNote {
	}
	class PrePayment {
	}
	class Overpayment {
	}
	class cls_ContactGroups {
	}
	class cls_SalesTrackingCategories {
	}
	class cls_PurchasesTrackingCategories {
	}
	class cls_PaymentTerms {
		public cls_Bills Bills;
	}
	class cls_Bills {
		public Integer Day;	//1
		public String Type;	//OFFOLLOWINGMONTH
	}
	class cls_ContactPersons {
	}
	class LineItem {
		public String ItemCode;
		public String Description;	//Consulting services as agreed
		public Decimal UnitAmount;	//120
		public String TaxType;	//NONE
		public Decimal TaxAmount;	//0
		public Decimal LineAmount;	//600
		public String AccountCode;	//200
		public cls_Tracking[] Tracking;
		public Decimal Quantity;	//5
		public String LineItemID;	//0d129d0d-4b3a-4567-afc5-0453f3457175
		public cls_ValidationErrors[] ValidationErrors;
	}
	class cls_Tracking {
	}
	class cls_ValidationErrors {
	}
	class cls_Warnings {
	}
	
}