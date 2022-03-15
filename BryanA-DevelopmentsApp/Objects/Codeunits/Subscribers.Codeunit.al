codeunit 75010 "BA SEI Subscibers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeOnRun', '', false, false)]
    local procedure SalesQuoteToOrderOnBeforeRun(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader."BA Copied Doc." := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Invoice", 'OnBeforeOnRun', '', false, false)]
    local procedure SalesQuoteToInvoiceOnBeforeRun(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader."BA Copied Doc." := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInitRecord', '', false, false)]
    local procedure SalesHeaderOnAfterInitRecord(var SalesHeader: Record "Sales Header")
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Quote then
            SalesHeader.Validate("ENC Stage", SalesHeader."ENC Stage"::Open);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCheckItemAvailabilityInLinesOnAfterSetFilters', '', false, false)]
    local procedure SalesHeaderOnCheckItemAvailabilityInLinesOnAfterSetFilters(var SalesLine: Record "Sales Line")
    begin
        SalesLine.SetFilter("Shipment Date", '<>%1', 0D);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnAfterCode', '', false, false)]
    local procedure WhseActivityPostOnAfterCode(var WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        SalesLine: Record "Sales Line";
    begin
        if (WarehouseActivityLine."Source Type" <> Database::"Sales Line")
            or (WarehouseActivityLine."Source Subtype" <> WarehouseActivityLine."Source Subtype"::"1") then
            exit;
        if not SalesLine.Get(SalesLine."Document Type"::Order, WarehouseActivityLine."Source No.", WarehouseActivityLine."Source Line No.") then
            exit;
        SalesLine.Validate("Qty. to Invoice", WarehouseActivityLine.Quantity);
        SalesLine.Modify(true);
    end;
}