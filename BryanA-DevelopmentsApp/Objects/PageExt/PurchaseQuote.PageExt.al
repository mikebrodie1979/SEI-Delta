pageextension 80057 "BA Purchase Quote" extends "Purchase Quote"
{
    layout
    {
        modify("Buy-from Country/Region Code")
        {
            ApplicationArea = all;
            Caption = 'Country';
        }
        modify("Pay-to Country/Region Code")
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