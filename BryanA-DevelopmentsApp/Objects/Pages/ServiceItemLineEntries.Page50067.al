page 50067 "BA Service Item Line Entries"
{
    PageType = ListPart;
    SourceTable = "BA Service Item Line Entry";
    Editable = false;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                }
                field("No. 2"; "No. 2")
                {
                    ApplicationArea = all;
                }
                field("Service Item No."; Rec."Service Item No.")
                {
                    ApplicationArea = all;
                }
                field("Service Item Group Code"; Rec."Service Item Group Code")
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
                field("Repair Status Code"; "Repair Status Code")
                {
                    ApplicationArea = all;
                }
                field(Warranty; Warranty)
                {
                    ApplicationArea = all;
                }
                field("Contract No."; "Contract No.")
                {
                    ApplicationArea = all;
                }
                field("Service Price Group Code"; "Service Price Group Code")
                {
                    ApplicationArea = all;
                }
                field(Priority; Priority)
                {
                    ApplicationArea = all;
                }
                field("Response Time (Hours)"; "Response Time (Hours)")
                {
                    ApplicationArea = all;
                }
                field("Response Date"; "Response Date")
                {
                    ApplicationArea = all;
                }
                field("Response Time"; "Response Time")
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
}