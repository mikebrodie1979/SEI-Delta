report 50086 "BA Delete Customers"
{
    Caption = 'Delete Customers';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.";

            trigger OnPreDataItem()
            begin
                if Customer.GetFilter("No.") = '' then
                    Error(NoFilterErr, Customer.FieldName("No."));
                if not Confirm(StrSubstNo(DeleteCustQst, Customer.Count())) then
                    CurrReport.Quit();
                RecCount := Customer.Count();
                Window.Open('Deleting\#1### of ' + Format(RecCount));
            end;

            trigger OnAfterGetRecord()
            var
                Customer2: Record Customer;
            begin
                i2 += 1;
                Window.Update(1, i2);
                Customer2.Get(Customer."No.");
                Customer2.SetDisableConfirm();
                if not TryToDeleteCust(Customer2) then
                    Errors.Add(GetLastErrorText());
            end;

            trigger OnPostDataItem()
            var
                ErrorText: TextBuilder;
                i: Integer;
            begin
                Window.Close();
                if Errors.Count() > 0 then begin
                    ErrorText.AppendLine(StrSubstNo(ErrorTextTitle, Errors.Count));
                    for i := 1 to Errors.Count() do
                        ErrorText.AppendLine(Errors.Get(i));
                    Message(ErrorText.ToText());
                end;
            end;
        }
    }


    requestpage
    {
        SaveValues = true;
    }


    [TryFunction]
    local procedure TryToDeleteCust(var Customer: Record Customer)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.SetRange("Customer No.", Customer."No.");
        Customer.CalcFields("Sales (LCY)");
        if (Customer."Sales (LCY)" <> 0) or not CustLedgerEntry.IsEmpty() then
            Error(NonZeroSalesCustomer, Customer."No.");
        Customer.Delete(true);
    end;

    var
        Errors: List of [Text];
        Window: Dialog;
        i2: Integer;
        RecCount: Integer;

        NoFilterErr: Label 'Must specify a filter for the %1 field.';
        DeleteCustQst: Label 'Delete %1 customers?';
        ErrorTextTitle: Label 'Failed to delete %1 customers:\';
        NonZeroSalesCustomer: Label 'Customer %1 cannot be deleted as it has asscioated posted entries.';
}