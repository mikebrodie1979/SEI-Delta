pageextension 80096 "BA Posted Purch. Inv. Subpage" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("BA Product ID Code"; Rec."BA Product ID Code")
            {
                ApplicationArea = all;
            }
            field("BA Project Code"; Rec."BA Project Code")
            {
                ApplicationArea = all;
            }
        }
        addbefore("Job No.")
        {
            field("BA SEI Order Type."; Rec."BA SEI Order Type")
            {
                ApplicationArea = all;
            }
            field("BA SEI Order No."; Rec."BA SEI Order No.")
            {
                ApplicationArea = all;
            }
            field("BA SEI Invoice No."; Rec."BA SEI Invoice No.")
            {
                ApplicationArea = all;
            }
            field("BA Freight Charge Type"; Rec."BA Freight Charge Type")
            {
                ApplicationArea = all;
            }
        }
    }
}