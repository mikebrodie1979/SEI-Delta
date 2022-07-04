pageextension 80054 "BA Sales Return Order" extends "Sales Return Order"
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