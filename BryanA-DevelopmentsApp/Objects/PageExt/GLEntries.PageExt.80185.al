pageextension 80185 "BA General Ledger Entries" extends "General Ledger Entries"
{
    layout
    {
        addafter("Posting Date")
        {
            field("BA Actual Posting DateTime"; "BA Actual Posting DateTime")
            {
                ApplicationArea = all;
            }
        }
    }
}