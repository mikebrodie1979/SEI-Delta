pageextension 80046 "BA Item List" extends "Item List"
{
    layout
    {
        addlast(Control1)
        {

            field("ENC International HS Code"; Rec."ENC International HS Code")
            {
                ApplicationArea = all;
            }
            field("ENC US HS Code"; Rec."ENC US HS Code")
            {
                ApplicationArea = all;
            }
            field("ENC CUSMA"; Rec."ENC CUSMA")
            {
                ApplicationArea = all;
            }
            field("ENC Producer"; Rec."ENC Producer")
            {
                ApplicationArea = all;
            }
            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = all;
            }
        }
    }
}