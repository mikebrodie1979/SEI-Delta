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
                Visible = not ShowTwoDates;
            }
            field(FromDate; FromDate)
            {
                ApplicationArea = all;
                ShowMandatory = true;
                Visible = ShowTwoDates;
                Caption = 'From Date';
            }
            field(ToDate; ToDate)
            {
                ApplicationArea = all;
                ShowMandatory = true;
                Visible = ShowTwoDates;
                Caption = 'To Date';
            }
        }
    }

    procedure GetDate(): Date
    begin
        exit(DateVar);
    end;

    procedure GetDates(var NewFromDate: Date; var NewToDate: Date): Date
    begin
        NewFromDate := FromDate;
        NewToDate := ToDate;
    end;

    procedure SetDates(NewFromDate: Date; NewToDate: Date)
    begin
        FromDate := NewFromDate;
        ToDate := NewToDate;
        ShowTwoDates := true;
    end;

    var
        DateVar: Date;
        FromDate: Date;
        ToDate: Date;
        [InDataSet]
        ShowTwoDates: Boolean;
}