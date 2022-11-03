tableextension 80080 "BA Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(80000; "BA Omit from Reports"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Omit From Reports';
        }
    }
}