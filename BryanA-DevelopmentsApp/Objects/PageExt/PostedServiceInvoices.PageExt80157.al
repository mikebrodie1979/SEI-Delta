pageextension 80157 "BA Posted Service Invoices" extends "Posted Service Invoices"
{
    layout
    {
        addlast(Control1)
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = all;
            }
        }
        addafter("Posting Date")
        {
            field("BA Actual Posting DateTime"; "BA Actual Posting DateTime")
            {
                ApplicationArea = all;
            }
        }
    }
}