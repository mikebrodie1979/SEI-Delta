report 50071 "BA Update Exchange Rate"
{
    Caption = 'Update Exchange Rate';
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Exchange Rate"; ExchangeRate)
                {
                    ApplicationArea = all;
                    ShowMandatory = true;
                }
            }
        }
    }

    trigger OnPostReport()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
    begin
        if ExchangeRate = 0 then
            Error(NoExchangeRateErr);
        SalesHeader.Get(SourceRecID);
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if not SalesLine.FindSet(true) then
            exit;
        SalesHeader."BA Manual Exch. Rate" := ExchangeRate;
        SalesHeader."BA Use Manual Exch. Rate" := true;
        SalesHeader.Modify(false);
        repeat
            SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, 0);
            SalesLine.Modify(true);
        until SalesLine.Next() = 0;
        SalesHeader.Get(SalesHeader.RecordId());
        SalesHeader."BA Manual Exch. Rate" := 0;
        SalesHeader."BA Use Manual Exch. Rate" := false;
        SalesHeader.Modify(false);
        Finished := true;
    end;

    procedure SetSource(RecID: RecordId)
    begin
        SourceRecID := RecID;
    end;


    var
        SourceRecID: RecordId;
        ExchangeRate: Decimal;
        Finished: Boolean;

        NoExchangeRateErr: Label 'Exchange Rate must have a value.';
}