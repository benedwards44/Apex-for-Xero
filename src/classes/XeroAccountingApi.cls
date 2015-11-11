/**
* Author:       Ben Edwards
* Date:         2015-11-10
* Description:  Class to handle API calls for the Xero Accounting API resources
**/
public with sharing class XeroAccountingApi {

	/**
	*	Method to return ALL contacts for your Xero environment
	**/
	public static List<XeroContact> getContacts () {

		List<XeroContact> xeroContacts = new List<XeroContact>();

		// Execute the callout to the Contacts GET resource
		HttpResponse response = XeroCalloutUtility.executeCallout('Contacts');

		// If successful response
		if (response.getStatusCode() == 200) {

			// Parse JSON response into class objects
			xeroContacts = (List<XeroContact>) JSON.deserialize(response.getBody(), List<XeroContact>.class);
		}
		else {

			// Raise error
			throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
		}

		return xeroContacts;
	}


	/**
	*	Method to return ALL invoices for your Xero environment
	**/
	public static List<XeroInvoice> getInvoices () {

		List<XeroInvoice> xeroInvoices = new List<XeroInvoice>();

		// Execute the callout to the Contacts GET resource
		HttpResponse response = XeroCalloutUtility.executeCallout('Invoices');

		// If successful response
		if (response.getStatusCode() == 200) {

			// Parse JSON response into class objects
			xeroInvoices = (List<XeroInvoice>) JSON.deserialize(response.getBody(), List<XeroInvoice>.class);
		}
		else {

			// Raise error
			throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
		}

		return xeroInvoices;
	}


	/**
	*	Custom exception class to handle response errors
	**/
	public class XeroAccountingApiException extends Exception {}

}