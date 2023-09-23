pageextension 80161 "BA Shipping Agents" extends "Shipping Agents"
{
    layout
    {
        addlast(Control1)
        {
            field("BA Block Tracking No."; Rec."BA Block Tracking No.")
            {
                ApplicationArea = all;
            }
        }
    }
}