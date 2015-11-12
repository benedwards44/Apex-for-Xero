/**
* Author:       Ben Edwards
* Date:         2015-11-10
* Description:  Wrapper class to hold details for a Xero Contact
**/
public class XeroContact {

	public String ContactID;
	public String ContactStatus;
	public String Name;
	public String FirstName;
	public String LastName;
	public String EmailAddress;
	public String BankAccountDetails;
	public XeroAddress[] Addresses;
	public XeroPhone[] Phones;
	public String UpdatedDateUTC;
	public ContactGroups[] ContactGroups;
	public Boolean IsSupplier;
	public Boolean IsCustomer;
	public String DefaultCurrency;
	public ContactPersons[] ContactPersons;
	public Boolean HasAttachments;
	public Boolean HasValidationErrors;

	class ContactGroups {
	}

	class ContactPersons {
	}

}