page 50067 "BA Phys. Invt. Import Errors"
{
    // ApplicationArea = all;
    // UsageCategory = Lists;
    SourceTable = "Name/Value Buffer";
    PageType = List;
    Caption = 'Physical Inventory Import Errors';
    Editable = false;
    LinksAllowed = false;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Item No."; Rec.Name)
                {
                    ApplicationArea = all;
                    Caption = 'Item No.';
                }
                field("Line No."; Rec.ID)
                {
                    ApplicationArea = all;
                    Caption = 'Journal Line No.';
                }
                field(Error; Rec.Value)
                {
                    ApplicationArea = all;
                    Caption = 'Error';
                }
            }
        }
    }

    procedure PopulateRecords(var ItemJnlLine: Record "Item Journal Line")
    begin
        if ItemJnlLine.FindSet() then
            repeat
                Rec.Init();
                Rec.ID := ItemJnlLine."Line No.";
                Rec.Name := ItemJnlLine."Item No.";
                Rec.Value := ItemJnlLine."BA Warning Message";
                Rec.Insert(false);
            until ItemJnlLine.Next() = 0;
    end;
}