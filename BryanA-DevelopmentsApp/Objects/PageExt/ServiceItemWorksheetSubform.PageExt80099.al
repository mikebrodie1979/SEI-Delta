pageextension 80099 "BA Service Item WkSht. Subform" extends "Service Item Worksheet Subform"
{
    layout
    {
        addfirst(Control1)
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = all;
            }
        }
    }
}