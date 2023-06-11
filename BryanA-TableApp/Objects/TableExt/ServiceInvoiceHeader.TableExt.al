tableextension 80093 "BA Service Inv. Header" extends "Service Invoice Header"
{
    fields
    {
        field(80030; "BA Order No. DrillDown"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Order No.';
            Description = 'Used for Lookup DropDown';
            Editable = false;
        }
        field(80032; "BA Freight Carrier Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Freight Carrier Name';
            // Editable = false;
        }
        field(80033; "BA Freight Term Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Freight Term Name';
            Editable = false;
        }
        field(80034; "BA Posting Date DrillDown"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date';
            Description = 'Used for Lookup DropDown';
            Editable = false;
        }
        field(80035; "BA Ship-to Name DrillDown"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-to Name';
            Description = 'Used for Lookup DropDown';
            Editable = false;
        }
        field(80036; "BA Bill-to Name DrillDown"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Bill-to Name';
            Description = 'Used for Lookup DropDown';
            Editable = false;
        }
    }

    keys
    {
        key(K1; "BA Order No. DrillDown") { }
    }

    fieldgroups
    {
        addlast(DropDown; "BA Order No. DrillDown", "No.", "ENC External Document No.", "BA Posting Date DrillDown", "BA Bill-to Name DrillDown", "BA Ship-to Name DrillDown", "BA Freight Carrier Name", "BA Freight Term Name", "ENC Package Tracking No.", "ENC Physical Ship Date") { }
    }
}