page 50074 "BA Service Freight Lookup"
{
    Caption = 'Service Freight Lookup';
    PageType = Worksheet;
    SourceTable = "Service Invoice Header";
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
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = all;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    procedure GetRecord(var OrderNo: Code[20]; var DocNo: Code[20])
    begin
        OrderNo := Rec."Order No.";
        DocNo := Rec."No.";
    end;
}