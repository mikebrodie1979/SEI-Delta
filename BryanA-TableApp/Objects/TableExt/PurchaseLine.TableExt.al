tableextension 80000 "ENC Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(80000; "BA Salesperson Filter Code"; Code[10])
        {
            Caption = 'Salesperson Filter Code';
            Editable = false;
            FieldClass = FlowFilter;
        }
    }
}