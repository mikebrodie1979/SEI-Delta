tableextension 80096 "BA Salesperson/Purchaser" extends "Salesperson/Purchaser"
{
    fields
    {
        field(80000; "BA Sales Staff"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Staff';
        }
    }
}