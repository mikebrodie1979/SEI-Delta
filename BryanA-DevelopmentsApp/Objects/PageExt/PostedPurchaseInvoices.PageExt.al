pageextension 80012 "BA Posted Purch. Invoices" extends "Posted Purchase Invoices"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Order No.2"; Rec."Order No.")
            {
                ApplicationArea = all;
            }
        }
        modify("Buy-from Country/Region Code")
        {
            ApplicationArea = all;
            Caption = 'Country';
        }
        modify("Pay-to Country/Region Code")
        {
            ApplicationArea = all;
            Caption = 'Country';
        }
        modify("Ship-to Country/Region Code")
        {
            ApplicationArea = all;
            Caption = 'Country';
        }
        addlast(Control1)
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = all;
            }
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