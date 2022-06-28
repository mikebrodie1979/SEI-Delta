codeunit 75010 "BA SEI Subscibers"
{
    Permissions = tabledata "Return Shipment Header" = rimd,
                  tabledata "Purch. Rcpt. Header" = rimd;

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
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Quote:
                begin
                    SalesHeader.Validate("ENC Stage", SalesHeader."ENC Stage"::Open);
                    SalesHeader.Validate("Shipment Date", 0D);
                end;
            SalesHeader."Document Type"::Order:
                SalesHeader.Validate("Shipment Date", 0D);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCheckItemAvailabilityInLinesOnAfterSetFilters', '', false, false)]
    local procedure SalesHeaderOnCheckItemAvailabilityInLinesOnAfterSetFilters(var SalesLine: Record "Sales Line")
    begin
        SalesLine.SetFilter("Shipment Date", '<>%1', 0D);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure SalesLineOnAfterValdiateNo(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    begin
        if Rec."No." <> xRec."No." then
            ClearShipmentDates(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure SalesLineOnAfterValdiateQuantity(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    begin
        if Rec.Quantity <> xRec.Quantity then
            ClearShipmentDates(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeSalesLineByChangedFieldNo', '', false, false)]
    local procedure SalesHeaderOnBeforeSalesLineByChangedFieldNo(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var IsHandled: Boolean; ChangedFieldNo: Integer)
    var
        AssembleToOrderLink: Record "Assemble-to-Order Link";
    begin
        if (SalesHeader."Shipment Date" = 0D) and AssembleToOrderLink.AsmExistsForSalesLine(SalesLine)
                and (ChangedFieldNo = SalesHeader.FieldNo("Shipment Date")) and (SalesLine."Shipment Date" <> 0D) then
            IsHandled := true;
    end;

    local procedure ClearShipmentDates(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        AssembleToOrderLink: Record "Assemble-to-Order Link";
    begin
        if not SalesHeader.Get(Rec."Document Type", Rec."Document No.") or Rec.IsTemporary or (SalesHeader."Shipment Date" <> 0D)
                or not (Rec."Document Type" in [Rec."Document Type"::Quote, Rec."Document Type"::Order])
                  or AssembleToOrderLink.AsmExistsForSalesLine(Rec)
                 then
            exit;
        Rec.Validate("Shipment Date", 0D);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Shipment Date', false, false)]
    local procedure SalesLineOnAfterValdiateShipmentDate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if not SalesHeader.Get(Rec."Document Type", Rec."Document No.") or Rec.IsTemporary or (Rec."Shipment Date" = xRec."Shipment Date")
                or not (Rec."Document Type" in [Rec."Document Type"::Quote, Rec."Document Type"::Order]) then
            exit;
        if Rec."Shipment Date" <> 0D then
            exit;
        Rec.Validate("Planned Delivery Date", 0D);
        Rec.Validate("Planned Shipment Date", 0D);
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
        case PurchHeader."Document Type" of
            PurchHeader."Document Type"::Order, PurchHeader."Document Type"::Invoice:
                begin
                    PurchPaySetup.TestField("BA Requisition Nos.");
                    NoSeriesCode := PurchPaySetup."BA Requisition Nos.";
                end;
            PurchHeader."Document Type"::"Credit Memo":
                begin
                    PurchPaySetup.TestField("BA Requisition Cr.Memo Nos.");
                    NoSeriesCode := PurchPaySetup."BA Requisition Cr.Memo Nos.";
                end;
            PurchHeader."Document Type"::"Return Order":
                begin
                    PurchPaySetup.TestField("BA Requisition Return Nos.");
                    NoSeriesCode := PurchPaySetup."BA Requisition Return Nos.";
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterInitRecord', '', false, false)]
    local procedure PurchaseHeaderOnAfterInitRecord(var PurchHeader: Record "Purchase Header")
    var
        PurchPaySetup: Record "Purchases & Payables Setup";
    begin
        if PurchHeader."Expected Receipt Date" = 0D then
            PurchHeader.Validate("Expected Receipt Date", WorkDate());
        if not PurchHeader."BA Requisition Order" then
            exit;
        PurchPaySetup.Get();
        case PurchHeader."Document Type" of
            PurchHeader."Document Type"::Order, PurchHeader."Document Type"::Invoice:
                begin
                    PurchPaySetup.TestField("BA Requisition Receipt Nos.");
                    PurchHeader."Receiving No. Series" := PurchPaySetup."BA Requisition Receipt Nos.";
                    PurchHeader."Posting No. Series" := PurchPaySetup."BA Requisition Receipt Nos.";
                end;
            PurchHeader."Document Type"::"Credit Memo":
                begin
                    PurchPaySetup.TestField("BA Posted Req. Cr.Memo Nos.");
                    PurchHeader."Return Shipment No. Series" := PurchPaySetup."BA Posted Req. Cr.Memo Nos.";
                    PurchHeader."Posting No. Series" := PurchPaySetup."BA Posted Req. Cr.Memo Nos.";
                end;
            PurchHeader."Document Type"::"Return Order":
                begin
                    PurchPaySetup.TestField("BA Req. Return Shipment Nos.");
                    PurchHeader."Return Shipment No. Series" := PurchPaySetup."BA Req. Return Shipment Nos.";
                    PurchHeader."Posting No. Series" := PurchPaySetup."BA Req. Return Shipment Nos.";
                end;
        end;
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
        UpdatePostingConfirmation(PurchaseHeader, HideDialog);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post + Print", 'OnBeforeConfirmPost', '', false, false)]
    local procedure PurchPostPrintOnBeforeConfirmPost(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean)
    begin
        UpdatePostingConfirmation(PurchaseHeader, HideDialog);
    end;

    local procedure UpdatePostingConfirmation(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean)
    begin
        if not PurchaseHeader."BA Requisition Order" then
            exit;
        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Order, PurchaseHeader."Document Type"::Invoice:
                begin
                    HideDialog := true;
                    if not Confirm(StrSubstNo('Receive Requisition Order %1?', PurchaseHeader."No.")) then
                        Error('');
                    PurchaseHeader.Receive := true;
                end;
            PurchaseHeader."Document Type"::"Return Order":
                begin
                    HideDialog := true;
                    if not Confirm(StrSubstNo('Ship Requisition Return Order %1?', PurchaseHeader."No.")) then
                        Error('');
                    PurchaseHeader.Ship := true;
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnRunPreviewOnBeforePurchPostRun', '', false, false)]
    local procedure PurchPostYesNoOnRunPreviewOnBeforePurchPostRun(var PurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader.Invoice := not PurchaseHeader."BA Requisition Order";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostItemLine', '', false, false)]
    local procedure PurchPostOnAfterPostItemLine(PurchaseLine: Record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
        Item: Record Item;
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        CurrencyExchageRate: Record "Currency Exchange Rate";
        ItemCostMgt: Codeunit ItemCostManagement;
        TotalAmount: Decimal;
        LastDirectCost: Decimal;
        FullyPostedReqOrder: Boolean;
    begin
        PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.");
        FullyPostedReqOrder := PurchaseHeader.Receive and PurchaseHeader."BA Requisition Order";
        if FullyPostedReqOrder and (PurchaseLine."Qty. to Receive" <> 0) then begin
            Item.Get(PurchaseLine."No.");
            GLSetup.Get();
            GLSetup.TestField("Unit-Amount Rounding Precision");
            TotalAmount := PurchaseLine."Unit Cost" * PurchaseLine."Qty. to Receive";
            LastDirectCost := Round(TotalAmount / PurchaseLine."Qty. to Receive", GLSetup."Unit-Amount Rounding Precision");
            if PurchaseHeader."Currency Code" <> '' then
                LastDirectCost := CurrencyExchageRate.ExchangeAmount(LastDirectCost, PurchaseHeader."Currency Code", '', PurchaseHeader."Posting Date");
            ItemCostMgt.UpdateUnitCost(Item, PurchaseLine."Location Code", PurchaseLine."Variant Code",
                LastDirectCost, 0, true, true, false, 0);
        end;
        if Currency.Get(PurchaseLine."Currency Code") and Currency."BA Local Purchase Cost" then
            if PurchaseHeader.Invoice or FullyPostedReqOrder then begin
                Item.Get(PurchaseLine."No.");
                Item.SetLastCurrencyPurchCost(Currency.Code, PurchaseLine."Unit Cost");
                Item.Modify(true);
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchRcptLineInsert', '', false, false)]
    local procedure PurchPostOnBeforePurchRcptLineInsert(var PurchLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        PurchLine2: Record "Purchase Line";
    begin
        PurchLine2.Get(PurchLine.RecordId());
        PurchRcptLine."BA Line Discount Amount" := PurchLine2."Line Discount Amount";
        PurchRcptLine."BA Line Amount" := PurchLine2."Line Amount";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeReturnShptLineInsert', '', false, false)]
    local procedure PurchPostOnBeforeReturnShptLineInsert(var PurchLine: Record "Purchase Line"; var ReturnShptLine: Record "Return Shipment Line")
    var
        PurchLine2: Record "Purchase Line";
    begin
        PurchLine2.Get(PurchLine.RecordId());
        ReturnShptLine."BA Line Discount Amount" := PurchLine2."Line Discount Amount";
        ReturnShptLine."BA Line Amount" := PurchLine2."Line Amount";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterFinalizePosting', '', false, false)]
    local procedure PurchPostOnAfterFinalizePosting(var PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
    begin
        if not PurchHeader."BA Requisition Order" then
            exit;
        case PurchHeader."Document Type" of
            PurchHeader."Document Type"::Order, PurchHeader."Document Type"::Invoice:
                PurchHeader."BA Fully Rec'd. Req. Order" := PurchHeader.QtyToReceiveIsZero();
            PurchHeader."Document Type"::"Return Order":
                begin
                    PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                    PurchLine.SetRange("Document No.", PurchHeader."No.");
                    if PurchLine.FindSet() then
                        repeat
                            if PurchLine."Return Qty. Shipped" <> PurchLine.Quantity then
                                exit;
                        until PurchLine.Next() = 0;
                    PurchHeader."BA Fully Rec'd. Req. Order" := true;
                end;
            else
                exit;
        end;
        PurchHeader.Modify(false);
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

    [EventSubscriber(ObjectType::Table, Database::"Report Selections", 'OnPrintDocumentsOnAfterSelectTempReportSelectionsToPrint', '', false, false)]
    local procedure ReportSelectionsOnPrintDocumentsOnAfterSelectTempReportSelectionsToPrint(var TempReportSelections: Record "Report Selections"; RecordVariant: Variant)
    var
        PurchHeader: Record "Purchase Header";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(RecordVariant);
        if RecRef.Number() <> Database::"Purchase Header" then
            exit;
        RecRef.SetTable(PurchHeader);
        if not PurchHeader."BA Requisition Order" then
            exit;
        TempReportSelections.Validate("Report ID", Report::"BA Requisition Order");
        TempReportSelections.Modify(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Header", 'OnAfterValidateEvent', 'Transfer-to Code', false, false)]
    local procedure TransferHeaderOnAfterValidateTransferToCode(var Rec: Record "Transfer Header"; var xRec: Record "Transfer Header")
    var
        Location: Record Location;
    begin
        if Rec.IsTemporary or (Rec."Transfer-to Code" = xRec."Transfer-to Code") or not Location.Get(Rec."Transfer-to Code") then
            exit;
        Rec.Validate("BA Transfer-To Phone No.", Location."Phone No.");
        Rec.Validate("BA Transfer-To FID No.", Location."BA FID No.");
        Rec.Modify(false);
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterCheckSalesApprovalPossible', '', false, false)]
    local procedure ApprovalsMgtOnAfterCheckSalesApprovalPossible(var SalesHeader: Record "Sales Header")
    var
        Customer: Record Customer;
    begin
        SalesHeader.TestField("Sell-to Customer No.");
        Customer.Get(SalesHeader."Sell-to Customer No.");
        if not Customer."BA Int. Customer" then
            exit;
        SalesHeader.TestField("ENC BBD Sell-To No.");
        SalesHeader.TestField("ENC BBD Sell-To Name");
        SalesHeader.TestField("External Document No.");
        FormatInternationalExtDocNo(SalesHeader."External Document No.", SalesHeader.FieldCaption("External Document No."));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Service-Post", 'OnBeforePostWithLines', '', false, false)]
    local procedure ServicePostOnBeforePostWithLines(var PassedServHeader: Record "Service Header")
    var
        Customer: Record Customer;
    begin
        PassedServHeader.TestField("Customer No.");
        Customer.Get(PassedServHeader."Customer No.");
        if not Customer."BA Serv. Int. Customer" then
            exit;
        PassedServHeader.TestField("ENC BBD Sell-To No.");
        PassedServHeader.TestField("ENC BBD Sell-To Name");
        PassedServHeader.TestField("ENC External Document No.");
        FormatInternationalExtDocNo(PassedServHeader."ENC External Document No.", PassedServHeader.FieldCaption("External Document No."));
    end;

    local procedure FormatInternationalExtDocNo(var ExtDocNo: Code[35]; FieldCaption: Text)
    var
        Length: Integer;
        i: Integer;
        c: Char;
    begin
        Length := StrLen(ExtDocNo);
        if (ExtDocNo[1] <> 'S') or (ExtDocNo[2] <> 'O') then
            Error(ExtDocNoFormatError, FieldCaption, InvalidPrefixError);
        if Length = 2 then
            Error(ExtDocNoFormatError, FieldCaption, MissingNumeralError);
        if Length < 9 then
            Error(ExtDocNoFormatError, FieldCaption, TooShortSuffixError);
        for i := 3 to Length do begin
            c := ExtDocNo[i];
            if (c > '9') or (c < '0') then
                Error(ExtDocNoFormatError, FieldCaption, StrSubstNo(NonNumeralError, c));
        end;
        if Length > 9 then
            Error(ExtDocNoFormatError, FieldCaption, TooLongSuffixError);
    end;


    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Customer Posting Group', false, false)]
    local procedure CustomerOnAfterValidateCustomerPostingGroup(var Rec: Record Customer)
    var
        CustPostGroup: Record "Customer Posting Group";
    begin
        if Rec."Customer Posting Group" = '' then
            exit;
        CustPostGroup.Get(Rec."Customer Posting Group");
        if CustPostGroup."BA Blocked" then
            Error('%1 %2 is blocked', CustPostGroup.TableCaption, CustPostGroup.Code);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeAutoReserve', '', false, false)]
    local procedure SalesLineOnBeforeAutoReserve(SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        if SalesLine."Shipment Date" = 0D then
            IsHandled := true;
    end;


    var
        ExtDocNoFormatError: Label '%1 field is improperly formatted for International Orders:\%2';
        InvalidPrefixError: Label 'Missing "SO" prefix.';
        MissingNumeralError: Label 'Missing numeral suffix.';
        NonNumeralError: Label 'Non-numeric character: %1.';
        TooLongSuffixError: Label 'Numeral suffix length is greater than 7.';
        TooShortSuffixError: Label 'Numeral suffix length is less than 7.';
}