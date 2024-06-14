page 50077 "BA Sub-Segment List"
{
    Caption = 'Sub-Segment List';
    AdditionalSearchTerms = 'SubSegment';
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTable = "BA Sub-Segment";
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