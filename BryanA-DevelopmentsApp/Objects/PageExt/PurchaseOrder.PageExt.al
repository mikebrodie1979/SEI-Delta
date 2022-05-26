pageextension 80030 "BA Purchase Order" extends "Purchase Order"
{
    layout
    {
        addbefore("Assigned User ID")
        {
            field("BA Omit Orders"; Rec."BA Omit Orders")
            {
                ApplicationArea = all;
            }
        }
        addbefore("Due Date")
        {
            field("Expected Receipt Date2"; Rec."Expected Receipt Date")
            {
                ApplicationArea = all;
            }
        }
        modify("Expected Receipt Date")
        {
            ApplicationArea = all;
            Visible = false;
        }
    }
}