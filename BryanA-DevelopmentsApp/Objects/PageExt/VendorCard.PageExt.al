pageextension 80056 "BA Vendor Card" extends "Vendor Card"
{
    layout
    {
        modify("Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
        }
        addafter("Post Code")
        {
            field("BA Country/Region Code"; "Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
            }
        }
    }
}