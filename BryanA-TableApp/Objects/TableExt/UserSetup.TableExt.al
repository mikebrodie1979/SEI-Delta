tableextension 80024 "BA User Setup" extends "User Setup"
{
    fields
    {
        field(80000; "BA Job Title"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Title';
        }
    }
}