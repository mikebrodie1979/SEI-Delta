tableextension 80025 "BA Cust. Posting Group" extends "Customer Posting Group"
{
    fields
    {
        field(80000; "BA Blocked"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Blocked';
        }
    }
}