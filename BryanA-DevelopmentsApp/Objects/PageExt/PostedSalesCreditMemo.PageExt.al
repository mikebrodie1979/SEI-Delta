pageextension 80062 "BA Posted Sales Cr.Memo" extends "Posted Sales Credit Memo"
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
        modify("Ship-to Country/Region Code")
        {
            ApplicationArea = all;
            Caption = 'Country';
        }
    }
}