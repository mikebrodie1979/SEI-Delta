page 50076 "BA Segment List"
{
    Caption = 'Segment List';
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTable = "BA Segment";
    LinksAllowed = false;
    PageType = List;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Code; Code)
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