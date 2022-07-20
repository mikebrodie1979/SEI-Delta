pageextension 80060 "BA Released Prod. Order Lines" extends "Released Prod. Order Lines"
{
    layout
    {
        addafter("Item No.")
        {
            field("BA NC Work Completed"; "BA NC Work Completed")
            {
                ApplicationArea = all;
            }
        }
    }
}