pageextension 80044 "BA User Setup" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("BA Job Title"; Rec."BA Job Title")
            {
                ApplicationArea = all;
            }
            field("BA Allow Changing Counties"; Rec."BA Allow Changing Counties")
            {
                ApplicationArea = all;
            }
            field("BA Allow Changing Regions"; Rec."BA Allow Changing Regions")
            {
                ApplicationArea = all;
            }
            field("BA Allow Changing Countries"; Rec."BA Allow Changing Countries")
            {
                ApplicationArea = all;
            }
            field("BA Receive Job Queue Notes."; Rec."BA Receive Job Queue Notes.")
            {
                ApplicationArea = all;
            }
        }
    }
}