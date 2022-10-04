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
                SubPageLink = "No." = field ("Bill-to Customer No.");
                Visible = not ShowLCYBalances;
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