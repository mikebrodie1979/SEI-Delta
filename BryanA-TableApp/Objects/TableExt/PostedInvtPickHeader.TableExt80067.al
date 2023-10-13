tableextension 80067 "BA Posted Invt. Pick Header" extends "Posted Invt. Pick Header"
{
    fields
    {
        field(80000; "BA Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            FieldClass = FlowField;
            CalcFormula = lookup ("Sales Shipment Header"."Order No." where ("No." = field ("Source No.")));
            Editable = false;
        }
    }
}