/**
* @author       Gordie Noye (gordie.noye@gmail.com)
* @description  Wrapper class to hold details for a Xero Account details
**/
public class XeroAccount {

    public String Code {get; set;}    // Customer defined alpha numeric account code e.g 200 or SALES (max length = 10)
    public String Name {get; set;}    // Name of account (max length = 150)
    public String Type {get; set;}    //See Account Types
    public String BankAccountNumber {get; set;}    // For bank accounts only (Account Type BANK)
    
    //The following elements are optional for creates and updates
    
    public String Status {get; set;}    // Accounts with a status of ACTIVE can be updated to ARCHIVED. See Account Status Codes
    public String Description {get; set;}    // Description of the Account. Valid for all types of accounts except bank accounts (max length = 4000)
    public String BankAccountType {get; set;}    // For bank accounts only. See Bank Account types
    public String CurrencyCode {get; set;}    // For bank accounts only
    public String TaxType {get; set;}    // See Tax Types
    public Boolean EnablePaymentsToAccount {get; set;}    // Boolean - describes whether account can have payments applied to it
    public Boolean ShowInExpenseClaims {get; set;}    // Boolean - describes whether account code is available for use with expense claims
    
}   