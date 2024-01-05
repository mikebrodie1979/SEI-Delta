pageextension 80169 "BA Inventory Setup" extends "Inventory Setup"
{
    layout
    {
        addlast(General)
        {
            field("BA Default Location Code"; "BA Default Location Code")
            {
                ApplicationArea = all;
            }
        }
    }
}