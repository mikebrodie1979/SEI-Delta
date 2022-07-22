pageextension 80053 "BA Sales Credit Memo" extends "Sales Credit Memo"
{
    layout
    {
        modify("Bill-to Country/Region Code")
        {
            ApplicationArea = all;
            Caption = 'Country';
        }
        modify("Sell-to Country/Region Code")
        {
            ApplicationArea = all;
            Caption = 'Country';
        }
    }
}