tableextension 80080 "BA Company Information" extends "Company Information"
{
    fields
    {
        field(80000; "BA Environment Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Environment Name';
        }
    }
}