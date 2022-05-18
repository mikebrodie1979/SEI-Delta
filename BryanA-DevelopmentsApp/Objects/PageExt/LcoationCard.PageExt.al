pageextension 80035 "BA Location Card" extends "Location Card"
{
    layout
    {
        addlast(ContactDetails)
        {
            field("BA FID No."; Rec."BA FID No.")
            {
                ApplicationArea = all;
            }
        }
    }
}