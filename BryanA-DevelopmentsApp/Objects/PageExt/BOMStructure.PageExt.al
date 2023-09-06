pageextension 80090 "BA BOM Structure" extends "BOM Structure"
{
    layout
    {
        addafter(Description)
        {
            field("BA Description 2"; "BA Description 2")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
}