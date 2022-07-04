pageextension 80017 "BA Posted Return Shipments" extends "Posted Return Shipments"
{
    layout
    {
        addafter("No.")
        {
            field("Return Order No."; Rec."Return Order No.")
            {
                ApplicationArea = all;
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