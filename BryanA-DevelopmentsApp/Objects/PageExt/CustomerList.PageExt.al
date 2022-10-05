pageextension 80083 "BA Customer List" extends "Customer List"
{
    layout
    {
        modify(CustomerStatisticsFactBox)
        {
            Visible = ShowLCYBalances;
        }
        addafter(CustomerStatisticsFactBox)
        {
            part("BA Non-LCY Customer Statistics Factbox"; "BA Non-LCY Cust. Stat. Factbox")
            {
                SubPageLink = "No." = field ("No."), "Currency Filter" = FIELD ("Currency Filter"), "Date Filter" = FIELD ("Date Filter"),
                "Global Dimension 1 Filter" = FIELD ("Global Dimension 1 Filter"),
                "Global Dimension 2 Filter" = FIELD ("Global Dimension 2 Filter");
                Visible = not ShowLCYBalances;
                ApplicationArea = all;
            }
        }
    }

    var
        [InDataSet]
        ShowLCYBalances: Boolean;

    trigger OnAfterGetRecord()
    var
        CustPostingGroup: Record "Customer Posting Group";
    begin
        ShowLCYBalances := CustPostingGroup.Get(Rec."Customer Posting Group") and not CustPostingGroup."BA Show Non-Local Currency";
    end;
}