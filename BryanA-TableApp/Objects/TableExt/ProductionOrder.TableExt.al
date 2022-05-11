tableextension 80018 "BA Production Order" extends "Production Order"
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