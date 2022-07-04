pageextension 80058 "BA Purchase Invoice" extends "Purchase Invoice"
{
    layout
    {
        modify("Buy-from Country/Region Code")
        {
            ApplicationArea = all;
            Caption = 'Buy-from Country';
        }
        modify("Pay-to Country/Region Code")
        {
            ApplicationArea = all;
            Caption = 'Pay-to Country';
        }
        modify("Ship-to Country/Region Code")
        {
            ApplicationArea = all;
            Caption = 'Ship-to Country';
        }
    }
}