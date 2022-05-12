pageextension 80024 "BA Relased Prod. Orders" extends "Released Production Orders"
{
    layout
    {
        addlast(Control1)
        {
            field("BA NC Work Completed"; Rec."BA NC Work Completed")
            {
                ApplicationArea = all;
            }
        }
    }
}