tableextension 80002 "BA Prod. BOM Line" extends "Production BOM Line"
{
    fields
    {
        field(80000; "BA Optional"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Optional';
        }
    }
}