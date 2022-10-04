page 50062 "BA Non-LCY Cust. Stat. Factbox"
{
    Caption = 'Customer Statistics Factbox';
    PageType = CardPart;
    SourceTable = Customer;
    Editable = false;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = all;
                Caption = 'Customer No.';

                trigger OnDrillDown()
                begin
                    PAGE.RUN(PAGE::"Customer Card", Rec);
                end;
            }
            field(Balance; Rec.Balance)
            {
                ApplicationArea = all;
            }
            group(Sales)
            {
                field("Outstanding Orders"; Rec."Outstanding Orders")
                {
                    ApplicationArea = all;
                }
                field("Shipped Not Invoiced"; Rec."Shipped Not Invoiced")
                {
                    ApplicationArea = all;
                }
                field("Outstanding Invoices"; Rec."Outstanding Invoices")
                {
                    ApplicationArea = all;
                }
            }
            group(Services)
            {
                field("BA Outstanding Serv. Orders"; Rec."BA Outstanding Serv. Orders")
                {
                    ApplicationArea = all;
                }
                field("BA Serv Shipped Not Invoiced"; Rec."BA Serv Shipped Not Invoiced")
                {
                    ApplicationArea = all;
                }
                field("BA Outstanding Serv.Invoices"; Rec."BA Outstanding Serv.Invoices")
                {
                    ApplicationArea = all;
                }
            }
            group(PaymentsGroup)
            {
                Caption = 'Payments';
                field(Payments; Rec.Payments)
                {
                    ApplicationArea = all;
                }
                field(Refunds; Rec.Refunds)
                {
                    ApplicationArea = all;
                }
                field("Last Receipt Payment Date"; CalcLastPaymentDate())
                {
                    ApplicationArea = all;

                    trigger OnDrillDown()
                    var
                        CustLedgerEntry: Record "Cust. Ledger Entry";
                        CustomerLedgerEntries: Page "Customer Ledger Entries";
                    begin
                        CLEAR(CustomerLedgerEntries);
                        SetFilterLastPaymentDateEntry(CustLedgerEntry);
                        IF CustLedgerEntry.FINDLAST THEN
                            CustomerLedgerEntries.SETRECORD(CustLedgerEntry);
                        CustomerLedgerEntries.SETTABLEVIEW(CustLedgerEntry);
                        CustomerLedgerEntries.RUN;
                    end;
                }
            }
            field(GetTotalAmountLCY; GetTotalAmount())
            {
                Caption = 'Total';
                ApplicationArea = all;
                Style = Strong;
            }
            field("Credit Limit (LCY)"; Rec."BA Credit Limit")
            {
                ApplicationArea = all;
            }
            field(CalcOverdueBalance; CalcOverdueBalanceNonLCY())
            {
                ApplicationArea = all;
                Caption = 'Overdue Amount';

                trigger OnDrillDown()
                var
                    CustLedgEntry: Record "Cust. Ledger Entry";
                    DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                begin
                    DtldCustLedgEntry.SETFILTER("Customer No.", Rec."No.");
                    COPYFILTER("Global Dimension 1 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 1");
                    COPYFILTER("Global Dimension 2 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 2");
                    COPYFILTER("Currency Filter", DtldCustLedgEntry."Currency Code");
                    CustLedgEntry.DrillDownOnOverdueEntries(DtldCustLedgEntry);
                end;
            }
            field(GetSalesLCY2; GetSales())
            {
                Caption = 'Total Sales';
                ApplicationArea = all;

                trigger OnDrillDown()
                var
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgEntry.SETRANGE("Customer No.", Rec."No.");
                    CustLedgEntry.SETRANGE("Posting Date", AccountingPeriod.GetFiscalYearStartDate(WORKDATE),
                        AccountingPeriod.GetFiscalYearEndDate(WORKDATE));
                    PAGE.RUNMODAL(PAGE::"Customer Ledger Entries", CustLedgEntry);
                end;
            }
            field(GetInvoicedPrepmtAmount2; GetInvoicedPrepmtAmount())
            {
                Caption = 'Invoiced Prepayment Amount';
                ApplicationArea = all;
            }
        }
    }

    var
        AccountingPeriod: Record "Accounting Period";

    local procedure GetSales(): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";

        StartDate: Date;
        EndDate: Date;
        SalesAmt: Decimal;
    begin
        StartDate := AccountingPeriod.GetFiscalYearStartDate(WORKDATE);
        EndDate := AccountingPeriod.GetFiscalYearEndDate(WORKDATE);

        CustLedgerEntry.SetRange("Customer No.", Rec."No.");
        CustLedgerEntry.SetRange("Currency Code", Rec."Currency Code");
        CustLedgerEntry.SetRange("Posting Date", StartDate, EndDate);
        CustLedgerEntry.SetRange("Date Filter", StartDate, EndDate);
        CustLedgerEntry.SecurityFiltering(SecurityFiltering());
        CustLedgerEntry.SetFilter("Document Type", '<>%1', CustLedgerEntry."Document Type"::Payment);
        if not CustLedgerEntry.FindSet() then
            exit(0);
        repeat
            CustLedgerEntry.CalcFields(Amount);
            SalesAmt += CustLedgerEntry.Amount;
        until CustLedgerEntry.Next() = 0;
        exit(SalesAmt);
    end;




    local procedure SetFilterLastPaymentDateEntry(VAR CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgerEntry.SETCURRENTKEY("Document Type", "Customer No.", "Posting Date", "Currency Code");
        CustLedgerEntry.SETRANGE("Customer No.", "No.");
        CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Payment);
        CustLedgerEntry.SETRANGE(Reversed, FALSE);
    end;


    local procedure CalcLastPaymentDate(): Date
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        SetFilterLastPaymentDateEntry(CustLedgerEntry);
        IF CustLedgerEntry.FINDLAST THEN;
        EXIT(CustLedgerEntry."Posting Date");
    end;

    procedure GetTotalAmount(): Decimal
    begin
        Rec.CalcFields("Balance", "Outstanding Orders", "Shipped Not Invoiced", "Outstanding Invoices",
             "BA Outstanding Serv. Orders", "BA Outstanding Serv. Orders", "BA Outstanding Serv.Invoices");

        EXIT(GetTotalAmountCommon());
    end;

    local procedure GetTotalAmountCommon(): Decimal
    var
        SalesLine: Record "Sales Line";
        ServiceLine: Record "Service Line";
    begin
        EXIT("Balance" + "Outstanding Orders" + "Shipped Not Invoiced" + "Outstanding Invoices" +
            "BA Outstanding Serv. Orders" + "BA Outstanding Serv.Invoices" + "BA Serv Shipped Not Invoiced" -
            SalesLine.OutstandingInvoiceAmountFromShipment("No.") - ServiceLine.OutstandingInvoiceAmountFromShipment("No.")
            - GetInvoicedPrepmtAmount() - GetReturnRcdNotInvAmount());
    end;

    local procedure GetInvoicedPrepmtAmount(): Decimal
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SETCURRENTKEY("Document Type", "Bill-to Customer No.");
        SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SETRANGE("Bill-to Customer No.", "No.");
        SalesLine.CALCSUMS("Prepmt. Amt. Inv.", "Prepmt. Amt. Incl. VAT");
        EXIT(SalesLine."Prepmt. Amt. Inv." + SalesLine."Prepmt. Amt. Incl. VAT");
    end;

    local procedure GetReturnRcdNotInvAmount(): Decimal
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SETCURRENTKEY("Document Type", "Bill-to Customer No.");
        SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::"Return Order");
        SalesLine.SETRANGE("Bill-to Customer No.", "No.");
        SalesLine.CALCSUMS("Return Rcd. Not Invd.");
        EXIT(SalesLine."Return Rcd. Not Invd.");
    end;



    local procedure CalcOverdueBalanceNonLCY(): Decimal
    var
        CustLedgEntryRemainAmtQuery: Query "Cust. Ledg. Entry Remain. Amt.";
    begin
        CustLedgEntryRemainAmtQuery.SETRANGE(Customer_No, "No.");
        CustLedgEntryRemainAmtQuery.SETRANGE(IsOpen, TRUE);
        CustLedgEntryRemainAmtQuery.SETFILTER(Due_Date, '<%1', WORKDATE);
        CustLedgEntryRemainAmtQuery.Open();
        IF CustLedgEntryRemainAmtQuery.Read THEN
            exit(CustLedgEntryRemainAmtQuery.Sum_Remaining_Amount);
    end;

}