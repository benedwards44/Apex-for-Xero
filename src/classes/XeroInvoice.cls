/**
* @author       Ben Edwards (ben@benedwards.co.nz)
* @description  Wrapper class to hold details for a Xero Invoice
**/
public class XeroInvoice {

	public String Type {get; set;}	//ACCREC
	public String InvoiceID {get; set;}	//920cce71-7495-4c93-a2d3-e4cf9b91a781
	public String InvoiceNumber {get; set;}	//INV-0002
	public String Reference {get; set;}
	public Payment[] Payments {get; set;}
	public CreditNote[] CreditNotes {get; set;}
	public PrePayment[] Prepayments {get; set;}
	public Overpayment[] Overpayments {get; set;}
	public Decimal AmountDue {get; set;}	//600
	public Decimal AmountPaid {get; set;}	//0
	public Boolean SentToContact {get; set;}
	public Decimal CurrencyRate {get; set;}	//1
	public Boolean HasErrors {get; set;}
	public Boolean IsDiscounted {get; set;}
	public XeroContact Contact {get; set;}
	public String Date_x {get; set;}	//2015-12-01T00:00:00
	public String DueDate {get; set;}	//2015-12-31T00:00:00
	public String Status {get; set;}	//DRAFT
	public String LineAmountTypes {get; set;}	//Exclusive
	public LineItem[] LineItems {get; set;}
	public Decimal SubTotal {get; set;}	//600
	public Decimal TotalTax {get; set;}	//0
	public Decimal Total {get; set;}	//600
	public String UpdatedDateUTC {get; set;}	///Date(1447665863507+1300)/
	public String CurrencyCode {get; set;}	//NZD
	public cls_Warnings[] Warnings {get; set;}

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
		public cls_Bills Bills {get; set;}
	}
	class cls_Bills {
		public Integer Day {get; set;}	//1
		public String Type {get; set;}	//OFFOLLOWINGMONTH
	}
	class cls_ContactPersons {
	}
	class LineItem {
		public String ItemCode {get; set;}
		public String Description {get; set;}	//Consulting services as agreed
		public Decimal UnitAmount {get; set;}	//120
		public String TaxType {get; set;}	//NONE
		public Decimal TaxAmount {get; set;}	//0
		public Decimal LineAmount {get; set;}	//600
		public String AccountCode {get; set;}	//200
		public cls_Tracking[] Tracking {get; set;}
		public Decimal Quantity {get; set;}	//5
		public String LineItemID {get; set;}	//0d129d0d-4b3a-4567-afc5-0453f3457175
		public cls_ValidationErrors[] ValidationErrors {get; set;}
	}
	class cls_Tracking {
	}
	class cls_ValidationErrors {
	}
	class cls_Warnings {
	}
	
}
