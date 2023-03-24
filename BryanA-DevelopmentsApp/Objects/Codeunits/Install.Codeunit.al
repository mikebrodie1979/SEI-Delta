codeunit 75011 "BA Install Codeunit"
{
    Subtype = Install;


    trigger OnInstallAppPerCompany()
    begin
        AddItemJnlApprovalCode();
        AddCustomerSalesActivity();
    end;

    local procedure AddItemJnlApprovalCode()
    var
        InventorySetup: Record "Inventory Setup";
        ApprovalCode: Record "Approval Code";
    begin
        InventorySetup.Get();
        if (InventorySetup."BA Approval Code" <> '') then
            exit;
        InventorySetup."BA Approval Code" := 'ITEM-JNL';
        InventorySetup.Modify(false);

        if ApprovalCode.Get(InventorySetup."BA Approval Code") then
            exit;
        ApprovalCode.Init();
        ApprovalCode.Validate(Code, InventorySetup."BA Approval Code");
        ApprovalCode.Validate(Description, 'Inventory Adjustment Approvals.');
        ApprovalCode.Validate("Linked To Table No.", Database::"Item Journal Batch");
        ApprovalCode.Insert(true);
    end;



    local procedure AddCustomerSalesActivity()
    var
        Customer: Record Customer;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ServiceInvoiceHeader: Record "Service Invoice Header";
        VoidDateTime: DateTime;
        SalesDate: Date;
        ServiceDate: Date;
        VoidTime: Time;
        CustDict: Dictionary of [Code[20], Date];
        CustNo: Code[20];
    begin
        Customer.SetRange("BA Last Sales Activity", 0D);
        if not Customer.FindSet(true) then
            exit;
        SalesInvoiceHeader.SetCurrentKey("Posting Date");
        SalesInvoiceHeader.SetAscending("Posting Date", true);
        ServiceInvoiceHeader.SetCurrentKey("Posting Date");
        ServiceInvoiceHeader.SetAscending("Posting Date", true);
        repeat
            SalesInvoiceHeader.SetRange("Bill-to Customer No.", Customer."No.");
            if SalesInvoiceHeader.FindLast() then
                SalesDate := SalesInvoiceHeader."Posting Date"
            else
                SalesDate := 0D;
            ServiceInvoiceHeader.SetRange("Bill-to Customer No.", Customer."No.");
            if ServiceInvoiceHeader.FindLast() then
                ServiceDate := ServiceInvoiceHeader."Posting Date"
            else
                ServiceDate := 0D;
            if SalesDate <> 0D then
                if ServiceDate <> 0D then
                    if SalesDate >= ServiceDate then
                        CustDict.Add(Customer."No.", SalesDate)
                    else
                        CustDict.Add(Customer."No.", ServiceDate)
                else
                    CustDict.Add(Customer."No.", SalesDate)
            else
                if ServiceDate <> 0D then
                    CustDict.Add(Customer."No.", ServiceDate);
        until Customer.Next() = 0;

        foreach CustNo in CustDict.Keys() do begin
            Customer.Get(CustNo);
            CustDict.Get(CustNo, Customer."BA Last Sales Activity");
            Customer.Modify(false);
        end;
    end;
}