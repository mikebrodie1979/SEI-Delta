page 50072 "BA Product Profiles"
{
    UsageCategory = Lists;
    ApplicationArea = all;
    Caption = 'Product Profiles';
    SourceTable = "BA Product Profile";
    PageType = List;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {
                field("Product Code"; Rec."Product Code")
                {
                    ApplicationArea = all;
                    ShowMandatory = true;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("Core Product Code"; Rec."Core Product Code")
                {
                    ApplicationArea = all;
                }
                field("Core Prod. Sub. Cat. Code"; Rec."Core Prod. Sub. Cat. Code")
                {
                    ApplicationArea = all;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = all;
                }
                field("Item Tracking Code"; Rec."Item Tracking Code")
                {
                    ApplicationArea = all;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Manufacturing Dept."; Rec."Manufacturing Dept.")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = all;
                }
                field("Product ID Code"; Rec."Product ID Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}