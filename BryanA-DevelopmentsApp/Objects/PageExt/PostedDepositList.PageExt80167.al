pageextension 80167 "BA Posted Deposit List" extends "Posted Deposit List"
{
    layout
    {
        addlast(Control1)
        {
            field("BA User ID"; "BA User ID")
            {
                ApplicationArea = all;
            }
            field("BA Actual Posting DateTime"; "BA Actual Posting DateTime")
            {
                ApplicationArea = all;
            }
        }
    }
}