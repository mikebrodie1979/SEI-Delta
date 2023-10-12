tableextension 80098 "BA Posted Deposit Header" extends "Posted Deposit Header"
{
    fields
    {
        field(80000; "BA User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'User ID';
            TableRelation = "User Setup"."User ID";
            ValidateTableRelation = false;
            Editable = false;
        }
    }
}