pageextension 80164 "BA Posted Transfer Shpts." extends "Posted Transfer Shipments"
{
    layout
    {
        modify("Shipping Agent Code")
        {
            ApplicationArea = all;
            Caption = 'Freight Carrier';
        }
        modify("Shipment Method Code")
        {
            ApplicationArea = all;
            Caption = 'Service Level';
        }
        addlast(Control1)
        {
            field("ENC Freight Term"; "ENC Freight Term")
            {
                ApplicationArea = all;
            }
            field("ENC Package Tracking No."; "ENC Package Tracking No.")
            {
                ApplicationArea = all;
            }
            field("ENC Physical Ship Date"; "ENC Physical Ship Date")
            {
                ApplicationArea = all;
            }
        }
    }
}