codeunit 75010 "BA SEI Subscibers"
{
    Permissions = tabledata "Return Shipment Header" = rimd,
                  tabledata "Purch. Rcpt. Header" = rimd,
                  tabledata "Sales Shipment Line" = rimd,
                  tabledata "Sales Shipment Header" = rimd;

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

    [EventSubscriber(ObjectType::Table, Database::"Default Dimension", 'OnAfterValidateEvent', 'Dimension Value Code', false, false)]
    local procedure DefaultDimOnAfterValidateDimValueCode(var Rec: Record "Default Dimension"; var xRec: Record "Default Dimension")
    var
        Item: Record Item;
        GLSetup: Record "General Ledger Setup";
    begin

        // if not Confirm('dim value validated') then
        //     Error('');

        if (Rec."Dimension Value Code" = xRec."Dimension Value Code") or (Rec."Table ID" <> Database::Item)
                or (Rec."No." = '') or not Item.Get(Rec."No.") then
            exit;
        GLSetup.Get();
        case true of
            Rec."Dimension Code" = GLSetup."Shortcut Dimension 1 Code":
                Item."Global Dimension 1 Code" := Rec."Dimension Value Code";
            Rec."Dimension Code" = GLSetup."Shortcut Dimension 2 Code":
                Item."Global Dimension 2 Code" := Rec."Dimension Value Code";
            Rec."Dimension Code" = GLSetup."Shortcut Dimension 3 Code":
                Item."ENC Shortcut Dimension 3 Code" := Rec."Dimension Value Code";
            Rec."Dimension Code" = GLSetup."Shortcut Dimension 4 Code":
                Item."ENC Shortcut Dimension 4 Code" := Rec."Dimension Value Code";
            Rec."Dimension Code" = GLSetup."Shortcut Dimension 5 Code":
                Item."ENC Shortcut Dimension 5 Code" := Rec."Dimension Value Code";
            Rec."Dimension Code" = GLSetup."Shortcut Dimension 6 Code":
                Item."ENC Shortcut Dimension 6 Code" := Rec."Dimension Value Code";
            Rec."Dimension Code" = GLSetup."Shortcut Dimension 7 Code":
                Item."ENC Shortcut Dimension 7 Code" := Rec."Dimension Value Code";
            Rec."Dimension Code" = GLSetup."Shortcut Dimension 8 Code":
                Item."ENC Shortcut Dimension 8 Code" := Rec."Dimension Value Code";
            Rec."Dimension Code" = GLSetup."ENC Product ID Dim. Code":
                Item."ENC Product ID Code" := Rec."Dimension Value Code";
            else
                exit;
        end;
        Rec.Modify(true);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", 'OnShipmentMethodCodeLookup', '', false, false)]
    local procedure ShipToAddressOnShipmentMethodLookup(var Rec: Record "Ship-to Address"; var xRec: Record "Ship-to Address")
    begin
        Rec.ShipmentMethodCodeLookup();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Ship-to Address", 'OnAfterValidateEvent', 'Shipment Method Code', false, false)]
    local procedure ShipToAddressValdiateShipmentMethodCode(var Rec: Record "Ship-to Address"; var xRec: Record "Ship-to Address")
    var
        ShipmentMethod: Record "Shipment Method";
    begin
        if (Rec."Shipment Method Code" <> xRec."Shipment Method Code") and (Rec."Shipment Method Code" <> '') then begin
            ShipmentMethod.Get(Rec."Shipment Method Code");
            ShipmentMethod.TestField("ENC Sales", true);
        end;
    end;



    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnAfterSalesShptHeaderInsert', '', false, false)]
    local procedure SalesPostOnAfterSalesShptHeaderInsert(var SalesShipmentHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header")
    var
        SalesShptHdr: Record "Sales Shipment Header";
        SalesShptLine: Record "Sales Shipment Line";
    begin
        SalesShptHdr.SetFilter("No.", '<>%1', SalesShipmentHeader."No.");
        SalesShptHdr.SetRange("Order No.", SalesHeader."No.");
        if not SalesShptHdr.FindFirst() then
            exit;
        SalesShptLine.SetRange("Document No.", SalesShptHdr."No.");
        SalesShptLine.SetRange(Type, SalesShptLine.Type::Item);
        SalesShptLine.SetFilter(Quantity, '>%1', 0);
        if SalesShptLine.FindFirst() then begin
            SalesShptLine.SetRange(Type, SalesShptLine.Type::"G/L Account");
            SalesShptLine.SetRange(Quantity, 0);
            if not SalesShptLine.IsEmpty() then begin
                SalesShipmentHeader."BA Original Doc. No." := SalesShipmentHeader."No.";
                SalesShipmentHeader."No." := SalesShptHdr."No.";
                SalesShipmentHeader."BA Merged Shpt. Lines" := true;
                SalesShipmentHeader."BA Hide Merged Shpt. Lines" := true;
                SalesShipmentHeader.Modify(false);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnBeforeSalesShptLineInsert', '', false, false)]
    local procedure SalesPostOnBeforeSalesShptLineInsert(var SalesShptLine: Record "Sales Shipment Line"; SalesShptHeader: Record "Sales Shipment Header")
    var
        SalesShptLine2: Record "Sales Shipment Line";
    begin
        if not SalesShptHeader."BA Merged Shpt. Lines" then
            exit;
        SalesShptLine2.SetRange("Document No.", SalesShptHeader."No.");
        if SalesShptLine2.FindLast() then
            SalesShptLine."Line No." := SalesShptLine2."Line No." + 10000;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnAfterSalesShptLineInsert', '', false, false)]
    local procedure SalesPostOnAfterSalesShptLineInsert(var SalesShipmentLine: Record "Sales Shipment Line")
    begin
        if SalesShipmentLine."BA Merged Shpt. Line" then
            SalesShipmentLine.Delete(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnAfterFinalizePostingOnBeforeCommit', '', false, false)]
    local procedure SalesPostOnAfterFinalizePostingOnBeforeCommit(var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SalesShptLine: Record "Sales Shipment Line";
        SalesShptLine2: Record "Sales Shipment Line";
        TempSalesShptLines: Record "Sales Shipment Line" temporary;
        OrphanedLines: Record "Sales Shipment Line";
    begin
        if SalesInvoiceHeader."No." <> '' then begin
            OrphanedLines.SetCurrentKey("Order No.", "Order Line No.");
            OrphanedLines.SetRange("Order No.", SalesInvoiceHeader."Order No.");
            OrphanedLines.DeleteAll(false);
            exit;
        end;
        if SalesShipmentHeader."No." = '' then
            exit;
        SalesShptLine.SetRange("Document No.", SalesShipmentHeader."No.");
        SalesShptLine.SetFilter(Type, '<>%1&<>%2', SalesShptLine.Type::"G/L Account", SalesShptLine.Type::" ");
        SalesShptLine2.SetRange("Document No.", SalesShipmentHeader."No.");
        SalesShptLine2.SetRange(Type, SalesShptLine2.Type::"G/L Account");
        if SalesShptLine.IsEmpty() and SalesShptLine2.FindSet() then begin
            repeat
                TempSalesShptLines := SalesShptLine2;
                TempSalesShptLines.insert(false);
                SalesShptLine2.Quantity := 0;
                SalesShptLine2.Modify(false);
            until SalesShptLine2.Next() = 0;
            SalesShipmentHeader."No. Printed" := -1;
            SalesShipmentHeader.Delete(true);
            TempSalesShptLines.FindSet();
            repeat
                OrphanedLines := TempSalesShptLines;
                OrphanedLines.Insert(false);
            until TempSalesShptLines.Next() = 0;
            exit;
        end;
        if not SalesShipmentHeader."BA Merged Shpt. Lines" then
            exit;
        SalesShptLine.SetRange(Type, SalesShptLine.Type::Item);
        SalesShptLine.SetRange(Quantity, 0);
        SalesShptLine.DeleteAll(true);
        SalesShipmentHeader."No." := SalesShipmentHeader."BA Original Doc. No.";
        SalesShipmentHeader."No. Printed" := -1;
        SalesShipmentHeader.Delete(true);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Format Address", 'OnAfterFormatAddress', '', false, false)]
    local procedure FormatAddressOnAfterFormatAddress(var CountryCode: Code[10]; var County: Text[50]; var AddrArray: array[8] of Text)
    var
        ProvinceState: Record "BA Province/State";
        CompInfo: Record "Company Information";
        i: Integer;
    begin
        if CountryCode = '' then begin
            CompInfo.Get('');
            CompInfo.TestField("Country/Region Code");
            CountryCode := CompInfo."Country/Region Code";
        end;

        if not ProvinceState.Get(CountryCode, CopyStr(County, 1, MaxStrLen(ProvinceState.Symbol))) then begin
            ProvinceState.SetRange("Country/Region Code", CountryCode);
            ProvinceState.SetRange(Name, County);
            if not ProvinceState.FindFirst() then
                exit;
        end;
        if not ProvinceState."Print Full Name" then
            exit;

        for i := 1 to 8 do
            if AddrArray[i].Contains(County) then begin
                AddrArray[i] := AddrArray[i].Replace(County, ProvinceState.Name);
                exit;
            end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnAfterFindSalesLineItemPrice', '', false, false)]
    local procedure SalesLineOnAfterFindSalesLineItemPrice(var SalesLine: Record "Sales Line"; var TempSalesPrice: Record "Sales Price"; var FoundSalesPrice: Boolean)
    var
        SalesHeader: Record "Sales Header";
        SalesPrice: Record "Sales Price";
        SalesRecSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        ExchangeRate: Record "Currency Exchange Rate";
        CurrencyCode: Code[10];
        EndDate: Date;
        RateValue: Decimal;
    begin
        if not SalesRecSetup.Get() or not SalesRecSetup."BA Use Single Currency Pricing" then
            exit;
        SalesRecSetup.TestField("BA Single Price Currency");
        if not FoundSalesPrice then
            exit;
        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Quote then
            EndDate := SalesHeader."Order Date"
        else
            EndDate := SalesHeader."Posting Date";
        GLSetup.Get();
        GLSetup.TestField("LCY Code");
        if SalesRecSetup."BA Single Price Currency" <> GLSetup."LCY Code" then
            CurrencyCode := SalesRecSetup."BA Single Price Currency";
        SalesPrice.SetRange("Item No.", SalesLine."No.");
        SalesPrice.SetRange("Currency Code", CurrencyCode);
        SalesPrice.SetRange("Starting Date", 0D, EndDate);
        SalesPrice.SetAscending("Starting Date", true);
        if not SalesPrice.FindLast() then begin
            FoundSalesPrice := false;
            exit;
        end;
        TempSalesPrice := SalesPrice;
        if SalesLine."Document Type" <> SalesLine."Document Type"::Quote then
            exit;
        if (SalesLine."Currency Code" <> CurrencyCode) or SalesHeader."BA Use Manual Exch. Rate" then begin
            if not SalesHeader."BA Use Manual Exch. Rate" then begin
                ExchangeRate.SetRange("Currency Code", CurrencyCode);
                ExchangeRate.SetRange("Starting Date", 0D, EndDate);
                if ExchangeRate.FindLast() then begin
                    TempSalesPrice."Unit Price" *= ExchangeRate."Relational Exch. Rate Amount";
                    RateValue := ExchangeRate."Relational Exch. Rate Amount";
                end;
            end else begin
                RateValue := SalesHeader."BA Manual Exch. Rate";
                TempSalesPrice."Unit Price" *= RateValue;
            end;
        end else
            RateValue := 1;
        SalesHeader."BA Quote Exch. Rate" := RateValue;
        SalesHeader.Modify(true);
    end;


    var
        ExtDocNoFormatError: Label '%1 field is improperly formatted for International Orders:\%2';
        InvalidPrefixError: Label 'Missing "SO" prefix.';
        MissingNumeralError: Label 'Missing numeral suffix.';
        NonNumeralError: Label 'Non-numeric character: %1.';
        TooLongSuffixError: Label 'Numeral suffix length is greater than 7.';
        TooShortSuffixError: Label 'Numeral suffix length is less than 7.';
}