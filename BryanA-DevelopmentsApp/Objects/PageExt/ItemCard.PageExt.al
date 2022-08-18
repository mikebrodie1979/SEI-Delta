pageextension 80009 "BA Item Card" extends "Item Card"
{
    layout
    {
        addafter("Qty. on Sales Order")
        {
            field("BA Qty. on Sales Quote"; Rec."BA Qty. on Sales Quote")
            {
                ApplicationArea = all;
            }
            field("BA Qty. on Closed Sales Quote"; "BA Qty. on Closed Sales Quote")
            {
                ApplicationArea = all;
            }
        }
        addafter("Last Direct Cost")
        {
            field("BA Last USD Purch. Cost"; "BA Last USD Purch. Cost")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the most recent USD purchase unit cost for the item.';
            }
        }
        addafter("Base Unit of Measure")
        {
            field("ENC Is Fabric"; "ENC Is Fabric")
            {
                ApplicationArea = all;
            }
            field("BA ETL Approved Fabric"; "BA ETL Approved Fabric")
            {
                ApplicationArea = all;
            }
            field("ENC Fabric Brand Name"; "ENC Fabric Brand Name")
            {
                ApplicationArea = all;
            }
        }
    }
}