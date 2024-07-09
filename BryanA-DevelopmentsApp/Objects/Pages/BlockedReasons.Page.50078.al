page 50078 "BA Blocked Reasons"
{
    PageType = List;
    SourceTable = "BA Block Reason";
    Caption = 'Blocked Reasons';
    ApplicationArea = all;
    UsageCategory = Lists;
    DelayedInsert = true;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                    ShowMandatory = true;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}