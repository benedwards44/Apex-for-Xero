/**
* @author       Ben Edwards (ben@benedwards.co.nz)
* @description  Test class for the Xero API methods
**/
@isTest
public class XeroAccountingApiTest {

	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Test a successful callout of the getContacts() method
	**/
	@isTest
	static void getContactsSuccess () {

		// Set the Mock Class for the callout
		Test.setMock(HttpCalloutMock.class, getStaticMock(200, 'XeroContactsMock'));

		Test.startTest();

		// Execute the callout
		List<XeroContact> xeroContacts = XeroAccountingApi.getContacts();

		Test.stopTest();

		// Assert that a contact exists
		system.assertEquals(
			1,
			xeroContacts.size(),
			'There should be one contact returned from the callout'
		);
	}


	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Test an unsuccessful callout of the getContacts() method
	**/
	@isTest
	static void getContactsFail () {

		// Set the Mock Class for the callout
		Test.setMock(HttpCalloutMock.class, getStaticMock(500, 'XeroContactsMock'));

		Test.startTest();

		// Execute the callout
		try {

			List<XeroContact> xeroContacts = XeroAccountingApi.getContacts();
		} 
		catch (Exception ex) {

			// Error expected, as failed callout raises an exception
			system.assert(
				String.valueOf(ex).contains('500'),
				'The 500 error code should be contained in the string.'
			);
		}

		Test.stopTest();
	}

	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Test a successful callout of the createContact() method
	**/
	@isTest
	static void createContactSuccess () {

		// Set the Mock Class for the callout
		Test.setMock(HttpCalloutMock.class, getStaticMock(200, 'XeroContactsMock'));

		Test.startTest();

		// Execute the callout
		XeroContact createdContact = XeroAccountingApi.createContact('<Contact><Name>Test Contact</Name></Contact>');

		Test.stopTest();

		// Assert that a contact exists
		system.assertNotEquals(
			null,
			createdContact,
			'The contact should be created and not null.'
		);
	}


	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Test an unsuccessful callout of the createContact() method
	**/
	@isTest
	static void createContactsFail () {

		// Set the Mock Class for the callout
		Test.setMock(HttpCalloutMock.class, getStaticMock(500, 'XeroContactsMock'));

		Test.startTest();

		// Execute the callout
		try {

			XeroContact createdContact = XeroAccountingApi.createContact('<Contact><Name>Test Contact</Name></Contact>');
		} 
		catch (Exception ex) {

			// Error expected, as failed callout raises an exception
			system.assert(
				String.valueOf(ex).contains('500'),
				'The 500 error code should be contained in the string.'
			);
		}

		Test.stopTest();
	}

	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Test a successful callout of the getInvoices() method
	**/
	@isTest
	static void getInvoicesSuccess() {

		// Set the Mock Class for the callout
		Test.setMock(HttpCalloutMock.class, getStaticMock(200, 'XeroInvoicesMock'));

		Test.startTest();

		// Execute the callout
		List<XeroInvoice> xeroInvoices = XeroAccountingApi.getInvoices();

		Test.stopTest();

		system.debug('### ' + xeroInvoices);

		// Assert that a contact exists
		system.assertEquals(
			1,
			xeroInvoices.size(),
			'There should be one invoice returned from the callout'
		);
	}


	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Test an unsuccessful callout of the getInvoices() method
	**/
	@isTest
	static void getInvoicesFail() {

		// Set the Mock Class for the callout
		Test.setMock(HttpCalloutMock.class, getStaticMock(500, 'XeroInvoicesMock'));

		Test.startTest();

		// Execute the callout
		try {

			List<XeroInvoice> xeroInvoices = XeroAccountingApi.getInvoices();
		} 
		catch (Exception ex) {

			// Error expected, as failed callout raises an exception
			system.assert(
				String.valueOf(ex).contains('500'),
				'The 500 error code should be contained in the string.'
			);
		}

		Test.stopTest();
	}

	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Test a successful callout of the createInvoice() method
	**/
	@isTest
	static void createInvoiceSuccess() {

		// Set the Mock Class for the callout
		Test.setMock(HttpCalloutMock.class, getStaticMock(200, 'XeroInvoicesMock'));

		Test.startTest();

		// Execute the callout
		XeroInvoice createdInvoice = XeroAccountingApi.createInvoice('<Invoice>BODY</Invoice>');

		Test.stopTest();

		// Assert that a contact exists
		system.assertNotEquals(
			null,
			createdInvoice,
			'There should be one invoice created from the callout'
		);
	}


	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Test an unsuccessful callout of the createInvoice() method
	**/
	@isTest
	static void createInvoiceFail() {

		// Set the Mock Class for the callout
		Test.setMock(HttpCalloutMock.class, getStaticMock(500, 'XeroInvoicesMock'));

		Test.startTest();

		// Execute the callout
		try {

			XeroInvoice createdInvoice = XeroAccountingApi.createInvoice('<Invoice>BODY</Invoice>');
		} 
		catch (Exception ex) {

			// Error expected, as failed callout raises an exception
			system.assert(
				String.valueOf(ex).contains('500'),
				'The 500 error code should be contained in the string.'
			);
		}

		Test.stopTest();
	}

	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Test scenario where no Xero Settings can be found
	**/
	@isTest
	static void getXeroSettingsError() {

		// Delete the Xero Settings created
		delete [Select Id From Xero_Settings__c];

		// Assert no Xero Settings found in Utility
		system.assertEquals(
			null,
			XeroCalloutUtility.xeroSettings.Id,
			'There should be no Xero Setting record found.'
		);

	}


	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Test an unsuccessful callout of the getContacts() method
	**/
	private static StaticResourceCalloutMock getStaticMock (Integer responseCode, String mockName) {

		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource(mockName);
		mock.setStatusCode(responseCode);
		mock.setHeader('Content-Type', 'application/json');

		return mock;
	}


	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Create test data for the method
	**/
	@testSetup
	static void setupTestData () {

		// Create a test Xero Setting record
		insert new Xero_Settings__c(
			SetupOwnerId = Userinfo.getOrganizationId(),
			Consumer_Key__c = '123456789',
			Endpoint__c = 'https://api.xero-test.com?param1=value1&param2=value2/'
		);

	}
	
}