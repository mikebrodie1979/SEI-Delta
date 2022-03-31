pageextension 80002 "BA Prod. BOM Lines" extends "Production BOM Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("BA Optional"; Rec."BA Optional")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies if the quantity will be set to zero when creating an asscioated Assembly Order.';
            }
        }
    }
}