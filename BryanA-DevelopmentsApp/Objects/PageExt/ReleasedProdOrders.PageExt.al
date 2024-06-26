pageextension 80024 "BA Relased Prod. Orders" extends "Released Production Orders"
{
    layout
    {
        addlast(Control1)
        {
            field("BA NC Work Completed"; Rec."BA NC Work Completed")
            {
                ApplicationArea = all;
            }
            field("BA All Quantities Completed"; Rec."BA All Quantities Completed")
            {
                ApplicationArea = all;
            }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = all;
            }
            field("BA Created By"; Rec."BA Created By")
            {
                ApplicationArea = all;
            }
            field("BA Assigned Dept."; "BA Assigned Dept.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Source No.")
        {
            field("BA Source Version"; Rec."BA Source Version")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action("Update Source Versions")
            {
                Image = UpdateDescription;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = report "BA Set Prod. Order Version";
            }
        }
    }
}