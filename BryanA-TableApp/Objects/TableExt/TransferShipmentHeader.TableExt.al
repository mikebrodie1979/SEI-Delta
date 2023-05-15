tableextension 80023 "BA Transfer Shpt. Header" extends "Transfer Shipment Header"
{
    fields
    {
        field(80000; "BA Transfer-To FID No."; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'FID No.';
            Editable = false;
        }
        field(80001; "BA Transfer-To Phone No."; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Phone No.';
            Editable = false;
        }
        field(80005; "BA Trans. Order No. DrillDown"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Transfer Order No.';
            Description = 'Used for Lookup DropDown';
            Editable = false;
        }
    }
    fieldgroups
    {
        addlast(DropDown; "BA Trans. Order No. DrillDown") { }
    }
}