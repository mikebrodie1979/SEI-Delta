page 50067 "BA Phys. Invt. Import Errors"
{
    // ApplicationArea = all;
    // UsageCategory = Lists;
    SourceTable = "Name/Value Buffer";
    PageType = List;
    Caption = 'Physical Inventory Import Errors';
    Editable = false;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Item No."; Rec.Name)
                {
                    ApplicationArea = all;
                    Caption = 'Item No.';
                }
                field("Line No."; Rec.Value)
                {
                    ApplicationArea = all;
                    Caption = 'Journal Line No.';
                }
                field(Error; Rec."Value Long")
                {
                    ApplicationArea = all;
                    Caption = 'Error';
                }
            }
        }
    }
}