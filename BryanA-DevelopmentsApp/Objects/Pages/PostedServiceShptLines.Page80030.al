page 80030 "BA Posted Service Shpt. Lines"
{
    PageType = ListPart;
    SourceTable = "Service Shipment Line";
    Editable = false;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {
                field("Line No."; "Line No.")
                {
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Service Item Serial No."; Rec."Service Item Serial No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."No.")
                {
                    Caption = 'Item No.';
                    ApplicationArea = all;
                }
                field("Service Item Line No."; "Service Item Line No.")
                {
                    ApplicationArea = all;
                }
                field("Service Item Group Code"; "Service Item Group Code")
                {
                    ApplicationArea = all;
                }
                field("Service Item Line Serial No."; "Service Item Line Serial No.")
                {
                    Caption = 'Serial No.';
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}