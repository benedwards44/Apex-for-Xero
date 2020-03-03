/**
* @author Ben Edwards (ben@edwards.nz)
* @date 3rd February 2020
* @description Test class for the Xero API
**/
@isTest 
public class XeroAPITest {
    
    @isTest 
    static void testGetContact() {

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroContactMock', 200));

        Test.startTest();

        XeroContact xeroContact = XeroAPI.getContact('ABC123');

        Test.stopTest();

        system.assertEquals(
            '10b46b4c-35c1-49c4-a7eb-983ab08ebe1a', 
            xeroContact.ContactID, 
            'Xero Contact ID should be loaded against the response.'
        );
    }
    @isTest 
    static void testGetContact_Error() {

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroContactMock', 301));

        Test.startTest();

        try {
            XeroContact xeroContact = XeroAPI.getContact('');
        } catch (XeroAPI.XeroApiException e) {
            System.assert( e.getMessage().contains('Error retrieving contact: '), e.getMessage() );
        }

        Test.stopTest();
    }

    @isTest 
    static void testGetContacts() {

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroContactMock', 200));

        Test.startTest();

        XeroContact xeroContact = XeroAPI.getContacts()[0];

        Test.stopTest();

        system.assertEquals(
            '10b46b4c-35c1-49c4-a7eb-983ab08ebe1a', 
            xeroContact.ContactID, 
            'Xero Contact ID should be loaded against the response.'
        );
    }

    @isTest 
    static void testGetContacts_Error() {

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroContactMock', 301));

        Test.startTest();

        try {
            XeroContact xeroContact = XeroAPI.getContacts()[0];
        } catch (XeroAPI.XeroApiException e) {
            System.assert( e.getMessage().contains('Error retrieving contacts: '), e.getMessage() );
        }

        Test.stopTest();
    }

    @isTest 
    static void testSendContact() {

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroContactMock', 200));

        // Create data to gain test coverage on the XerContact class
        Account newAcc = new Account(Name = 'Test Account', Phone = '0800 SNOOPDOGG', Fax = '0800 SNOOPDOGG');
        insert newAcc;
        Contact con = new Contact(AccountId = newAcc.Id, FirstName = 'Snoop', LastName = 'Dogg', Email = 'Snoop@Dogg.com', MobilePhone = '123 SNOOPDOGG');
        insert con;

        Account acc = [SELECT 
                            id, 
                            Name, 
                            Phone, 
                            BillingStreet, 
                            ShippingStreet, 
                            BillingCity, 
                            BillingState, 
                            BillingPostalCode, 
                            BillingCountry, 
                            Fax,
                                (SELECT 
                                    id,
                                    FirstName,
                                    LastName,
                                    Email,
                                    MobilePhone 
                                FROM Contacts) 
                            FROM Account 
                            WHERE Name = 'Test Account' Limit 1];

        XeroContact myXeroContact = new XeroContact(acc);

        Test.startTest();

        myXeroContact = XeroAPI.sendContact(myXeroContact);

        Test.stopTest();

        system.assertEquals(
            '10b46b4c-35c1-49c4-a7eb-983ab08ebe1a', 
            myXeroContact.ContactID, 
            'Xero Contact ID should be loaded against the response.'
        );
    }

    @isTest 
    static void testSendContact_Error() {

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroContactMock', 301));

        XeroContact myXeroContact = new XeroContact(
            new Account(
                Phone = '0800 SNOOPDOGG', 
                BillingStreet = '1 Snoop Lane',
                ShippingStreet = '1 Snoop Lane'
            )
        );

        Test.startTest();

        try {
            myXeroContact = XeroAPI.sendContact(myXeroContact);
        } catch (XeroAPI.XeroApiException e) {
            System.assertEquals( 
                '301: OK' + '\n\n' + '- This is a test error', 
                e.getMessage(), 
                'Incorrect above 300 Error Thrown' );
        }

        Test.stopTest();
    }

    @isTest 
    static void testSendContact_Error401() {

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('Xero401Mock', 401));

        XeroContact myXeroContact = new XeroContact(
            new Account(
                Phone = '0800 SNOOPDOGG', 
                BillingStreet = '1 Snoop Lane',
                ShippingStreet = '1 Snoop Lane'
            )
        );

        Test.startTest();

        try {
            myXeroContact = XeroAPI.sendContact(myXeroContact);
        } catch (XeroAPI.XeroApiException e) {
            System.assertEquals( 
                'xxxxxxxxxxxxxxxx: xxxxxxxxxxxxxxxxxx', 
                e.getMessage(), 
                'Inorrect 401 Error Thrown' );
        }

