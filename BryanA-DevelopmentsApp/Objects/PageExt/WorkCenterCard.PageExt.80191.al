pageextension 80191 "BA Work Center Card" extends "Work Center Card"
{
    layout
    {
        addlast(General)
        {
            field("BA Description"; Rec."BA Description")
            {
                ApplicationArea = all;
            }
            field("BA Bambi Only Center"; Rec."BA Bambi Only Center")
            {
                ApplicationArea = all;
            }

        }
        addafter("Unit Cost")
        {
            field("BA Hourly Rate"; Rec."BA Hourly Rate")
            {
                ApplicationArea = all;
            }
        }
    }
}