pageextension 80060 "BA Country/Region List" extends "Countries/Regions"
{
    layout
    {
        addafter(Name)
        {
            field("BA Region"; Rec."BA Region")
            {
                ApplicationArea = all;
            }
        }
    }
}