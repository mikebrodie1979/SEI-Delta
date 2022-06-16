tableextension 80021 "BA Transfer Header" extends "Transfer Header"
{
    fields
    {
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
        modify("Transfer-from County")
        {
            TableRelation = "BA Province/State".Symbol where ("Country/Region Code" = field ("Trsf.-from Country/Region Code"));
        }
        modify("Transfer-to County")
        {
            TableRelation = "BA Province/State".Symbol where ("Country/Region Code" = field ("Trsf.-to Country/Region Code"));
        }
    }
}