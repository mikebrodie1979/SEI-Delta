pageextension 80166 "BA Posted Deposit" extends "Posted Deposit"
{
    layout
    {
        addlast(General)
        {
            field("BA User ID"; "BA User ID")
            {
                ApplicationArea = all;
            }
        }
    }
}