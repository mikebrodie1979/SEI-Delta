pageextension 80008 "BA Purch. & Payables Setup" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Order Nos.")
        {
            field("BA Requisition Nos."; Rec."BA Requisition Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the code for the number series that will be used to assign numbers to requisition orders.';
            }
            field("BA Requisition Receipt Nos."; Rec."BA Requisition Receipt Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the code for the number series that will be used to assign numbers to posted requisition receipts.';
            }
            field("BA Requisition Return Nos."; Rec."BA Requisition Return Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the code for the number series that will be used to assign numbers to requisition return orders.';
            }
        }
    }
}