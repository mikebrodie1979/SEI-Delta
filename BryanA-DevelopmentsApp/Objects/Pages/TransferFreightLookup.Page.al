page 50073 "BA Transfer Freight Lookup"
{
    Caption = 'Transfer Freight Lookup';
    PageType = Worksheet;
    SourceTable = "Transfer Shipment Header";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Order No."; Rec."Transfer Order No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    procedure GetRecord(var OrderNo: Code[20]; var DocNo: Code[20])
    begin
        OrderNo := Rec."Transfer Order No.";
        DocNo := Rec."No.";
    end;
}