pageextension 80180 "BA Prod. BOM Version" extends "Production BOM Version"
{
    layout
    {
        addafter("Last Date Modified")
        {
            field("BA Creation Date"; Rec."BA Creation Date")
            {
                ApplicationArea = all;
            }
            field("BA Created By"; Rec."BA Created By")
            {
                ApplicationArea = all;
            }
        }
    }
}