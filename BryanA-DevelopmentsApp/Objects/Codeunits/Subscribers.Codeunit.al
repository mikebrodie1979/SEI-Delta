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


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnCodeOnAfterCreatePostedWhseActivDocument', '', false, false)]
    local procedure WhseActivityPostOnAfterWhseActivLineModify(var WhseActivityHeader: Record "Warehouse Activity Header")
    var
        WhseActivityLine: Record "Warehouse Activity Line";
        SalesLine: Record "Sales Line";
    begin
        WhseActivityLine.SetRange("Activity Type", WhseActivityHeader.Type);
        WhseActivityLine.SetRange("No.", WhseActivityHeader."No.");
        WhseActivityLine.SetRange("Source Type", Database::"Sales Line");
        WhseActivityLine.SetRange("Source Subtype", WhseActivityLine."Source Subtype"::"1");
        WhseActivityLine.SetFilter("Qty. to Handle", '>%1', 0);
        if WhseActivityLine.FindSet() then
            repeat
                if SalesLine.Get(SalesLine."Document Type"::Order, WhseActivityLine."Source No.", WhseActivityLine."Source Line No.") then begin
                    SalesLine.Validate("Qty. to Invoice", WhseActivityLine.Quantity);
                    SalesLine.Modify(true);
                end;
            until WhseActivityLine.Next() = 0;
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Assembly Line", 'OnAfterInsertEvent', '', false, false)]
    // local procedure derp(var Rec: Record "Assembly Line")
    // begin
    //     if not Rec.IsTemporary then
    //         Error(Format(Rec.RecordId()));
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly Line Management", 'OnAfterTransferBOMComponent', '', false, false)]
    local procedure AssemblyLineMgtOnAfterTransferBOMComponent(var AssemblyLine: Record "Assembly Line"; BOMComponent: Record "BOM Component")
    var
        BOMHeader: Record "Production BOM Header";
        BOMLine: Record "Production BOM Line";
    begin
        if not BOMHeader.Get(BOMComponent."Parent Item No.") then
            exit;
        if not BOMLine.Get(BOMHeader."No.", BOMHeader."ENC Active Version No.", BOMComponent."Line No.") or not BOMLine."BA Optional" then
            exit;
        AssemblyLine.Validate(Quantity, 0);
        AssemblyLine.Validate("Quantity per", 0);
    end;
}