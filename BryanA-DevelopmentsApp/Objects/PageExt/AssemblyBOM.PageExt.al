pageextension 80002 "BA Assembly BOM" extends "Assembly BOM"
{
    layout
    {
        addlast(Control1)
        {
            field("BA Optional"; "BA Optional")
            {
                ApplicationArea = all;
            }
        }
        addafter(Description)
        {
            field("BA Description 2"; "BA Description 2")
            {
                ApplicationArea = all;
            }
        }
    }
}