pageextension 80135 "BA Company Information" extends "Company Information"
{
    layout
    {
        addlast("System Indicator")
        {
            field("BA Environment Name"; Rec."BA Environment Name")
            {
                ApplicationArea = all;
                ShowMandatory = true;
            }
        }
    }
}