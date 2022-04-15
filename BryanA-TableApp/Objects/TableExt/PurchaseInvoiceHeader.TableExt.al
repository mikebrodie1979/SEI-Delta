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
    }
}