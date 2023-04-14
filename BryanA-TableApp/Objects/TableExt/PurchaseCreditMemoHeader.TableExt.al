tableextension 80014 "BA Purch. Cr. Memo Header" extends "Purch. Cr. Memo Hdr."
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
        field(80100; "BA Product ID Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Product ID Code';
            TableRelation = "Dimension Value".Code where ("Dimension Code" = const ('PRODUCT ID'), Blocked = const (false), "ENC Inactive" = const (false));
            Editable = false;
        }
        field(80101; "BA Project Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Project Code';
            TableRelation = "Dimension Value".Code where ("Dimension Code" = const ('PROJECT'), Blocked = const (false), "ENC Inactive" = const (false));
            Editable = false;
        }
    }
}