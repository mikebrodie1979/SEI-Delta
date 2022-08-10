pageextension 80005 "BA Sales Quote" extends "Sales Quote"
{
    layout
    {
        modify("Due Date")
        {
            ApplicationArea = all;
            Visible = false;
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
        modify("Bill-to Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
        }
        addbefore("Bill-to Name")
        {
            field("BA Bill-to Country/Region Code"; "Bill-to Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
                // Editable = billtoop
            }
        }
        modify("Ship-to Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
        }
        addfirst(Control72)
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

    actions
    {
        addlast(Navigation)
        {
            action("BA Assemble-to-Order Lines")
            {
                Image = AssemblyBOM;
                Caption = 'Assemble-to-Order Lines';
                ApplicationArea = all;

                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";
                begin
                    CurrPage.SalesLines.Page.GetRecord(SalesLine);
                    SalesLine.ShowAsmToOrderLines();
                end;
            }
        }
        addlast(Processing)
        {
            action("BA Update Exchange Rate")
            {
                Image = AdjustExchangeRates;
                ApplicationArea = all;
                Caption = 'Update Exchange Rate';
                Enabled = CanUpdateRate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    UpdateExchangeRate: Report "BA Update Exchange Rate";
                begin
                    UpdateExchangeRate.SetSource(Rec.RecordId());
                    UpdateExchangeRate.RunModal();
                end;
            }
        }
    }

    var
        [InDataSet]
        CanUpdateRate: Boolean;

    trigger OnAfterGetRecord()
    var
        SalesRecSetup: Record "Sales & Receivables Setup";
    begin
        CanUpdateRate := SalesRecSetup.Get() and SalesRecSetup."BA Use Single Currency Pricing";
    end;
}