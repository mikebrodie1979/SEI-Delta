pageextension 80066 "BA Posted Purch. Cr.Memo" extends "Posted Purchase Credit Memo"
{
    layout
    {
        modify("Buy-from Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
        }
        addlast(General)
        {
            field("BA Product ID Code"; Rec."BA Product ID Code")
            {
                ApplicationArea = all;
            }
            field("BA Project Code"; Rec."BA Project Code")
            {
                ApplicationArea = all;
            }
        }
        addfirst("Buy-from")
        {
            field("BA Buy-from Country/Region Code"; "Buy-from Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
                Editable = false;
            }
        }
        modify("Pay-to Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
        }
        addfirst("Pay-to")
        {
            field("BA Pay-to Country/Region Code"; "Pay-to Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
                Editable = false;
            }
        }
        modify("Ship-to Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
        }
        addfirst("Ship-to")
        {
            field("BA Ship-to Country/Region Code"; "Ship-to Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
                Editable = false;
            }
        }
    }
}