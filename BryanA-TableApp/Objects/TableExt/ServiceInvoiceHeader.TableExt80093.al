tableextension 80093 "BA Service Inv. Header" extends "Service Invoice Header"
{
    fields
    {
        field(80000; "BA Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup ("Service Shipment Header"."No." where ("Order No." = field ("Order No.")));
        }
        field(80005; "BA Package Tracking No. Date"; DateTime)
        {
            Caption = 'Package Tracking No. Last Modified';
            Editable = false;
        }
        field(80100; "BA Actual Posting DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Actual Posting DateTime';
            Editable = false;
        }
    }

    keys
    {
        key("BA Actual Posting"; "BA Actual Posting DateTime") { }
    }

    trigger OnInsert()
    begin
        Rec."BA Actual Posting DateTime" := CurrentDateTime();
    end;
}