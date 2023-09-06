tableextension 80003 "BA BOM Component" extends "BOM Component"
{
    fields
    {
        field(80000; "BA Optional"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Optional';
        }
        field(80010; "BA Description 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description 2';
        }
    }
}