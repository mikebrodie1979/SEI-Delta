pageextension 80005 "BA Sales Quote" extends "Sales Quote"
{
    layout
    {
        modify("Due Date")
        {
            ApplicationArea = all;
            Visible = false;
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
                    Subscribers: Codeunit "BA SEI Subscibers";
                begin
                    Subscribers.UpdateSalesPrice(Rec);
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