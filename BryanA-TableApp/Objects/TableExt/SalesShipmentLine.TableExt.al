tableextension 80041 "BA Sales Shpt. Line" extends "Sales Shipment Line"
{
    fields
    {
        field(80010; "BA Merged Shpt. Line"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Merged Shipment Line';
        }
    }
}