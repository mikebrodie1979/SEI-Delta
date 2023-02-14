codeunit 75011 "BA Install Codeunit"
{
    Subtype = Install;


    trigger OnInstallAppPerCompany()
    begin
        AddItemJnlApprovalCode();
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
}