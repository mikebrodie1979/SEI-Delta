report 50082 "BA Fix Item Dim. Values"
{
    UsageCategory = Tasks;
    ApplicationArea = all;
    ProcessingOnly = true;
    Caption = 'Fix Item Dimensions';

    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnAfterGetRecord()
            var
                ItemCard: Page "Item Card";
            begin
                if ItemCard.CheckToUpdateDimValues(Item) then begin
                    Item.Modify(false);
                    i += 1;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Message('Updated %1 items.', i);
            end;
        }
    }

    var
        i: Integer;
}