/**
* @author       Ben Edwards (ben@benedwards.co.nz)
* @description  Wrapper class to hold details for a Xero Contact
**/
public class XeroContact {

	public String ContactID;
	public String ContactStatus;
	public String Name;
	public String FirstName;
	public String LastName;
	public String EmailAddress;
	public String BankAccountDetails;
	public String SkypeUserName;
	public XeroAddress[] Addresses;
	public XeroPhone[] Phones;
	public String UpdatedDateUTC;
	public ContactGroups[] ContactGroups;
	public Boolean IsSupplier;
	public Boolean IsCustomer;
	public String DefaultCurrency;
	public Balances Balances;
	public ContactPersons[] ContactPersons;
	public Boolean HasAttachments;
	public Attachments[] Attachments;
	public Boolean HasValidationErrors;

	public class ContactGroups {
	}

	public class ContactPersons {

		public String FirstName;
		public String LastName;
		public String EmailAddress;
		public Boolean IncludeInEmails;
	}

	public class Balances {

		public AccountsPayable AccountsPayable;
		public AccountsReceivable AccountsReceivable;
	}

	public class AccountsPayable {
		public Decimal Overdue;	//0
		public Decimal Outstanding;	//0
	}

	public class AccountsReceivable {
		public Decimal Overdue;	//2625
		public Decimal Outstanding;	//2625
	}

	public class Attachments {

		public String AttachmentID;
		public String FileName;
		public String Url;
		public String MimeType;
		public Integer ContentLength;
	}
}