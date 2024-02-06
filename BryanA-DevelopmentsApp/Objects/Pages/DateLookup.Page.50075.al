page 50075 "BA Date Lookup"
{
    PageType = ConfirmationDialog;
    Caption = 'Select Posting Date';
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            field(Date; DateVar)
            {
                ApplicationArea = all;
                ShowMandatory = true;
            }
        }
    }

    procedure GetDate(): Date
    begin
        exit(DateVar);
    end;

    var
        DateVar: Date;
}