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



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnBeforeCheckLines', '', false, false)]
    local procedure WhseActivityPostOnBeforeCheckLines(var WhseActivityHeader: Record "Warehouse Activity Header")
    var
        SalesLine: Record "Sales Line";
    begin
        if (WhseActivityHeader."Source Type" <> Database::"Sales Line") or (WhseActivityHeader."Source Subtype" <> WhseActivityHeader."Source Subtype"::"1") then
            exit;
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", WhseActivityHeader."Source No.");
        SalesLine.FindSet(true);
        repeat
            SalesLine."BA Org. Qty. To Ship" := SalesLine."Qty. to Ship";
            SalesLine."BA Org. Qty. To Invoice" := SalesLine."Qty. to Invoice";
            SalesLine.Modify(false);
        until SalesLine.Next() = 0;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Post", 'OnCodeOnAfterCreatePostedWhseActivDocument', '', false, false)]
    local procedure WhseActivityPostOnAfterWhseActivLineModify(var WhseActivityHeader: Record "Warehouse Activity Header")
    var
        WhseActivityLine: Record "Warehouse Activity Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        WhseActivityLine.SetRange("Activity Type", WhseActivityHeader.Type);
        WhseActivityLine.SetRange("No.", WhseActivityHeader."No.");
        WhseActivityLine.SetRange("Source Type", Database::"Sales Line");
        WhseActivityLine.SetRange("Source Subtype", WhseActivityLine."Source Subtype"::"1");
        WhseActivityLine.SetFilter("Qty. to Handle", '>%1', 0);
        WhseActivityLine.SetFilter(Quantity, '>%1', 0);
        if not WhseActivityLine.FindSet() then
            exit;

        SalesHeader.Get(SalesHeader."Document Type"::Order, WhseActivityLine."Source No.");
        if not SalesHeader.Invoice then
            repeat
                if SalesLine.Get(SalesLine."Document Type"::Order, WhseActivityLine."Source No.", WhseActivityLine."Source Line No.") then begin
                    SalesLine.Validate("Qty. to Invoice", WhseActivityLine.Quantity);
                    SalesLine.Modify(true);
                end;
            until WhseActivityLine.Next() = 0;

        SalesLine.SetRange("Document No.", WhseActivityLine."Source No.");
        if SalesLine.FindSet() then
            repeat
                WhseActivityLine.SetRange("Source Line No.", SalesLine."Line No.");
                if WhseActivityLine.IsEmpty() then begin
                    SalesLine.Validate("Qty. to Ship", SalesLine."BA Org. Qty. To Ship");
                    SalesLine.Validate("Qty. to Invoice", SalesLine."BA Org. Qty. To Invoice");
                    SalesLine.Modify(true);
                end;
            until SalesLine.Next() = 0;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly Line Management", 'OnAfterTransferBOMComponent', '', false, false)]
    local procedure AssemblyLineMgtOnAfterTransferBOMComponent(var AssemblyLine: Record "Assembly Line"; BOMComponent: Record "BOM Component")
    begin
        if not BOMComponent."BA Optional" then
            exit;
        AssemblyLine.Validate(Quantity, 0);
        AssemblyLine.Validate("Quantity per", 0);
        AssemblyLine.Validate("BA Optional", true);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterGetNoSeriesCode', '', false, false)]
    local procedure PurchaseHeaderOnAfterGetNoSeriesCode(var PurchHeader: Record "Purchase Header"; var NoSeriesCode: Code[20])
    var
        PurchPaySetup: Record "Purchases & Payables Setup";
    begin
        if not PurchHeader."BA Requisition Order" then
            exit;
        PurchPaySetup.Get();
        PurchPaySetup.TestField("BA Requisition Nos.");
        NoSeriesCode := PurchPaySetup."BA Requisition Nos.";
    end;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInitHeaderDefaults', '', false, false)]
    local procedure PurchaseLineOnAfterInitHeaderDefaults(var PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header")
    begin
        if PurchHeader."BA Requisition Order" then
            PurchLine."BA Requisition Order" := true;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', false, false)]
    local procedure PurchPostYesNoOnBeforeConfirmPost(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean)
    begin
        if not PurchaseHeader."BA Requisition Order" then
            exit;
        HideDialog := true;
        if not Confirm('Recieve Reqisition Order?') then
            Error('');
        PurchaseHeader.Receive := true;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostItemLine', '', false, false)]
    local procedure PurchPostOnAfterPostItemLine(PurchaseLine: Record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
        Item: Record Item;
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        ItemCostMgt: Codeunit ItemCostManagement;
        TotalAmount: Decimal;
        LastDirectCost: Decimal;
        FullyPostedReqOrder: Boolean;
    begin
        PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.");
        FullyPostedReqOrder := PurchaseHeader.Receive and PurchaseHeader."BA Requisition Order";
        if not Currency.Get(PurchaseLine."Currency Code") or not Currency."BA Local Purchase Cost" then begin
            if FullyPostedReqOrder then begin
                Item.Get(PurchaseLine."No.");
                GLSetup.Get();
                TotalAmount := PurchaseLine."Unit Cost" * PurchaseLine."Qty. to Receive";
                LastDirectCost := Round(TotalAmount / PurchaseLine."Qty. to Receive", GLSetup."Unit-Amount Rounding Precision");
                ItemCostMgt.UpdateUnitCost(Item, PurchaseLine."Location Code", PurchaseLine."Variant Code",
                    LastDirectCost, 0, true, true, false, 0);
            end
        end else
            if PurchaseHeader.Invoice or FullyPostedReqOrder then begin
                Item.Get(PurchaseLine."No.");
                Item.SetLastCurrencyPurchCost(Currency.Code, PurchaseLine."Unit Cost");
                Item.Modify(true);
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure PurchPostOnAfterPostPurchLines(var PurchaseHeader: Record "Purchase Header"; PurchRcpHdrNo: Code[20])
    var
        PurchLine: Record "Purchase Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        if not PurchaseHeader."BA Requisition Order" or (PurchRcpHdrNo = '') or not PurchRcptHeader.Get(PurchRcpHdrNo) then
            exit;
        PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchLine.SetFilter("Qty. to Receive (Base)", '<>%1', 0);
        if not PurchLine.IsEmpty() then
            exit;
        PurchLine.SetRange("Qty. to Receive (Base)");
        if PurchLine.FindSet() then
            repeat
                if (PurchLine."Quantity Received" <> PurchLine.Quantity) then
                    exit;
                if not PurchRcptLine.Get(PurchRcptHeader."No.", PurchLine."Line No.")
                        or (PurchRcptLine.Quantity <> PurchLine.Quantity) then
                    exit;
            until PurchLine.Next() = 0;
        PurchaseHeader."BA Fully Rec'd. Req. Order" := true;
        PurchRcptHeader."BA Fully Rec'd. Req. Order" := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure PurchLineOnAfterValidateNo(var Rec: Record "Purchase Line")
    var
        Item: Record Item;
        PurchHeader: Record "Purchase Header";
        Currency: Record Currency;
        LastUnitCost: Decimal;
    begin
        if (Rec.Type <> Rec.Type::Item) or Rec.IsTemporary() or (Rec."No." = '') then
            exit;
        PurchHeader.Get(Rec."Document Type", Rec."Document No.");
        if not Currency.Get(PurchHeader."Currency Code") or not Currency."BA Local Purchase Cost" then
            exit;
        Item.Get(Rec."No.");
        LastUnitCost := Item.GetLastCurrencyPurchCost(Currency.Code);
        if LastUnitCost = 0 then
            exit;
        Rec.Validate("Direct Unit Cost", LastUnitCost);
    end;



}