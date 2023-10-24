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
            field("BA Amount Including VAT"; "BA Amount Including Tax")
            {
                ApplicationArea = all;
            }
            field("BA Amount Including VAT (LCY)"; "BA Amount Including Tax (LCY)")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("BA Amount", "BA Amount Including Tax", "BA Amount Including Tax (LCY)");
    end;
}