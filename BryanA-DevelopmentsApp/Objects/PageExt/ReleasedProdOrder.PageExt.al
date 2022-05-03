pageextension 80010 "BA Released Prod. Order" extends "Released Production Order"
{
    layout
    {
        addafter(Blocked)
        {
            field("BA NC Work Completed"; "BA NC Work Completed")
            {
                ApplicationArea = all;
            }
        }
    }
}