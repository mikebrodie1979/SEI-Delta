tableextension 80039 "BA BOM Ledger Entry" extends "BOM Ledger Entry"
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