pageextension 80045 "BA Customer Card" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("BA Int. Customer"; Rec."BA Int. Customer")
            {
                ApplicationArea = all;
            }
            field("BA Serv. Int. Customer"; "BA Serv. Int. Customer")
            {
                ApplicationArea = all;
            }
        }

        addafter("Post Code")
        {
            field("BA Region"; Rec."BA Region")
            {
                ApplicationArea = all;
            }
        }
        addfirst(AddressDetails)
        {
            field("BA Country/Region Code"; "Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
            }
        }
        modify("Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
            Editable = false;
        }
    }
}