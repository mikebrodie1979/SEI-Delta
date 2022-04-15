tableextension 80007 "BA Purchase Header" extends "Purchase Header"
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