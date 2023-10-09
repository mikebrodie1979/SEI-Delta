pageextension 80085 "BA G/L Account Card" extends "G/L Account Card"
{
    layout
    {
        addlast(General)
        {
            field("BA Require Description Change"; "BA Require Description Change")
            {
                ApplicationArea = all;
            }
        }
    }
}