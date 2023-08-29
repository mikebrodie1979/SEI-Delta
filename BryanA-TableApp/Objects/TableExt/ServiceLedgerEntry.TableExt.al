tableextension 80047 "BA Service Ledger Entry" extends "Service Ledger Entry"
{
    fields
    {
        field(80000; "BA Description 2"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description 2';
            Editable = false;
        }
    }
}