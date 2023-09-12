pageextension 80156 "BA Posted Sales Cr.Memos" extends "Posted Sales Credit Memos"
{
    layout
    {
        addlast(Control1)
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = all;
            }
        }
    }
}