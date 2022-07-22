pageextension 80025 "BA Sales Order" extends "Sales Order"
{
    layout
    {
        modify("Due Date")
        {
            ApplicationArea = all;
            Visible = false;
        }
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
        addafter("Payment Method Code")
        {
            field("Due Date2"; Rec."Due Date")
            {
                ApplicationArea = all;
            }
        }
    }
}