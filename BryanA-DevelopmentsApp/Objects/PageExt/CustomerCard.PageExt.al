pageextension 80045 "BA Customer Card" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("BA Int. Customer"; Rec."BA Int. Customer")
            {
                ApplicationArea = all;
            }
        }
    }
}