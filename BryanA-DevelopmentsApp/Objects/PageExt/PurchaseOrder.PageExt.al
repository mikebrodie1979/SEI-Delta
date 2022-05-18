pageextension 80030 "BA Purchase Order" extends "Purchase Order"
{
    layout
    {
        addbefore("Assigned User ID")
        {
            field("BA Omit Orders"; "BA Omit Orders")
            {
                ApplicationArea = all;
            }
        }
    }
}