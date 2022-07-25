tableextension 80040 "BA Sales Shpt. Header" extends "Sales Shipment Header"
{
    fields
    {
        field(80000; "BA Merged Shpt. Lines"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Merged Shipment Lines';
        }
        field(80001; "BA Original Doc. No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Original Document No.';
        }
        field(80002; "BA Hide Merged Shpt. Lines"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Hide Merged Shipment Lines';
        }
    }
}