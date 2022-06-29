tableextension 81016 "BA Ship-to Address" extends "Ship-to Address"
{
    fields
    {
        modify("Country/Region Code")
        {
            Caption = 'Country';
        }
        modify("Shipment Method Code")
        {
            Caption = 'Freight Carrier';
        }
        modify("Shipping Agent Code")
        {
            Caption = 'Service Level';
        }
        modify("Shipping Agent Service Code")
        {
            Caption = 'Freight Term';
        }
        modify(County)
        {
            TableRelation = "BA Province/State".Symbol where ("Country/Region Code" = field ("Country/Region Code"));
        }
    }
}