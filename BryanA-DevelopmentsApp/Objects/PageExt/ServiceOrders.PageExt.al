pageextension 80092 "BA Service Orders" extends "Service Orders"
{
    layout
    {
        addlast(Control1)
        {
            field("BA Amount"; "BA Amount")
            {
                ApplicationArea = all;
            }
            field("BA Amount Including VAT"; "BA Amount Including VAT")
            {
                ApplicationArea = all;
            }
        }
    }
}