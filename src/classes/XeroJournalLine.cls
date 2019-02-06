/**
* @author       Gordie Noye (gordie.noye@gmail.com)
* @description  Wrapper class to hold details for a Xero JournalLine details
**/
public class XeroJournalLine {

    public String JournalLineID {get; set;}   // Xero identifier
    public String AccountID {get; set;}   // See Accounts
    public String AccountCode {get; set;}   // See Accounts
    public String AccountType {get; set;}   // See Account Types
    public String AccountName {get; set;}   // See AccountCodes
    public String Description {get; set;}   // The description from the source transaction line item. Only returned if populated.
    public String NetAmount {get; set;}   // Net amount of journal line. This will be a positive value for a debit and negative for a credit
    public String GrossAmount {get; set;}   // Gross amount of journal line (NetAmount + TaxAmount).
    public String TaxAmount {get; set;}   // Total tax on a journal line
    public String TaxType {get; set;}   // see TaxTypes
    public String TaxName {get; set;}   // see TaxRates
    public XeroTrackingCategory TrackingCategories[] {get; set;}    // Array: see Tracking

}