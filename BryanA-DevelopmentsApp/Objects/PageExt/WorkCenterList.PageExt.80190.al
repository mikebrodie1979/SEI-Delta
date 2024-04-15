pageextension 80190 "BA Work Center List" extends "Work Center List"
{
    layout
    {
        addlast(Control1)
        {
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = all;
            }
            field("BA Description"; Rec."BA Description")
            {
                ApplicationArea = all;
            }
            field("BA Bambi Only Center"; Rec."BA Bambi Only Center")
            {
                ApplicationArea = all;
            }
            field("BA Hourly Rate"; Rec."BA Hourly Rate")
            {
                ApplicationArea = all;
            }
        }
    }
}