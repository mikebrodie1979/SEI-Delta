tableextension 80021 "BA Transfer Header" extends "Transfer Header"
{
    fields
    {
        modify("Location Filter")
        {
            TableRelation = Location.Code where ("BA Inactive" = const (false));
        }
        field(80000; "BA Transfer-To FID No."; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'FID No.';
        }
        field(80001; "BA Transfer-To Phone No."; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Phone No.';
        }
    }
}