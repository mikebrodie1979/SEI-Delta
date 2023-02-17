report 50075 "BA Prod. BOM Version"
{
    ProcessingOnly = true;
    Caption = 'Update Prod. BOM Versions';
    ApplicationArea = all;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Production BOM Header"; "Production BOM Header")
        {
            trigger OnPreDataItem()
            begin
                Window.Open('Updating\#1###');
                RecCount := Count;
            end;

            trigger OnAfterGetRecord()
            var
                ProdBomVersion: Record "Production BOM Version";
            begin
                i += 1;
                Window.Update(1, StrSubstNo('%1 of %2', i, RecCount));
                ProdBomVersion.SetRange("Production BOM No.", "Production BOM Header"."No.");
                if not ProdBomVersion.FindFirst() then
                    exit;
                Subscribers.UpdateBOMActive(ProdBomVersion);
                UpdatedCount += 1;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
                Message('Updated %1 records', UpdatedCount);
            end;
        }
    }

    var
        Subscribers: Codeunit "BA SEI Subscibers";
        Window: Dialog;
        RecCount: Integer;
        UpdatedCount: Integer;
        i: Integer;
}