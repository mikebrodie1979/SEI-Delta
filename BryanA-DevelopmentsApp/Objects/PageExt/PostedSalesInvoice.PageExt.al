pageextension 80052 "BA Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        modify("Bill-to Country/Region Code")
        {
            ApplicationArea = all;
            Caption = 'Bill-to Country';
        }
        modify("Sell-to Country/Region Code")
        {
            ApplicationArea = all;
            Caption = 'Sell-to Country';
        }
        modify("Ship-to Country/Region Code")
        {
            ApplicationArea = all;
            Caption = 'Ship-to Country';
        }
    }
}