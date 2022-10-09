pageextension 80045 "BA Customer Card" extends "Customer Card"
{
    layout
    {
        addlast(Content)
        {
            group("Account & System Control")
            {
                field(Blocked2; Rec.Blocked)
                {
                    ApplicationArea = all;
                }
                field("Privacy Blocked2"; Rec."Privacy Blocked")
                {
                    ApplicationArea = all;
                }
                field("ENC Country/Region Mandatory"; Rec."ENC Country/Region Mandatory")
                {
                    ApplicationArea = all;
                }
                field("ENC Salesperson Code Mandatory"; Rec."ENC Salesperson Code Mandatory")
                {
                    ApplicationArea = all;
                }
                field("BA Int. Customer"; Rec."BA Int. Customer")
                {
                    ApplicationArea = all;
                }
                field("BA Serv. Int. Customer"; Rec."BA Serv. Int. Customer")
                {
                    ApplicationArea = all;
                }
                field("IC Partner Code2"; Rec."IC Partner Code")
                {
                    ApplicationArea = all;
                }
                field("Service Zone Code2"; Rec."Service Zone Code")
                {
                    ApplicationArea = all;
                }
                field("ENC CRM GUID"; Rec."ENC CRM GUID")
                {
                    ApplicationArea = all;
                }
            }

        }
        modify(Blocked)
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("Privacy Blocked")
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("IC Partner Code")
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("Service Zone Code")
        {
            ApplicationArea = all;
            Visible = false;
        }

        addafter("Post Code")
        {
            field("BA Region"; Rec."BA Region")
            {
                ApplicationArea = all;
            }
        }
        addfirst(AddressDetails)
        {
            field("BA Country/Region Code"; "Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
            }
        }
        addafter(County)
        {
            field("BA County Fullname"; "BA County Fullname")
            {
                ApplicationArea = all;
            }
        }
        modify("Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
            Editable = false;
        }
        modify(County)
        {
            trigger OnAfterValidate()
            begin
                Rec.CalcFields("BA County Fullname");
            end;
        }
        modify("Customer Posting Group")
        {
            trigger OnAfterValidate()
            begin
                UpdateBalanaceDisplay();
            end;
        }
        modify("Balance (LCY)")
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("Balance Due (LCY)")
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("Credit Limit (LCY)")
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify(TotalSales2)
        {
            ApplicationArea = all;
            Visible = false;

        }
        addafter(TotalSales2)
        {
            group("Total Sales")
            {
                ShowCaption = false;
                Visible = ShowLCYBalances;
                field("TotalSales"; GetTotalSales())
                {
                    ApplicationArea = all;
                    Caption = 'Total Sales';
                    Style = Strong;
                    ToolTip = 'Specifies your total sales turnover with the customer in the current fiscal year. It is calculated from amounts excluding tax on all completed and open invoices and credit memos.';
                }
            }
            group("Non-LCY Sales")
            {
                ShowCaption = false;
                Visible = not ShowLCYBalances;
                field("TotalSales Non-LCY"; NonLCYCustomerStatistics.GetSales(Rec))
                {
                    ApplicationArea = all;
                    Caption = 'Total Sales';
                    Style = Strong;
                    ToolTip = 'Specifies your total sales turnover with the customer in the current fiscal year. It is calculated from amounts excluding tax on all completed and open invoices and credit memos.';
                }
            }
        }
        addafter("Balance (LCY)")
        {
            group("BA Local Balances")
            {
                Visible = ShowLCYBalances;
                ShowCaption = false;
                field("Credit Limit (LCY)2"; "Credit Limit (LCY)")
                {
                    ApplicationArea = all;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.';
                }
                field("BA Balance (LCY)"; "Balance (LCY)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer''s balance.';
                }
                field("BA Balance Due (LCY)"; "Balance Due (LCY)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies payments from the customer that are overdue per today''s date.';
                }
            }
            group("BA Non-Local Balances")
            {
                Visible = not ShowLCYBalances;
                ShowCaption = false;
                field("BA Credit Limit"; "BA Credit Limit")
                {
                    ApplicationArea = all;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.';
                }
                field("BA Balance"; Balance)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer''s balance.';
                }
                field("BA Balance Due"; "Balance Due")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies payments from the customer that are overdue per today''s date.';
                }
            }
        }
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
        [InDataSet]
        StyleTxt: Text;
        NonLCYCustomerStatistics: Page "BA Non-LCY Cust. Stat. Factbox";
        AccountingPeriod: Record "Accounting Period";


    trigger OnAfterGetRecord()
    var
        CustomDetailsFactbox: page "Customer Details FactBox";
    begin
        UpdateBalanaceDisplay();
        StyleTxt := '';
        if ShowLCYBalances then
            StyleTxt := Rec.SetStyle()
        else
            if CustomDetailsFactbox.CalcAvailableCreditNonLCY(Rec) < 0 then
                StyleTxt := 'Unfavorable';
        GetTotalSales();
    end;

    local procedure UpdateBalanaceDisplay()
    var
        CustPostingGroup: Record "Customer Posting Group";
    begin
        ShowLCYBalances := CustPostingGroup.Get(Rec."Customer Posting Group") and not CustPostingGroup."BA Show Non-Local Currency";
    end;



    local procedure GetTotalSales(): Decimal
    var
        AmountOnPostedInvoices: Decimal;
        AmountOnPostedCrMemos: Decimal;
        AmountOnOutstandingInvoices: Decimal;
        AmountOnOutstandingCrMemos: Decimal;
        NoPostedInvoices: Integer;
        NoPostedCrMemos: Integer;
        NoOutstandingInvoices: Integer;
        NoOutstandingCrMemos: Integer;
        Totals: Decimal;
        CustomerMgt: Codeunit "Customer Mgt.";
    begin
        AmountOnPostedInvoices := CustomerMgt.CalcAmountsOnPostedInvoices("No.", NoPostedInvoices);
        AmountOnPostedCrMemos := CustomerMgt.CalcAmountsOnPostedCrMemos("No.", NoPostedCrMemos);
        AmountOnOutstandingInvoices := CustomerMgt.CalculateAmountsOnUnpostedInvoices("No.", NoOutstandingInvoices);
        AmountOnOutstandingCrMemos := CustomerMgt.CalculateAmountsOnUnpostedCrMemos("No.", NoOutstandingCrMemos);
        Totals := AmountOnPostedInvoices + AmountOnPostedCrMemos + AmountOnOutstandingInvoices + AmountOnOutstandingCrMemos;
        CustomerMgt.CalculateStatistic(Rec, AdjmtCost, AdjCustProfit, AdjProfitPct,
              CustInvDiscAmount, CustPayments, CustSales, CustProfit);
        EXIT(Totals)
    end;


    // local procedure CalculateStatistic(Customer: Record Customer; VAR AdjmtCost: Decimal; VAR AdjCustProfit: Decimal; VAR AdjProfitPct: Decimal; VAR CustInvDiscAmount: Decimal; VAR CustPayments: Decimal; VAR CustSales: Decimal; VAR CustProfit: Decimal)
    // var
    //     CostCalcuMgt: Codeunit "Cost Calculation Management";
    //     StartDate: Date;
    //     EndDate: Date;
    // begin
    //     WITH Customer DO BEGIN
    //         StartDate := AccountingPeriod.GetFiscalYearStartDate(WorkDate());
    //         EndDate := AccountingPeriod.GetFiscalYearEndDate(WorkDate());
    //         SetRange("Date Filter", StartDate, EndDate);

    //         CustSales := NonLCYCustomerStatistics.GetSales(Rec);
    //         CustProfit := GetProfit() + CostCalcuMgt.NonInvtblCostAmt(Customer);
    //         AdjmtCost := CustSales - CustProfit + CostCalcuMgt.CalcCustActualCostLCY(Customer);
    //         AdjCustProfit := CustProfit + AdjmtCost;

    //         IF CustSales <> 0 THEN
    //             AdjProfitPct := ROUND(100 * AdjCustProfit / CustSales, 0.1)
    //         ELSE
    //             AdjProfitPct := 0;

    //         CustInvDiscAmount := GetInvoiceDiscount();
    //         CustPayments := Payments;
    //     END;
    // end;


    // local procedure GetProfit(): Decimal
    // var
    //     CustLedgerEntry: Record "Cust. Ledger Entry";
    //     TotalProfit: Decimal;
    //     ExchangeRate: Decimal;
    // begin
    //     SetCustLedgeEntryFilters(CustLedgerEntry);
    //     if not CustLedgerEntry.FindSet() then
    //         exit(0);
    //     repeat
    //         CustLedgerEntry.CalcFields(Amount, "Amount (LCY)");
    //         if (CustLedgerEntry."Amount (LCY)" <> 0) then begin
    //             ExchangeRate := CustLedgerEntry.Amount / CustLedgerEntry."Amount (LCY)";
    //             if ExchangeRate <> 0 then
    //                 TotalProfit += CustLedgerEntry."Profit (LCY)" * ExchangeRate;
    //         end;
    //     until CustLedgerEntry.Next() = 0;
    //     exit(TotalProfit);
    // end;



    // local procedure SetCustLedgeEntryFilters(var CustLedgerEntry: Record "Cust. Ledger Entry")
    // var
    //     StartDate: Date;
    //     EndDate: Date;
    // begin
    //     StartDate := AccountingPeriod.GetFiscalYearStartDate(WorkDate());
    //     EndDate := AccountingPeriod.GetFiscalYearEndDate(WorkDate());
    //     CustLedgerEntry.SetRange("Customer No.", Rec."No.");
    //     CustLedgerEntry.SetRange("Global Dimension 1 Code", Rec."Global Dimension 1 Code");
    //     CustLedgerEntry.SetRange("Global Dimension 2 Code", Rec."Global Dimension 2 Code");
    //     CustLedgerEntry.SetRange("Posting Date", StartDate, EndDate);
    //     CustLedgerEntry.SetRange("Currency Code", Rec."Currency Code");
    // end;

    // local procedure GetInvoiceDiscount(): Decimal
    // var
    //     CustLedgerEntry: Record "Cust. Ledger Entry";
    //     TotalProfit: Decimal;
    //     ExchangeRate: Decimal;
    //     StartDate: Date;
    //     EndDate: Date;
    // begin
    //     SetCustLedgeEntryFilters(CustLedgerEntry);
    //     if CustLedgerEntry.FindSet() then
    //         exit(0);
    //     repeat
    //         CustLedgerEntry.CalcFields(Amount, "Amount (LCY)");
    //         if (CustLedgerEntry."Amount (LCY)" <> 0) then begin
    //             ExchangeRate := CustLedgerEntry.Amount / CustLedgerEntry."Amount (LCY)";
    //             if ExchangeRate <> 0 then
    //                 TotalProfit += CustLedgerEntry."Inv. Discount (LCY)" * ExchangeRate;
    //         end;
    //     until CustLedgerEntry.Next() = 0;
    //     exit(TotalProfit);
    // end;


    var
        AdjmtCost: Decimal;
        AdjCustProfit: Decimal;
        AdjProfitPct: Decimal;
        CustInvDiscAmount: Decimal;
        CustPayments: Decimal;
        CustSales: Decimal;
        CustProfit: Decimal;
}