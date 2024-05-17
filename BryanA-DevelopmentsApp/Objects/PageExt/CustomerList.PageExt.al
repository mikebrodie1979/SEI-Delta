pageextension 80083 "BA Customer List" extends "Customer List"
{
    layout
    {
        addafter("Credit Limit (LCY)")
        {
            field("BA Credit Limit"; Rec."BA Credit Limit")
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field("BA Last Sales Activity"; Rec."BA Last Sales Activity")
            {
                ApplicationArea = all;
            }
            field("BA SEI Service Center"; Rec."BA SEI Service Center")
            {
                ApplicationArea = all;
            }
            field("BA SEI Int'l Cust. No."; Rec."BA SEI Int'l Cust. No.")
            {
                ApplicationArea = all;
            }
        }
    }
}