pageextension 80042 "BA Post. Purch. Shpt." extends "Posted Return Shipment"
{
    layout
    {
        addafter("Document Date")
        {
            field("Expected Receipt Date2"; Rec."Expected Receipt Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
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