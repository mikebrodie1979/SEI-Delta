pageextension 80008 "BA Purch. & Payables Setup" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Order Nos.")
        {
            field("BA Requisition Nos."; "BA Requisition Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the code for the number series that will be used to assign numbers to requisition orders.';
            }
        }
    }
}