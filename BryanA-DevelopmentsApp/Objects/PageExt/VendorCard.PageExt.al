pageextension 80056 "BA Vendor Card" extends "Vendor Card"
{
    layout
    {
        modify("Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
        }
        addfirst(AddressDetails)
        {
            field("BA Country/Region Code"; "Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
            }
        }
    }
}