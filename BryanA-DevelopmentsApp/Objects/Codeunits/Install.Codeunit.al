codeunit 75011 "BA Install Codeunit"
{
    Subtype = Install;
    Permissions = tabledata "Sales Invoice Header" = r,
                  tabledata "Service Invoice Header" = r,
                  tabledata Customer = m,
                  tabledata "Purch. Inv. Header" = m,
                  tabledata "Purch. Cr. Memo Hdr." = m,
                  tabledata "Purch. Rcpt. Header" = m,
                  tabledata "Purchase Header" = m;

    trigger OnInstallAppPerCompany()
    begin
        AddItemJnlApprovalCode();
        AddCustomerSalesActivity();
        // AddNewDimValues();
    end;



    local procedure AddNewDimValues()
    var
        CompInfo: Record "Company Information";
        RecRef: RecordRef;
    begin
        if not CompInfo.Get() or CompInfo."BA Populated Dimensions" then
            exit;
        RecRef.Open(Database::"Purchase Header");
        AddNewDimValues(RecRef);
        RecRef.Open(Database::"Purch. Cr. Memo Hdr.");
        AddNewDimValues(RecRef);
        RecRef.Open(Database::"Purch. Inv. Header");
        AddNewDimValues(RecRef);
        RecRef.Open(Database::"Purch. Rcpt. Header");
        AddNewDimValues(RecRef);
        CompInfo."BA Populated Dimensions" := true;
        CompInfo.Modify(false);
    end;


    procedure AddNewDimValues(var RecRef: RecordRef)
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
        RecIDs: List of [RecordID];
        RecID: RecordId;
        FldRef: FieldRef;
        FldRef2: FieldRef;
        DimSetID: Integer;
        ProductIDFldNo: Integer;
        ProjectFldNo: Integer;
    begin
        ProductIDFldNo := 80100;
        ProjectFldNo := 80101;
        if not RecRef.FindFirst() or not RecRef.FieldExist(ProductIDFldNo) or not RecRef.FieldExist(ProjectFldNo) then begin
            RecRef.Close();
            exit;
        end;

        FldRef := RecRef.Field(ProductIDFldNo);
        FldRef.SetRange('');
        if RecRef.FindSet() then
            repeat
                TempDimSetEntry.Reset();
                TempDimSetEntry.DeleteAll(false);
                FldRef2 := RecRef.Field(480);
                DimSetID := FldRef2.Value();
                if DimSetID <> 0 then begin
                    DimMgt.GetDimensionSet(TempDimSetEntry, DimSetID);
                    TempDimSetEntry.SetRange("Dimension Code", 'PRODUCT ID');
                    if TempDimSetEntry.FindFirst() then
                        RecIDs.Add(RecRef.RecordId);
                end;
            until RecRef.Next() = 0;
        FldRef.SetRange();

        FldRef := RecRef.Field(ProjectFldNo);
        FldRef.SetRange('');
        if RecRef.FindSet() then
            repeat
                TempDimSetEntry.Reset();
                TempDimSetEntry.DeleteAll(false);
                FldRef2 := RecRef.Field(480);
                DimSetID := FldRef2.Value();
                if DimSetID <> 0 then begin
                    DimMgt.GetDimensionSet(TempDimSetEntry, DimSetID);
                    TempDimSetEntry.SetRange("Dimension Code", 'PROJECT');
                    if TempDimSetEntry.FindFirst() then
                        RecIDs.Add(RecRef.RecordId);
                end;
            until RecRef.Next() = 0;

        foreach RecID in RecIDs do begin
            RecRef.Get(RecID);
            TempDimSetEntry.Reset();
            TempDimSetEntry.DeleteAll(false);
            FldRef2 := RecRef.Field(480);
            DimSetID := FldRef2.Value();
            DimMgt.GetDimensionSet(TempDimSetEntry, DimSetID);
            TempDimSetEntry.SetRange("Dimension Code", 'PRODUCT ID');
            if TempDimSetEntry.FindFirst() then begin
                FldRef := RecRef.Field(ProductIDFldNo);
                FldRef.Value(TempDimSetEntry."Dimension Value Code");
            end;
            TempDimSetEntry.SetRange("Dimension Code", 'PROJECT');
            if TempDimSetEntry.FindFirst() then begin
                FldRef := RecRef.Field(ProjectFldNo);
                FldRef.Value(TempDimSetEntry."Dimension Value Code");
            end;
            RecRef.Modify(false);
        end;
        RecRef.Close();
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