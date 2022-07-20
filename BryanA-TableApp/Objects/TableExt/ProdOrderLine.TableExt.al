tableextension 80050 "BA Prod. Order Line" extends "Prod. Order Line"
{
    fields
    {
        field(80000; "BA NC Work Completed"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'NC Work Completed';
        }
    }
}