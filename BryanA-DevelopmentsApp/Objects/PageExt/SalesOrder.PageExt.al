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
            Visible = false;
            Enabled = false;
        }
        addfirst(Control82)
        {
            field("BA Bill-to Country/Region Code"; "Bill-to Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
            }
        }
        modify("Sell-to Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
        }
        addfirst("Sell-to")
        {
            field("BA Sell-to Country/Region Code"; "Sell-to Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
            }
        }
        modify("Ship-to Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
        }
        addfirst(Control4)
        {
            field("BA Ship-to Country/Region Code"; "Ship-to Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
            }
        }
        addafter("Payment Method Code")
        {
            field("Due Date2"; Rec."Due Date")
            {
                ApplicationArea = all;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        ExchangeRate: Record "Currency Exchange Rate";
        SalesRecSetup: Record "Sales & Receivables Setup";
        Subscribers: Codeunit "BA SEI Subscibers";
    begin
        SalesRecSetup.Get();
        if not SalesRecSetup."BA Use Single Currency Pricing" then
            exit;
        SalesRecSetup.TestField("BA Single Price Currency");
        if Subscribers.GetExchangeRate(ExchangeRate, SalesRecSetup."BA Single Price Currency") then begin
            Rec."BA Quote Exch. Rate" := ExchangeRate."Relational Exch. Rate Amount";
            CurrPage.SalesLines.Page.SetExchangeRate(Rec."BA Quote Exch. Rate");
        end
    end;
}