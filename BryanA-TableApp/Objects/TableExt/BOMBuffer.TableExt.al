tableextension 80038 "BA BOM Buffer" extends "BOM Buffer"
{
    fields
    {
        field(80010; "BA Description 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description 2';
            Editable = false;
        }
    }
}