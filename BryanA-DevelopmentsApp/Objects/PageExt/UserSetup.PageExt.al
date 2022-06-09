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
        }
    }
}