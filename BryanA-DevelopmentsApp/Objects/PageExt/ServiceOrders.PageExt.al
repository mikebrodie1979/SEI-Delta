pageextension 80092 "BA Service Orders" extends "Service Orders"
{
    layout
    {
        addlast(Control1)
        {
            field("BA Amount"; Rec."BA Amount")
            {
                ApplicationArea = all;
            }
            field("BA Amount Including VAT"; Rec."BA Amount Including Tax")
            {
                ApplicationArea = all;
            }
            field("BA Amount Including VAT (LCY)"; Rec."BA Amount Including Tax (LCY)")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("BA Quote Date"; Rec."BA Quote Date")
            {
                ApplicationArea = all;
            }
            field("BA Order Date"; Rec."Order Date")
            {
                ApplicationArea = all;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("BA Amount", "BA Amount Including Tax", "BA Amount Including Tax (LCY)");
    end;
}