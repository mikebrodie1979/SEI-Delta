pageextension 80052 "BA Posted Sales Invoice" extends "Posted Sales Invoice"
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