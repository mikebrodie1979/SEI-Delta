pageextension 80005 "BA Sales Quote" extends "Sales Quote"
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
    }

}