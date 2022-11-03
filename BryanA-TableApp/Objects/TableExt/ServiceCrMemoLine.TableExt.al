tableextension 80083 "BA Service Cr.Memo Line" extends "Service Cr.Memo Line"
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