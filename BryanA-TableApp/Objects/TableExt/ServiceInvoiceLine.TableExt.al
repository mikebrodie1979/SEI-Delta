tableextension 80082 "BA Service Invoice Line" extends "Service Invoice Line"
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