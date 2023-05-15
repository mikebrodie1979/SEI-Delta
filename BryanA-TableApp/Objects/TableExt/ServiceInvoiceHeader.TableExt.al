tableextension 80093 "BA Service Inv. Header" extends "Service Invoice Header"
{
    fields
    {
        field(80000; "BA Order No. DrillDown"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Order No.';
            Description = 'Used for Lookup DropDown';
            Editable = false;
        }
    }

    fieldgroups
    {
        addlast(DropDown; "BA Order No. DrillDown") { }
    }
}