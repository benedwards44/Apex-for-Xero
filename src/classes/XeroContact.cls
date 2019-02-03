/**
* @author       Ben Edwards (ben@benedwards.co.nz)
* @description  Wrapper class to hold details for a Xero Contact
**/
public class XeroContact {

	public String ContactID {get; set;}
	public String ContactStatus {get; set;}
	public String Name {get; set;}
	public String FirstName {get; set;}
	public String LastName {get; set;}
	public String EmailAddress {get; set;}
	public String BankAccountDetails {get; set;}
	public String SkypeUserName {get; set;}
	public XeroAddress[] Addresses {get; set;}
	public XeroPhone[] Phones {get; set;}
	public String UpdatedDateUTC {get; set;}
	public XeroContactGroup[] ContactGroups {get; set;}
	public Boolean IsSupplier {get; set;}
	public Boolean IsCustomer {get; set;}
	public String DefaultCurrency {get; set;}
	public XeroBalance Balances {get; set;}
	public XeroContactPerson[] ContactPersons {get; set;}
	public Boolean HasAttachments {get; set;}
	public XeroAttachment[] Attachments {get; set;}
	public Boolean HasValidationErrors {get; set;}

	public class XeroContactGroup {
	}

	public class XeroContactPerson {

		public String FirstName {get; set;}
		public String LastName {get; set;}
		public String EmailAddress {get; set;}
		public Boolean IncludeInEmails {get; set;}
	}

	public class XeroBalance {

		public AccountsPayable AccountsPayable {get; set;}
		public AccountsReceivable AccountsReceivable {get; set;}
	}

	public class AccountsPayable {
		public Decimal Overdue {get; set;}	//0
		public Decimal Outstanding {get; set;}	//0
	}

	public class AccountsReceivable {
		public Decimal Overdue {get; set;}	//2625
		public Decimal Outstanding {get; set;}	//2625
	}

	public class XeroAttachment {

		public String AttachmentID {get; set;}
		public String FileName {get; set;}
		public String Url {get; set;}
		public String MimeType {get; set;}
		public Integer ContentLength {get; set;}
	}
}