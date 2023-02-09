pageextension 80150 "BA Inventory Setup" extends "Inventory Setup"
{
    layout
    {
        addlast(Content)
        {
            group("Item Journal Approval")
            {
                field("BA Approval Required"; Rec."BA Approval Required")
                {
                    ApplicationArea = all;
                }
                field("BA Approval Limit"; Rec."BA Approval Limit")
                {
                    ApplicationArea = all;
                    ShowMandatory = "BA Approval Required";
                }
                field("BA Approval Admin1"; Rec."BA Approval Admin1")
                {
                    ApplicationArea = all;
                    ShowMandatory = "BA Approval Required";
                }
                field("BA Approval Admin2"; Rec."BA Approval Admin2")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}