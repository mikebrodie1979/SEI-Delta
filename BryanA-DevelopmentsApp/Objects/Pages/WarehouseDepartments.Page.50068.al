page 50068 "BA Warehouse Departments"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "BA Warehouse Department";
    PageType = List;
    Caption = 'Warehouse Departments';
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
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}