        Test.stopTest();
    }

    @isTest 
    static void getGetInvoice() {

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroInvoiceMock', 200));

        Test.startTest();

        XeroInvoice xeroInvoice = XeroAPI.getInvoice('30aa67f9-d5e5-4351-9e28-c085a6b2d37f');

        Test.stopTest();

        system.assertEquals(
            '30aa67f9-d5e5-4351-9e28-c085a6b2d37f', 
            xeroInvoice.InvoiceID, 
            'Xero Invoice ID should be loaded against the response.'
        );
    }

    @isTest 
    static void getGetInvoice_Error() {

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroInvoiceMock', 301));

        Test.startTest();

        try {
            XeroInvoice xeroInvoice = XeroAPI.getInvoice('30aa67f9-d5e5-4351-9e28-c085a6b2d37f');
        } catch (XeroAPI.XeroApiException e) {
            System.assert( e.getMessage().contains('Error retrieving invoice: 301 - OK'), e.getMessage() );
        }

        Test.stopTest();
    }

    @isTest 
    static void testGetInvoices() {

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroInvoiceMock', 200));

        Test.startTest();

        XeroInvoice xeroInvoice = XeroAPI.getInvoices()[0];

        Test.stopTest();

        system.assertEquals(
            '30aa67f9-d5e5-4351-9e28-c085a6b2d37f', 
            xeroInvoice.InvoiceID, 
            'Xero Invoice ID should be loaded against the response.'
        );
    }

    @isTest 
    static void testGetInvoices_Error() {

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroInvoiceMock', 301));

        Test.startTest();

        try {
            XeroInvoice xeroInvoice = XeroAPI.getInvoices()[0];
        } catch (XeroAPI.XeroApiException e) {
            System.assert( e.getMessage().contains('Error retrieving invoices: 301 - OK'), e.getMessage() );
        }

        Test.stopTest();
    }

    @isTest 
    static void testGetInvoicesWithDaysFilter() {

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroInvoiceMock', 200));

        Test.startTest();

        XeroInvoice xeroInvoice = XeroAPI.getInvoices(999)[0];

        Test.stopTest();

        system.assertEquals(
            '30aa67f9-d5e5-4351-9e28-c085a6b2d37f', 
            xeroInvoice.InvoiceID, 
            'Xero Invoice ID should be loaded against the response.'
        );
    }

    @isTest 
    static void testGetInvoiceAsPDF() {

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroInvoicePDFMock', 200));

        Test.startTest();

        Blob myInvoice = XeroAPI.getInvoiceAsPdf('ABC123');

        Test.stopTest();

        system.assertNotEquals(
            null, 
            myInvoice, 
            'Fake Invoice should be returned from API.'
        );
    }

    @isTest 
    static void testGetInvoiceAsPDF_Error() {

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroInvoicePDFMock', 301));

        Test.startTest();

        try {
            Blob myInvoice = XeroAPI.getInvoiceAsPdf('ABC123');
        } catch (XeroAPI.XeroApiException e) {
            System.assert( e.getMessage().contains('Error retrieving invoice: 301 - OK'), e.getMessage() );
        }

        Test.stopTest();

    }

    @isTest 
    static void testSendInvoice() {

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroInvoiceMock', 200));

        XeroInvoice myXeroInvoice = new XeroInvoice('xeroContactId');

        myXeroInvoice.TrackingCategorys = new List<XeroInvoice.TrackingCategory>();

        XeroInvoice.TrackingCategory trackingCategory = new XeroInvoice.TrackingCategory('Test','Test');

        myXeroInvoice.TrackingCategorys.add(trackingCategory);

        Test.startTest();

        myXeroInvoice = XeroAPI.sendInvoice(myXeroInvoice);

        Test.stopTest();

        system.assertEquals(
            '30aa67f9-d5e5-4351-9e28-c085a6b2d37f', 
            myXeroInvoice.InvoiceID, 
            'Xero Invoice ID should be loaded against the response.'
        );
    }

    @isTest 
    static void testSendInvoice_Error() {

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroInvoiceMock', 301));

        XeroInvoice myXeroInvoice = new XeroInvoice('xeroContactId');

        Test.startTest();
        
        try {
            myXeroInvoice = XeroAPI.sendInvoice(myXeroInvoice);
        } catch (XeroAPI.XeroApiException e) {
            System.assertEquals( 
                '301: OK' + '\n\n' + '- This is a test error', 
                e.getMessage(), 
                'Incorrect above 300 Error Thrown' );
        }
        Test.stopTest();

    }

    @isTest 
    static void testSendInvoice_Error401() {
        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('Xero401Mock', 401));

        XeroInvoice myXeroInvoice = new XeroInvoice('xeroContactId');

        Test.startTest();

        try {
            myXeroInvoice = XeroAPI.sendInvoice(myXeroInvoice);
        } catch (XeroAPI.XeroApiException e) {
            System.assertEquals( 
                'xxxxxxxxxxxxxxxx: xxxxxxxxxxxxxxxxxx', 
                e.getMessage(), 
                'Inorrect 401 Error Thrown' );
        }

        Test.stopTest();

    }

    @istest
    static void testGetXeroTenantId() {

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroConnectionsMock', 200));

        Test.startTest();

        system.assertEquals(
            '82d2a576-821a-44ac-869d-7f902857741d', 
            XeroAPI.getXeroTenantId(),
            'Xero Tenant should be retrieved.'
        );

        Test.stopTest();
    }

    @istest
    static void testGetXeroTenantId_Error() {

        // Set the Mock Class
        Test.setMock(HttpCalloutMock.class, setStaticMock('XeroConnectionsMock', 301));

        Test.startTest();
        
        try {
            XeroAPI.getXeroTenantId();
        } catch (XeroAPI.XeroApiException e) {
            System.assert( e.getMessage().contains('Error retrieving connections: 301 - OK'), e.getMessage() );
        }
        Test.stopTest();

    }

    /**
    * @author Ben Edwards (ben@edwards.nz)
    * @date 3rd February 2020
    * @description Simple method to default mock classes for the Xero callout
    **/
    public static StaticResourceCalloutMock setStaticMock (String mockName, Integer statusCode) {

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource(mockName);
		mock.setStatusCode(statusCode);
		mock.setHeader('Content-Type', 'application/json');
		return mock;
    }
}
