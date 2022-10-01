tableextension 80049 "BA Item Jnl. Line" extends "Item Journal Line"
{
    fields
    {
        field(80000; "BA Updated"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Updated';
            Editable = false;
            Description = 'System field used for Physical Inventory import';
        }
    }
}