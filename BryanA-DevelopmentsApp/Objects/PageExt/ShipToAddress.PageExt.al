pageextension 80049 "BA Ship-to Address" extends "Ship-to Address"
{
    layout
    {
        modify(GLN)
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("Fax No.")
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("Home Page")
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("Service Zone Code")
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("Country/Region Code")
        {
            ApplicationArea = all;
            Caption = 'Country';
        }
        modify("Shipment Method Code")
        {
            ApplicationArea = all;
            Caption = 'Freight Carrier';
        }
        modify("Shipping Agent Code")
        {
            ApplicationArea = all;
            Caption = 'Service Level';
        }
        modify("Shipping Agent Service Code")
        {
            ApplicationArea = all;
            Caption = 'Freight Term';
        }
    }
}