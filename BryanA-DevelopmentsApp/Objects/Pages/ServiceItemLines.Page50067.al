page 50067 "BA Service Item Lines"
{
    PageType = ListPart;
    SourceTable = "Service Ledger Entry";
    Editable = false;
    LinksAllowed = false;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {
                field("Line No."; Rec."Service Item No. (Serviced)")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No. (Serviced)")
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Serial No."; Rec."Serial No. (Serviced)")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field(Description2; Rec."BA Description 2")
                {
                    ApplicationArea = all;
                }
                field("Service Price Group Code"; Rec."Service Price Group Code")
                {
                    ApplicationArea = all;
                }
                field("Moved from Prepaid Acc."; Rec."Moved from Prepaid Acc.")
                {
                    ApplicationArea = all;
                    Caption = 'Warranty';
                }
                field("Loaner No."; Rec."Bin Code")
                {
                    ApplicationArea = all;
                    Caption = 'Loaner No.';
                }
            }
        }
    }

    procedure SetSource(OrderNo: Code[20])
    var
        ServiceLedgerEntry: Record "Service Ledger Entry";
        ServiceShptHeader: Record "Service Shipment Header";
        ServiceShptLine: Record "Service Shipment Line";
        ServiceShptItemLine: Record "Service Shipment Item Line";
    begin
        Rec.Reset();
        Rec.DeleteAll(false);
        ServiceShptHeader.SetCurrentKey("Order No.");
        ServiceShptHeader.SetRange("Order No.", OrderNo);
        if not ServiceShptHeader.FindFirst() then
            exit;
        ServiceLedgerEntry.SetRange("Document Type", ServiceLedgerEntry."Document Type"::Shipment);
        ServiceLedgerEntry.SetRange("Document No.", ServiceShptHeader."No.");
        if ServiceLedgerEntry.FindSet() then
            repeat
                Rec.SetRange("Item No. (Serviced)", ServiceLedgerEntry."Item No. (Serviced)");
                Rec.SetRange("Serial No. (Serviced)", ServiceLedgerEntry."Serial No. (Serviced)");
                if Rec.IsEmpty() then begin
                    ServiceShptLine.Get(ServiceLedgerEntry."Document No.", ServiceLedgerEntry."Document Line No.");
                    if ServiceShptLine.Get(ServiceShptLine."Document No.", ServiceShptLine."Line No.") then;
                    Rec := ServiceLedgerEntry;
                    Rec."Service Item No. (Serviced)" := ServiceShptItemLine."Service Item No.";
                    Rec."BA Description 2" := ServiceShptLine."Description 2";
                    Rec."Moved from Prepaid Acc." := ServiceShptLine.Warranty;
                    Rec."Service Price Group Code" := ServiceShptLine."Service Price Group Code";
                    Rec."Bin Code" := ServiceShptItemLine."Loaner No.";
                    Rec.Insert(false);
                end;
            until ServiceLedgerEntry.Next() = 0;
        Rec.Reset();
        CurrPage.Update(true);
    end;
}