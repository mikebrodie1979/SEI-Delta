pageextension 80012 "BA Posted Purch. Invoices" extends "Posted Purchase Invoices"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Order No.2"; "Order No.")
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