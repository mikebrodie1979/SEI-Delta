page 50067 "BA Service Item Lines"
{
    PageType = ListPart;
    SourceTable = "Service Shipment Item Line";
    Editable = false;
    LinksAllowed = false;
    Caption = 'Service Item Lines';
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {
                field("Service Item No."; "Service Item No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                }
                field("Serial No."; "Serial No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = all;
                }
                field(Warranty; Warranty)
                {
                    ApplicationArea = all;
                }
                field("Loaner No."; "Loaner No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    procedure SetSource(OrderNo: Code[20])
    var
        ServiceShptHeader: Record "Service Shipment Header";
    begin
        ServiceShptHeader.SetCurrentKey("Order No.");
        ServiceShptHeader.SetRange("Order No.", OrderNo);
        if not ServiceShptHeader.FindFirst() then;
        Rec.FilterGroup(2);
        Rec.SetRange("No.", ServiceShptHeader."No.");
        Rec.FilterGroup(0);
        CurrPage.Update(false);
    end;
}