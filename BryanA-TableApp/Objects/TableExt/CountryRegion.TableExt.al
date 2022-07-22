tableextension 80035 "BA Country/Region" extends "Country/Region"
{
    fields
    {
        field(80000; "BA Region"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Region';
        }
    }
}