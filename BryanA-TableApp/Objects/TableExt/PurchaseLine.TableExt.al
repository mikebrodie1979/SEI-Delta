tableextension 80000 "BA Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(80000; "BA Salesperson Filter Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Salesperson Filter Code';
            Editable = false;
        }
    }
}