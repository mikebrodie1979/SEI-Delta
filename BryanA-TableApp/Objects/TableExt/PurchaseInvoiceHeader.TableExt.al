tableextension 80009 "BA Purch. Inv. Header" extends "Purch. Inv. Header"
{
    fields
    {
        field(80000; "BA Requisition Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Requisition Order';
            Editable = false;
            Description = 'System field to specify Requisition Orders';
        }
        field(80001; "BA Fully Rec'd. Req. Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Fully Received Requisition Order';
            Editable = false;
            Description = 'System field to specify when a Requisition Order is to be considered fully recieved/posted';
        }
        field(80005; "BA Omit Orders"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Omit from Outstanding Orders';
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