tableextension 80038 "BA Service Inv. Header" extends "Service Invoice Header"
{
    fields
    {
        field(80000; "BA Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup ("Service Shipment Header"."No." where ("Order No." = field ("Order No.")));
        }
    }
}