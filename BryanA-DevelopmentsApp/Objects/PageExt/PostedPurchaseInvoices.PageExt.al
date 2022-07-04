pageextension 80012 "BA Posted Purch. Invoices" extends "Posted Purchase Invoices"
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

    trigger OnOpenPage()
    var
        FilterNo: Integer;
    begin
        FilterNo := Rec.FilterGroup();
        Rec.FilterGroup(2);
        Rec.SetRange("BA Requisition Order", false);
        Rec.FilterGroup(FilterNo);
    end;
}