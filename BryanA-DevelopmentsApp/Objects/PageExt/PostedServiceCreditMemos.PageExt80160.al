pageextension 80160 "BA Posted Service Cr.Memos" extends "Posted Service Credit Memos"
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