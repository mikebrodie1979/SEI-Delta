pageextension 80009 "BA Item Card" extends "Item Card"
{
    layout
    {
        addafter("Last Direct Cost")
        {
            field("BA Last USD Purch. Cost"; "BA Last USD Purch. Cost")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the most recent USD purchase unit cost for the item.';
            }
        }
    }
}