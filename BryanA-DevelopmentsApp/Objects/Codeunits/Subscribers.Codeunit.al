codeunit 75010 "BA SEI Subscibers"
{
    Permissions = tabledata "Return Shipment Header" = rimd,
                  tabledata "Return Shipment Line" = rimd,
                  tabledata "Purch. Rcpt. Header" = rimd,
                  tabledata "Purch. Rcpt. Line" = rimd,
                  tabledata "Sales Shipment Line" = rimd,
                  tabledata "Sales Shipment Header" = rimd,
                  tabledata "Item Ledger Entry" = rimd,
                  tabledata "Approval Entry" = rimd;

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
                    if SalesHeader.Invoice then
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
        DiscountedAmt: Decimal;
    begin
        PurchLine2.Get(PurchLine.RecordId());
        PurchRcptLine."BA Line Amount" := PurchLine2."Qty. to Receive" * PurchLine2."Direct Unit Cost";
        if PurchLine2."Line Discount %" <> 0 then begin
            DiscountedAmt := PurchRcptLine."BA Line Amount" * (100 - PurchLine2."Line Discount %") / 100;
            PurchRcptLine."BA Line Discount Amount" := PurchRcptLine."BA Line Amount" - DiscountedAmt;
            PurchRcptLine."BA Line Amount" := DiscountedAmt;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeReturnShptLineInsert', '', false, false)]
    local procedure PurchPostOnBeforeReturnShptLineInsert(var PurchLine: Record "Purchase Line"; var ReturnShptLine: Record "Return Shipment Line")
    var
        PurchLine2: Record "Purchase Line";
        DiscountedAmt: Decimal;
    begin
        PurchLine2.Get(PurchLine.RecordId());
        ReturnShptLine."BA Line Amount" := PurchLine2."Return Qty. to Ship" * PurchLine2."Direct Unit Cost";
        if PurchLine2."Line Discount %" <> 0 then begin
            DiscountedAmt := ReturnShptLine."BA Line Amount" * (100 - PurchLine2."Line Discount %") / 100;
            ReturnShptLine."BA Line Discount Amount" := ReturnShptLine."BA Line Amount" - DiscountedAmt;
            ReturnShptLine."BA Line Amount" := DiscountedAmt;
        end;
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
            Error(CustGroupBlockedError, CustPostGroup.TableCaption, CustPostGroup.Code);
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
        Item.Modify(true);
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




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnAfterFindSalesPrice', '', false, false)]
    local procedure SalesLineOnAfterFindSalesPrice(var FromSalesPrice: Record "Sales Price"; var ToSalesPrice: Record "Sales Price"; ItemNo: Code[20])
    var
        NewestDate: Date;
    begin
        if (ItemNo = '') or not ToSalesPrice.FindSet() then
            exit;
        NewestDate := ToSalesPrice."Starting Date";
        repeat
            if ToSalesPrice."Starting Date" > NewestDate then
                NewestDate := ToSalesPrice."Starting Date";
        until ToSalesPrice.Next() = 0;
        ToSalesPrice.SetFilter("Starting Date", '<>%1', NewestDate);
        ToSalesPrice.DeleteAll(false);
        ToSalesPrice.SetRange("Starting Date");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnAfterFindSalesLineItemPrice', '', false, false)]
    local procedure SalesPriceMgtOnAfterFindSalesLineItemPrice(var SalesLine: Record "Sales Line"; var TempSalesPrice: Record "Sales Price"; var FoundSalesPrice: Boolean)
    var
        SalesHeader: Record "Sales Header";
        SalesPrice: Record "Sales Price";
        SalesRecSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        ExchangeRate: Record "Currency Exchange Rate";
        CurrencyCode: Code[10];
        RateValue: Decimal;
    begin
        if not SalesRecSetup.Get() or not SalesRecSetup."BA Use Single Currency Pricing" then
            exit;
        SalesRecSetup.TestField("BA Single Price Currency");
        if not FoundSalesPrice and (SalesLine."Unit Price" <> 0) then begin
            TempSalesPrice."Unit Price" := SalesLine."Unit Price";
            exit;
        end;
        GLSetup.Get();
        GLSetup.TestField("LCY Code");
        if SalesRecSetup."BA Single Price Currency" <> GLSetup."LCY Code" then
            CurrencyCode := SalesRecSetup."BA Single Price Currency";
        SalesPrice.SetRange("Item No.", SalesLine."No.");
        SalesPrice.SetRange("Currency Code", CurrencyCode);
        SalesPrice.SetRange("Starting Date", 0D, WorkDate());
        SalesPrice.SetAscending("Starting Date", true);
        FoundSalesPrice := SalesPrice.FindLast();
        if not FoundSalesPrice then
            exit;
        TempSalesPrice := SalesPrice;
        if not (SalesLine."Document Type" in [SalesLine."Document Type"::Quote, SalesLine."Document Type"::Order]) then
            exit;
        if (SalesLine."Currency Code" <> CurrencyCode) and GetExchangeRate(ExchangeRate, CurrencyCode) then begin
            GLSetup.TestField("Amount Rounding Precision");
            TempSalesPrice."Unit Price" := Round(TempSalesPrice."Unit Price" * ExchangeRate."Relational Exch. Rate Amount",
                GLSetup."Amount Rounding Precision");
            RateValue := Round(ExchangeRate."Relational Exch. Rate Amount", GLSetup."Amount Rounding Precision");
        end else
            RateValue := 1;
        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        SalesHeader."BA Quote Exch. Rate" := RateValue;
        SalesHeader.Modify(true);
    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnAfterFindServLiveItemPrice', '', false, false)]
    local procedure SalesPriceMgtOnAfterFindServLiveItemPrice(var ServiceLine: Record "Service Line"; var TempSalesPrice: Record "Sales Price"; var FoundSalesPrice: Boolean)
    var
        ServiceHeader: Record "Service Header";
        SalesPrice: Record "Sales Price";
        ServiceSetup: Record "Service Mgt. Setup";
        GLSetup: Record "General Ledger Setup";
        ExchangeRate: Record "Currency Exchange Rate";
        CurrencyCode: Code[10];
        RateValue: Decimal;
    begin
        if not ServiceSetup.Get() or not ServiceSetup."BA Use Single Currency Pricing" then
            exit;
        ServiceSetup.TestField("BA Single Price Currency");
        if not FoundSalesPrice and (ServiceLine."Unit Price" <> 0) then begin
            TempSalesPrice."Unit Price" := ServiceLine."Unit Price";
            exit;
        end;
        GLSetup.Get();
        GLSetup.TestField("LCY Code");
        if ServiceSetup."BA Single Price Currency" <> GLSetup."LCY Code" then
            CurrencyCode := ServiceSetup."BA Single Price Currency";
        SalesPrice.SetRange("Item No.", ServiceLine."No.");
        SalesPrice.SetRange("Currency Code", CurrencyCode);
        SalesPrice.SetRange("Starting Date", 0D, WorkDate());
        SalesPrice.SetAscending("Starting Date", true);
        FoundSalesPrice := SalesPrice.FindLast();
        if not FoundSalesPrice then
            exit;
        TempSalesPrice := SalesPrice;
        if not (ServiceLine."Document Type" in [ServiceLine."Document Type"::Quote, ServiceLine."Document Type"::Order]) then
            exit;
        if (ServiceLine."Currency Code" <> CurrencyCode) and GetExchangeRate(ExchangeRate, CurrencyCode) then begin
            GLSetup.TestField("Amount Rounding Precision");
            TempSalesPrice."Unit Price" := Round(TempSalesPrice."Unit Price" * ExchangeRate."Relational Exch. Rate Amount",
                GLSetup."Amount Rounding Precision");
            RateValue := Round(ExchangeRate."Relational Exch. Rate Amount", GLSetup."Amount Rounding Precision");
        end else
            RateValue := 1;
        ServiceHeader.Get(ServiceLine."Document Type", ServiceLine."Document No.");
        ServiceHeader."BA Quote Exch. Rate" := RateValue;
        ServiceHeader.Modify(true);
    end;


    procedure GetExchangeRate(var ExchangeRate: Record "Currency Exchange Rate"; CurrencyCode: Code[10]): Boolean
    begin
        ExchangeRate.SetRange("Currency Code", CurrencyCode);
        ExchangeRate.SetRange("Starting Date", 0D, WorkDate());
        exit(ExchangeRate.FindLast());
    end;

    procedure UpdateSalesPrice(var SalesHeader: Record "Sales Header")
    var
        SalesRecSetup: Record "Sales & Receivables Setup";
        SalesLine: Record "Sales Line";
        ExchangeRate: Record "Currency Exchange Rate";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
    begin
        SalesRecSetup.Get();
        SalesRecSetup.TestField("BA Use Single Currency Pricing", true);
        SalesRecSetup.TestField("BA Single Price Currency");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if not SalesLine.FindSet(true) then
            exit;
        repeat
            SalesPriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, 0);
            SalesLine.UpdateUnitPrice(0);
            SalesLine.Modify(true);
        until SalesLine.Next() = 0;
        SalesHeader.Get(SalesHeader.RecordId());
        Message(ExchageRateUpdateMsg, SalesHeader."BA Quote Exch. Rate");
    end;


    procedure UpdateServicePrice(var ServiceHeader: Record "Service Header")
    var
        ServiceMgtSetup: Record "Service Mgt. Setup";
        ServiceLine: Record "Service Line";
        ExchangeRate: Record "Currency Exchange Rate";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
    begin
        ServiceMgtSetup.Get();
        ServiceMgtSetup.TestField("BA Use Single Currency Pricing", true);
        ServiceMgtSetup.TestField("BA Single Price Currency");
        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.SetRange(Type, ServiceLine.Type::Item);
        if not ServiceLine.FindSet(true) then
            exit;
        repeat
            SalesPriceCalcMgt.FindServLinePrice(ServiceHeader, ServiceLine, 0);
            ServiceLine.UpdateUnitPrice(0);
            ServiceLine.Modify(true);
        until ServiceLine.Next() = 0;
        ServiceHeader.Get(ServiceHeader.RecordId());
        Message(ExchageRateUpdateMsg, ServiceHeader."BA Quote Exch. Rate");
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesShptHeaderInsert', '', false, false)]
    local procedure SalesPostOnBeforeSalesShptHeaderInsert(var SalesShptHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header")
    begin
        SalesHeader.CalcFields("BA Ship-to County Fullname", "BA Bill-to County Fullname", "BA Sell-to County Fullname");
        SalesShptHeader."BA Bill-to County Fullname" := SalesHeader."BA Bill-to County Fullname";
        SalesShptHeader."BA Ship-to County Fullname" := SalesHeader."BA Ship-to County Fullname";
        SalesShptHeader."BA Sell-to County Fullname" := SalesHeader."BA Sell-to County Fullname";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvHeaderInsert', '', false, false)]
    local procedure SalesPostOnBeforeSalesInveaderInsert(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header")
    begin
        SalesHeader.CalcFields("BA Ship-to County Fullname", "BA Bill-to County Fullname", "BA Sell-to County Fullname");
        SalesInvHeader."BA Bill-to County Fullname" := SalesHeader."BA Bill-to County Fullname";
        SalesInvHeader."BA Ship-to County Fullname" := SalesHeader."BA Ship-to County Fullname";
        SalesInvHeader."BA Sell-to County Fullname" := SalesHeader."BA Sell-to County Fullname";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesCrMemoHeaderInsert', '', false, false)]
    local procedure SalesPostOnBeforeSalesCrMemoHeaderInsert(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesHeader: Record "Sales Header")
    begin
        SalesHeader.CalcFields("BA Ship-to County Fullname", "BA Bill-to County Fullname", "BA Sell-to County Fullname");
        SalesCrMemoHeader."BA Bill-to County Fullname" := SalesHeader."BA Bill-to County Fullname";
        SalesCrMemoHeader."BA Ship-to County Fullname" := SalesHeader."BA Ship-to County Fullname";
        SalesCrMemoHeader."BA Sell-to County Fullname" := SalesHeader."BA Sell-to County Fullname";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterPostItemJnlLine', '', false, false)]
    local procedure ItemJnlLinePostOnAfterPostItemJnlLine(ItemLedgerEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ValueEntryNo: Integer)
    begin
        ItemLedgerEntry."BA Adjust. Reason Code" := ItemJournalLine."BA Adjust. Reason Code";
        ItemLedgerEntry."BA Approved By" := ItemJournalLine."BA Approved By";
        if ItemJournalLine."BA Updated" then
            ItemLedgerEntry."BA Year-end Adjst." := true;
        ItemLedgerEntry.Modify(false);
    end;


    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'BA Credit Limit', false, false)]
    local procedure CustomerOnAfterValidateCreditLimitNonLCY(var Rec: Record Customer)
    var
        Currency: Record Currency;
        ExchRate: Record "Currency Exchange Rate";
    begin
        if not Currency.Get(Rec."Customer Posting Group") then
            exit;
        ExchRate.SetRange("Currency Code", Currency.Code);
        ExchRate.SetRange("Starting Date", 0D, WorkDate());
        if ExchRate.FindLast() and (ExchRate."Relational Exch. Rate Amount" <> 0) then
            Rec.Validate("Credit Limit (LCY)", Rec."BA Credit Limit" * ExchRate."Relational Exch. Rate Amount");
    end;

    [EventSubscriber(ObjectType::Report, Report::"Calculate Inventory", 'OnBeforeInsertItemJnlLine', '', false, false)]
    local procedure CalcInventoryOnBeforeInsertItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; YearEndInventoryAdjust: Boolean)
    begin
        if YearEndInventoryAdjust then
            ItemJournalLine."BA Updated" := true;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Calculate Inventory", 'OnAfterPostItemDataItem', '', false, false)]
    local procedure CalcInventoryOnAfterPostItemDataItem(var ItemJnlLine: Record "Item Journal Line")
    var
        ItemJnlLine2: Record "Item Journal Line";
    begin
        ItemJnlLine2.CopyFilters(ItemJnlLine);
        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", ItemJnlLine."Journal Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", ItemJnlLine."Journal Batch Name");
        if DoesItemJnlHaveMultipleItemLines(ItemJnlLine) then
            Message(ImportWarningsMsg);
        ItemJnlLine.Reset();
        ItemJnlLine.CopyFilters(ItemJnlLine2);
    end;

    procedure DoesItemJnlHaveMultipleItemLines(var ItemJnlLine: Record "Item Journal Line"): Boolean
    var
        TempItemJnlLine: Record "Item Journal Line" temporary;
        ItemNos: List of [Code[20]];
        ItemNo: Code[20];
        HasWarnings: Boolean;
    begin
        if ItemJnlLine.IsEmpty() then
            exit(false);
        ItemJnlLine.SetFilter("BA Warning Message", '<>%1', '');
        ItemJnlLine.ModifyAll("BA Warning Message", '');
        ItemJnlLine.SetRange("BA Warning Message");
        if not ItemJnlLine.FindSet() then
            exit(false);
        repeat
            if ItemNos.Contains(ItemJnlLine."Item No.") then begin
                TempItemJnlLine := ItemJnlLine;
                TempItemJnlLine.Insert(false);
            end else
                ItemNos.Add(ItemJnlLine."Item No.");
        until ItemJnlLine.Next() = 0;
        if not TempItemJnlLine.FindSet() then
            exit(false);
        repeat
            ItemJnlLine.SetRange("Item No.", TempItemJnlLine."Item No.");
            if ItemJnlLine.Count() > 1 then begin
                HasWarnings := true;
                ItemJnlLine.ModifyAll("BA Warning Message", StrSubstNo(MultiItemMsg, TempItemJnlLine."Item No."));
            end;
        until TempItemJnlLine.Next() = 0;
        exit(HasWarnings);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Phys. Inventory Journal", 'OnAfterActionEvent', 'CalculateInventory', false, false)]
    local procedure PhysInvJournalOnAfterCalculateInventory(var Rec: Record "Item Journal Line")
    var
        ItemJnlLine: Record "Item Journal Line";
    begin
        ItemJnlLine.CopyFilters(Rec);
        Rec.SetRange("Journal Template Name", Rec."Journal Template Name");
        Rec.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        Rec.SetRange("BA Created At", 0DT);
        Rec.ModifyAll("BA Created At", CurrentDateTime());
        Rec.CopyFilters(ItemJnlLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure ItemJounalLineOnAfterInsert(var Rec: Record "Item Journal Line")
    begin
        Rec."BA Created At" := CurrentDateTime();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Config. Package Management", 'OnApplyItemDimension', '', false, false)]
    local procedure ConfigPackageMgtOnApplyItemDim(ItemNo: Code[20]; DimCode: Code[20]; DimValue: Code[20])
    var
        Item: Record Item;
        ItemCard: Page "Item Card";
    begin
        if Item.Get(ItemNo) and ItemCard.CheckToUpdateDimValues(Item, DimValue) then begin
            Item.Modify(true);
            Commit();
        end;
    end;


    procedure ReuseItemNo(ItemNo: Code[20])
    var
        InventorySetup: Record "Inventory Setup";
        NoSeriesLine: Record "No. Series Line";
        NoSeriesLine2: Record "No. Series Line";
        LineNo: Integer;
    begin
        InventorySetup.Get();
        InventorySetup.TestField("Item Nos.");
        NoSeriesLine2.SetRange("Series Code", InventorySetup."Item Nos.");
        if NoSeriesLine2.FindLast() then
            LineNo := NoSeriesLine2."Line No.";
        NoSeriesLine.Init();
        NoSeriesLine.Validate("Series Code", InventorySetup."Item Nos.");
        NoSeriesLine."Line No." := LineNo + 10000;
        NoSeriesLine."Last No. Used" := ItemNo;
        NoSeriesLine."BA Replacement" := true;
        NoSeriesLine."BA Replacement DateTime" := CurrentDateTime;
        NoSeriesLine.Open := false;
        NoSeriesLine.Insert(false);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::NoSeriesManagement, 'OnBeforeDoGetNextNo', '', false, false)]
    local procedure NoSeriesMgtOnBeforeDoGetNextNo(var ModifySeries: Boolean; var NoSeriesCode: Code[20])
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get();
        if (InventorySetup."Item Nos." = '') or (InventorySetup."Item Nos." <> NoSeriesCode) then
            exit;
        ModifySeries := false;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::NoSeriesManagement, 'OnAfterGetNextNo3', '', false, false)]
    local procedure NoSeriesMgtOnAfterGetNextNo3(var NoSeriesLine: Record "No. Series Line")
    var
        Item: Record Item;
        InventorySetup: Record "Inventory Setup";
        NoSeriesLine2: Record "No. Series Line";
        TempNoSeriesLine: Record "No. Series Line" temporary;
        Reuse: Boolean;
    begin
        InventorySetup.Get();
        if (InventorySetup."Item Nos." = '') or (InventorySetup."Item Nos." <> NoSeriesLine."Series Code") then
            exit;
        SetSeriesLineFilters(NoSeriesLine2, InventorySetup."Item Nos.");
        if not NoSeriesLine2.FindSet() then
            exit;
        repeat
            if Item.Get(NoSeriesLine2."Last No. Used") then begin
                TempNoSeriesLine := NoSeriesLine2;
                TempNoSeriesLine.Insert(false);
            end else
                Reuse := true;
        until Reuse or (NoSeriesLine2.Next() = 0);
        if TempNoSeriesLine.FindSet() then
            repeat
                NoSeriesLine2.Get(TempNoSeriesLine.RecordId());
                NoSeriesLine2.Delete(true);
            until TempNoSeriesLine.Next() = 0;
        if Reuse then
            NoSeriesLine."Last No. Used" := NoSeriesLine2."Last No. Used";
    end;

    local procedure SetSeriesLineFilters(var NoSeriesLine2: Record "No. Series Line"; SeriesCode: Code[20])
    begin
        NoSeriesLine2.SetRange("Series Code", SeriesCode);
        NoSeriesLine2.SetRange("BA Replacement", true);
        NoSeriesLine2.SetCurrentKey("Series Code", "Line No.", "Last No. Used");
        NoSeriesLine2.SetAscending(NoSeriesLine2."Last No. Used", true);
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterInsertEvent', '', false, false)]
    local procedure ItemOnAfterInsert(var Rec: Record Item)
    var
        InventorySetup: Record "Inventory Setup";
        NoSeriesLine: Record "No. Series Line";
    begin
        InventorySetup.Get();
        if (InventorySetup."Item Nos." = '') then
            exit;
        NoSeriesLine.SetRange("Series Code", InventorySetup."Item Nos.");
        NoSeriesLine.SetRange("Last No. Used", Rec."No.");
        NoSeriesLine.SetRange("BA Replacement", true);
        if NoSeriesLine.FindFirst() then
            NoSeriesLine.Delete(true);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Currency Exchange Rate", 'OnAfterValidateEvent', 'Relational Exch. Rate Amount', false, false)]
    local procedure CurrencyExchangeRateOnAfterValidateRelationExchRateAmount(var Rec: Record "Currency Exchange Rate"; var xRec: Record "Currency Exchange Rate")
    var
        Customer: Record Customer;
        Window: Dialog;
        RecCount: Integer;
        i: Integer;
    begin
        if (Rec."Currency Code" <> 'USD') or (Rec."Relational Exch. Rate Amount" = xRec."Relational Exch. Rate Amount") then
            exit;
        UpdateSystemIndicator(Rec);
        Customer.SetFilter("BA Credit Limit", '<>%1', 0);
        if not Customer.FindSet(true) then
            exit;
        RecCount := Customer.Count;
        if not Confirm(UpdateCreditLimitMsg) then
            exit;
        Window.Open(UpdateCreditLimitDialog);
        repeat
            i += 1;
            Window.Update(1, StrSubstNo('%1 of %2', i, RecCount));
            Customer.Validate("Credit Limit (LCY)", Customer."BA Credit Limit" * Rec."Relational Exch. Rate Amount");
            Customer.Modify(true);
        until Customer.Next() = 0;
        Window.Close();
    end;


    local procedure UpdateSystemIndicator(var CurrExchRate: Record "Currency Exchange Rate")
    var
        CompInfo: Record "Company Information";
        DateRec: Record Date;
    begin
        CompInfo.Get('');
        DateRec.SetRange("Period Type", DateRec."Period Type"::Month);
        DateRec.SetRange("Period Start", DMY2Date(1, Date2DMY(CurrExchRate."Starting Date", 2), 2000));
        DateRec.FindFirst();
        CompInfo."Custom System Indicator Text" := CopyStr(StrSubstNo(ExchangeRateText, CompanyName(), CurrExchRate."Relational Exch. Rate Amount", DateRec."Period Name"), 1, MaxStrLen(CompInfo."Custom System Indicator Text"));
        CompInfo.Modify(false);
    end;


    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Credit Limit (LCY)', false, false)]
    local procedure CustomerNoAfterValidateCreditLimit(var Rec: Record Customer; var xRec: Record Customer)
    begin
        if Rec."Credit Limit (LCY)" = xRec."Credit Limit (LCY)" then
            exit;
        Rec."BA Credit Limit Last Updated" := CurrentDateTime();
        Rec."BA Credit Limit Updated By" := UserId();
        Rec.Modify(true);
    end;




    procedure LocationListLookup(): Code[20]
    begin
        exit(LocationListLookup(false));
    end;


    procedure LocationListLookup(WarehouseLookup: Boolean): Code[20]
    var
        Location: Record Location;
        LocationList: Page "Location List";
        WarehouseEmployee: Record "Warehouse Employee";
        FilterStr: Text;
    begin
        Location.FilterGroup(2);
        Location.SetRange("BA Inactive", false);
        if WarehouseLookup and (UserId() <> '') then begin
            WarehouseEmployee.SetRange("User ID", UserId());
            if WarehouseEmployee.FindSet() then
                repeat
                    if FilterStr = '' then
                        FilterStr := WarehouseEmployee."Location Code"
                    else
                        FilterStr += '|' + WarehouseEmployee."Location Code";
                until WarehouseEmployee.Next() = 0
            else
                Error(WarehouseEmployeeSetupError, UserId(), WarehouseEmployee.TableCaption());
            Location.SetFilter(Code, FilterStr);
        end;
        Location.FilterGroup(0);
        LocationList.SetTableView(Location);
        LocationList.LookupMode(true);
        if LocationList.RunModal() <> Action::LookupOK then
            exit('');
        LocationList.GetRecord(Location);
        exit(Location.Code);
    end;


    [EventSubscriber(ObjectType::Table, Database::Location, 'OnBeforeFindLocations', '', false, false)]
    local procedure LocationOnBeforeFindLocations(var Location: Record Location)
    begin
        Location.SetRange("BA Inactive", false);
    end;

    [EventSubscriber(ObjectType::Report, Report::"Create Warehouse Location", 'OnLocationLookup', '', false, false)]
    local procedure CreateWarehouseLocationOnLocationLookup(var Location: Record Location; var LocCode: Code[10])
    begin
        LocCode := LocationListLookup();
    end;

    [EventSubscriber(ObjectType::Report, Report::"Refresh Production Order", 'OnAfterRefreshProdOrder', '', false, false)]
    local procedure RefreshProdOrderOnAfterRefreshProdOrder(var ProductionOrder: Record "Production Order"; ErrorOccured: Boolean)
    var
        ProdBOMHeader: Record "Production BOM Header";
    begin
        if ErrorOccured or (ProductionOrder."Source Type" <> ProductionOrder."Source Type"::Item) or not ProdBOMHeader.Get(ProductionOrder."Source No.") then
            exit;
        ProdBOMHeader.CalcFields("BA Active Version");
        ProductionOrder."BA Source Version" := ProdBOMHeader."BA Active Version";
        ProductionOrder.Modify(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ENC SEI Functions", 'CopyCustomTemplateFieldsOnAfterSetFilters', '', false, false)]
    local procedure CopyCustomTemplateFieldsOnAfterSetFilters(var FieldRec: Record Field)
    begin
        AddFieldFilter(FieldRec);
        // if not Confirm(StrSubstNo('CopyCustomTemplateFieldsOnAfterSetFilters\%1 -> %2', FieldRec.GetFilters, FieldRec.Count())) then
        //     Error('');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ENC SEI Functions", 'AssignCustomTemplateFieldsOnAfterSetFilters1', '', false, false)]
    local procedure AssignCustomTemplateFieldsOnAfterSetFilters1(var FieldRec: Record Field)
    begin
        AddFieldFilter(FieldRec);
        // if not Confirm(StrSubstNo('AssignCustomTemplateFieldsOnAfterSetFilters1\%1 -> %2', FieldRec.GetFilters, FieldRec.Count())) then
        //     Error('');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ENC SEI Functions", 'AssignCustomTemplateFieldsOnAfterSetFilters2', '', false, false)]
    local procedure AssignCustomTemplateFieldsOnAfterSetFilters2(var FieldRec: Record Field)
    begin
        AddFieldFilter(FieldRec);
        // if not Confirm(StrSubstNo('AssignCustomTemplateFieldsOnAfterSetFilters2\%1 -> %2', FieldRec.GetFilters, FieldRec.Count())) then
        //     Error('');
    end;

    local procedure AddFieldFilter(var FieldRec: Record Field)
    var
        FilterText: Text;
        MinValue: Integer;
        MaxValue: Integer;
    begin
        MinValue := 80000;
        MaxValue := 80199;
        FilterText := FieldRec.GetFilter("No.");
        if FilterText <> '' then
            FieldRec.SetFilter("No.", StrSubstNo('%1|%2', FilterText, StrSubstNo('%1..%2', MinValue, MaxValue)))
        else
            FieldRec.SetRange("No.", MinValue, MaxValue);
    end;



    // [EventSubscriber(ObjectType::Table, Database::"BA Product Profile", 'OnAfterValidateEvent', 'Replenishment System', false, false)]
    // local procedure ProductProfileOnAfterValidateReplenishmentSystem(var Rec: Record "BA Product Profile")
    // begin
    //     if Rec."Replenishment System" <> Rec."Replenishment System"::Assembly then
    //         Rec.TestField("Assembly Policy", Rec."Assembly Policy"::"Assemble-to-Stock");
    //     if Rec."Replenishment System" <> Rec."Replenishment System"::Purchase then
    //         Rec.TestField(Type, Rec.Type::Inventory);
    // end;
    // [EventSubscriber(ObjectType::Table, Database::"BA Product Profile", 'OnAfterValidateEvent', 'Assembly Policy', false, false)]
    // local procedure ProductProfileOnAfterValidateAssemblyPolicy(var Rec: Record "BA Product Profile")
    // begin
    //     if Rec."Assembly Policy" = Rec."Assembly Policy"::"Assemble-to-Stock" then
    //         Rec.TestField("Replenishment System", Rec."Replenishment System"::Assembly);
    //     if Rec."Assembly Policy" = Rec."Assembly Policy"::"Assemble-to-Order" then
    //         if not (Rec.Type in [Rec.Type::"Non-Inventory", Rec.Type::Service]) then
    //             Rec.FieldError(Type);
    // end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeRunWithCheck', '', false, false)]
    local procedure ItemJnlPostLineOnBeforeRunWithCheck(var ItemJournalLine: Record "Item Journal Line")
    begin
        if not IsInventoryApprovalEnabled() or (ItemJournalLine."Journal Template Name" <> 'ITEM') then
            exit;
        ItemJournalLine.TestField("BA Adjust. Reason Code");
        if ItemJournalLine."BA Status" = ItemJournalLine."BA Status"::Rejected then
            Error(RejectedLineError, ItemJournalLine."Line No.");
        if ItemJournalLine."BA Status" = ItemJournalLine."BA Status"::Pending then
            Error(PendingLineError, ItemJournalLine."Line No.");
        if (ItemJournalLine."BA Status" <> ItemJournalLine."BA Status"::Released) and not CheckInventoryLimit(ItemJournalLine) then
            Error(JnlLimitError);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure ApprovalsMgtOnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    begin
        ApprovalUpdateActions(ApprovalEntry, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure ApprovalsMgtOnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    begin
        ApprovalUpdateActions(ApprovalEntry, true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterSetApprovalCommentLine', '', false, false)]
    local procedure ApprovalsMgtOnAfterSetApprovalCommentLine(var ApprovalCommentLine: Record "Approval Comment Line"; WorkflowStepInstanceID: Guid)
    begin
        ApprovalCommentLine.SetRange("Workflow Step Instance ID", WorkflowStepInstanceID)
    end;

    local procedure IsInventoryApprovalEnabled(): Boolean;
    var
        InventorySetup: Record "Inventory Setup";
    begin
        exit(InventorySetup.Get() and InventorySetup."BA Approval Required");
    end;

    local procedure ApprovalUpdateActions(var ApprovalEntry: Record "Approval Entry"; Rejected: Boolean)
    var
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        if not IsInventoryApprovalEnabled() or (ApprovalEntry."Table ID" <> Database::"Item Journal Batch") or not ItemJnlBatch.Get(ApprovalEntry."Record ID to Approve") then
            exit;
        UpdateItemLineApprovalStatus(ItemJnlBatch, Rejected);
        UpdateOtherApprovalEntries(ApprovalEntry, Rejected);
        SendApprovalNotification(ApprovalEntry);
    end;

    local procedure UpdateOtherApprovalEntries(var ApprovalEntry: Record "Approval Entry"; Rejected: Boolean)
    var
        OtherEntry: Record "Approval Entry";
        NewStatus: Option;
    begin
        if Rejected then
            NewStatus := ApprovalEntry.Status::Rejected
        else
            NewStatus := ApprovalEntry.Status::Approved;
        OtherEntry.SetCurrentKey("Table ID", "Record ID to Approve", "Status", "Workflow Step Instance ID", "Sequence No.");
        OtherEntry.SetRange("Table ID", Database::"Item Journal Batch");
        OtherEntry.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        OtherEntry.SetRange(Status, OtherEntry.Status::Open);
        OtherEntry.SetRange("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
        OtherEntry.ModifyAll(Status, NewStatus, true);
    end;

    local procedure UpdateItemLineApprovalStatus(var ItemJnlBatch: Record "Item Journal Batch"; Rejected: Boolean)
    var
        ItemJnlLine: Record "Item Journal Line";
        RecIDList: List of [RecordId];
        RecID: RecordId;
    begin
        ItemJnlLine.SetRange("Journal Template Name", ItemJnlBatch."Journal Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", ItemJnlBatch.Name);
        ItemJnlLine.SetRange("BA Locked For Approval", true);
        ItemJnlLine.SetRange("BA Status", ItemJnlLine."BA Status"::Pending);
        if not ItemJnlLine.FindSet() then
            exit;
        repeat
            RecIDList.Add(ItemJnlLine.RecordId());
        until ItemJnlLine.Next() = 0;
        foreach RecID in RecIDList do begin
            ItemJnlLine.Get(RecID);
            ItemJnlLine.Validate("BA Locked For Approval", false);
            if Rejected then
                ItemJnlLine.Validate("BA Status", ItemJnlLine."BA Status"::Rejected)
            else begin
                ItemJnlLine.Validate("BA Status", ItemJnlLine."BA Status"::Released);
                ItemJnlLine.Validate("BA Approved By", UserId());
            end;
            ItemJnlLine.Modify(false);
        end;
    end;

    procedure CheckInventoryLimit(var ItemJournalLine: Record "Item Journal Line"): Boolean
    var
        InventorySetup: Record "Inventory Setup";
        ItemJnlLine: Record "Item Journal Line";
    begin
        InventorySetup.Get();
        if not InventorySetup."BA Approval Required" or (InventorySetup."BA Approval Limit" = 0) then
            exit(true);
        ItemJnlLine.SetRange("Journal Template Name", ItemJournalLine."Journal Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", ItemJournalLine."Journal Batch Name");
        ItemJnlLine.SetFilter(Amount, '>%1', InventorySetup."BA Approval Limit");
        exit(ItemJnlLine.IsEmpty());
    end;

    procedure SendItemJnlApproval(var ItemJnlLine: Record "Item Journal Line"; Cancelled: Boolean)
    var
        ItemJnlBatch: Record "Item Journal Batch";
        InventorySetup: Record "Inventory Setup";
        FilterRec: Record "Item Journal Line";
        ApprovalEntry: Record "Approval Entry";
        CheckItemJnlLine: Codeunit "Item Jnl.-Check Line";
        ApprovalAmt: Decimal;
        TempGUID: Guid;
        EntryList: List of [Integer];
        EntryNo: Integer;
    begin
        InventorySetup.Get();
        if not InventorySetup."BA Approval Required" then
            Error(InventoryAppDisabledError);
        if (InventorySetup."BA Approval Admin1" = '') and (InventorySetup."BA Approval Admin2" = '') then
            Error(NoApprovalAdminError);
        InventorySetup.TestField("BA Approval Code");
        ItemJnlBatch.Get(ItemJnlLine."Journal Template Name", ItemJnlLine."Journal Batch Name");
        FilterRec.CopyFilters(ItemJnlLine);
        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", ItemJnlLine."Journal Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", ItemJnlLine."Journal Batch Name");
        ItemJnlLine.SetRange("BA Locked For Approval", true);
        if Cancelled then begin
            if ItemJnlLine.IsEmpty() then
                Error(NoApprovalToCancelError, ItemJnlBatch.RecordId());
            ApprovalEntry.SetCurrentKey("Table ID", "Record ID to Approve", "Status", "Workflow Step Instance ID", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", Database::"Item Journal Batch");
            ApprovalEntry.SetRange("Record ID to Approve", ItemJnlBatch.RecordId());
            ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
            ApprovalEntry.SetRange("Workflow Step Instance ID", ItemJnlLine."BA Approval GUID");
            if not ApprovalEntry.IsEmpty() then
                Error(AlreadyApprovedError);
        end else
            if not Cancelled and not ItemJnlLine.IsEmpty() then
                Error(AlreadySubmittedError, ItemJnlBatch.RecordId());

        ItemJnlLine.SetRange("BA Locked For Approval");
        ItemJnlLine.FindSet(true);
        if Cancelled then begin
            repeat
                ItemJnlLine.Validate("BA Locked For Approval", false);
                ItemJnlLine.Validate("BA Status", ItemJnlLine."BA Status"::" ");
                ItemJnlLine.Modify(false);
            until ItemJnlLine.Next() = 0;
            ItemJnlLine.Reset();
            ItemJnlLine.CopyFilters(FilterRec);
            ApprovalEntry.SetCurrentKey("Table ID", "Record ID to Approve", "Status", "Workflow Step Instance ID", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", Database::"Item Journal Batch");
            ApprovalEntry.SetRange("Record ID to Approve", ItemJnlBatch.RecordId());
            ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
            ApprovalEntry.SetRange("Workflow Step Instance ID", ItemJnlLine."BA Approval GUID");
            ApprovalEntry.SetRange("Sender ID", UserId());
            if ApprovalEntry.FindSet(true) then
                repeat
                    EntryList.Add(ApprovalEntry."Entry No.");
                until ApprovalEntry.Next() = 0;
            foreach EntryNo in EntryList do begin
                ApprovalEntry.Get(EntryNo);
                ApprovalEntry.Validate(Status, ApprovalEntry.Status::Canceled);
                ApprovalEntry.Modify(true);
            end;
            Message(CancelRequestMsg);
            exit;
        end;

        ItemJnlLine.SetRange("BA Adjust. Reason Code", '');
        if not ItemJnlLine.IsEmpty() then
            Error(NoAdjustReasonError, ItemJnlLine.FieldCaption("BA Adjust. Reason Code"));
        ItemJnlLine.SetRange("BA Adjust. Reason Code");
        repeat
            CheckItemJnlLine.RunCheck(ItemJnlLine);
            ApprovalAmt += ItemJnlLine.Amount;
        until ItemJnlLine.Next() = 0;

        ItemJnlLine.FindSet(true);
        if CheckInventoryLimit(ItemJnlLine) then begin
            repeat
                ItemJnlLine.Validate("BA Locked For Approval", false);
                ItemJnlLine.Validate("BA Status", ItemJnlLine."BA Status"::Released);
                ItemJnlLine.Modify(false);
            until ItemJnlLine.Next() = 0;
            Message(NoApprovalNeededMsg);
        end else begin
            TempGUID := CreateGuid();
            repeat
                ItemJnlLine.Validate("BA Locked For Approval", true);
                ItemJnlLine.Validate("BA Status", ItemJnlLine."BA Status"::Pending);
                ItemJnlLine."BA Approval GUID" := TempGUID;
                ItemJnlLine.Modify(false);
            until ItemJnlLine.Next() = 0;

            ApprovalEntry.SetCurrentKey("Table ID", "Record ID to Approve", "Status", "Workflow Step Instance ID", "Sequence No.");
            ApprovalEntry.SetRange("Table ID", Database::"Item Journal Batch");
            ApprovalEntry.SetRange("Record ID to Approve", ItemJnlBatch.RecordId());
            ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
            ApprovalEntry.SetRange("Workflow Step Instance ID", TempGUID);
            if not ApprovalEntry.IsEmpty() then
                Error(AlreadyAwaitingApprovalError, ItemJnlBatch.RecordId());
            ApprovalEntry.Reset();
            if ApprovalEntry.FindLast() then
                EntryNo := ApprovalEntry."Entry No.";
            if InventorySetup."BA Approval Admin1" <> '' then
                AddItemJnlBatchApprovalEntry(EntryNo, ItemJnlBatch, InventorySetup."BA Approval Admin1", ApprovalAmt, InventorySetup."BA Approval Code", TempGUID);
            if InventorySetup."BA Approval Admin2" <> '' then
                AddItemJnlBatchApprovalEntry(EntryNo, ItemJnlBatch, InventorySetup."BA Approval Admin2", ApprovalAmt, InventorySetup."BA Approval Code", TempGUID);
            Message(RequestSentMsg);
        end;
        ItemJnlLine.Reset();
        ItemJnlLine.CopyFilters(FilterRec);
    end;

    procedure ReopenApprovalRequest(var ItemJnlLine: Record "Item Journal Line")
    var
        ApprovalEntry: Record "Approval Entry";
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        ItemJnlBatch.Get(ItemJnlLine."Journal Template Name", ItemJnlLine."Journal Batch Name");
        ApprovalEntry.SetCurrentKey("Table ID", "Record ID to Approve", "Status", "Workflow Step Instance ID", "Sequence No.");
        ApprovalEntry.SetRange("Table ID", Database::"Item Journal Batch");
        ApprovalEntry.SetRange("Record ID to Approve", ItemJnlBatch.RecordId());
        ApprovalEntry.SetFilter(Status, '%1|%2', ApprovalEntry.Status::Approved, ApprovalEntry.Status::Canceled);
        ApprovalEntry.SetRange("Workflow Step Instance ID", ItemJnlLine."BA Approval GUID");
        ApprovalEntry.SetRange("Sender ID", UserId());
        ApprovalEntry.ModifyAll(Status, ApprovalEntry.Status::Canceled);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SetRange("Workflow Step Instance ID");
        ApprovalEntry.DeleteAll(true);
    end;

    local procedure AddItemJnlBatchApprovalEntry(var EntryNo: Integer; ItemJnlBatch: Record "Item Journal Batch"; Approver: Code[50]; ApprovalAmt: Decimal; ApprovalCode: Code[20]; WorkflowGUID: Guid)
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        EntryNo += 1;
        ApprovalEntry.Init();
        ApprovalEntry."Entry No." := EntryNo;
        ApprovalEntry.Validate("Table ID", Database::"Item Journal Batch");
        ApprovalEntry.Validate("Sender ID", UserId());
        ApprovalEntry.Validate("Record ID to Approve", ItemJnlBatch.RecordId());
        ApprovalEntry.Validate(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.Validate("Date-Time Sent for Approval", CurrentDateTime());
        ApprovalEntry.Validate("Due Date", WorkDate());
        ApprovalEntry.Validate(Amount, ApprovalAmt);
        ApprovalEntry.Validate("Amount (LCY)", ApprovalAmt);
        ApprovalEntry.Validate("Approval Type", ApprovalEntry."Approval Type"::Approver);
        ApprovalEntry.Validate("Limit Type", ApprovalEntry."Limit Type"::"No Limits");
        ApprovalEntry.Validate("Approval Code", ApprovalCode);
        ApprovalEntry.Validate("Document Type", ApprovalEntry."Document Type"::" ");
        ApprovalEntry.Validate("Approver ID", Approver);
        ApprovalEntry.Insert(true);
        ApprovalEntry.Validate("BA Journal Batch Name", ItemJnlBatch.Name);
        ApprovalEntry.Validate("Workflow Step Instance ID", WorkflowGUID);
        ApprovalEntry.Modify(true);
        SendApprovalNotification(ApprovalEntry);
    end;

    procedure ClearApprovalEntries()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        if UserId <> 'ENCORE' then
            exit;
        ApprovalEntry.SetRange("Table ID", Database::"Item Journal Batch");
        ApprovalEntry.DeleteAll(true);
    end;


    local procedure SendApprovalNotification(var ApprovalEntry: Record "Approval Entry")
    var
        NotificationEntry: Record "Notification Entry";
        ItemJnlBatch: Record "Item Journal Batch";
        ItemJnlLine: Record "Item Journal Line";
        PageMgt: Codeunit "Page Management";
        RecRef: RecordRef;
    begin
        if not ItemJnlBatch.Get(ApprovalEntry."Record ID to Approve") then
            exit;
        ItemJnlLine.SetRange("Journal Template Name", ItemJnlBatch."Journal Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", ItemJnlBatch.Name);
        if not ItemJnlLine.FindFirst() then
            exit;
        RecRef.GetTable(ItemJnlLine);
        NotificationEntry.CreateNewEntry(NotificationEntry.Type::Approval, ApprovalEntry."Approver ID",
            ApprovalEntry, Page::"Item Journal", PageMgt.GetRTCUrl(RecRef, Page::"Item Journal"), ApprovalEntry."Sender ID");
    end;


    [EventSubscriber(ObjectType::Report, Report::"Notification Email", 'OnAfterSetReportFieldPlaceholders', '', false, false)]
    local procedure NotificationEmailOnAfterSetReportFieldPlaceholders(var NotificationEntry: Record "Notification Entry"; var DocumentURL: Text)
    begin
        if (NotificationEntry.Type = NotificationEntry.Type::Approval) and (NotificationEntry."Link Target Page" = Page::"Item Journal")
                and (NotificationEntry."Custom Link" <> '') then
            DocumentURL := NotificationEntry."Custom Link";
    end;


    [EventSubscriber(ObjectType::Table, Database::"Production BOM Version", 'OnAfterValidateEvent', 'Starting Date', false, false)]
    local procedure ProdBOMVersionOnAfterValidateStartingDate(var Rec: Record "Production BOM Version"; var xRec: Record "Production BOM Version")
    begin
        if xRec."Starting Date" = Rec."Starting Date" then
            exit;
        UpdateBOMActive(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Production BOM Version", 'OnAfterValidateEvent', 'Status', false, false)]
    local procedure ProdBOMVersionOnAfterValidateStatus(var Rec: Record "Production BOM Version"; var xRec: Record "Production BOM Version")
    begin
        UpdateBOMActive(Rec);
    end;

    procedure UpdateBOMActive(var ProdBomVersion: Record "Production BOM Version")
    var
        ProdBOMVersion2: Record "Production BOM Version";
        VersionMgt: Codeunit VersionManagement;
        ActiveVersion: Code[20];
    begin
        ProdBomVersion.Modify(false);
        ProdBomVersion.Get(ProdBomVersion.RecordId());
        ActiveVersion := VersionMgt.GetBOMVersion(ProdBomVersion."Production BOM No.", WorkDate(), true);

        ProdBomVersion."BA Active" := ProdBomVersion."Version Code" = ActiveVersion;
        ProdBOMVersion2.SetRange("Production BOM No.", ProdBomVersion."Production BOM No.");
        ProdBOMVersion2.SetFilter("Version Code", '<>%1', ActiveVersion);
        ProdBOMVersion2.ModifyAll("BA Active", false, false);
        if ProdBOMVersion2.Get(ProdBomVersion."Production BOM No.", ActiveVersion) then begin
            ProdBomVersion2."BA Active" := true;
            ProdBomVersion2.Modify(false);
        end;
        ProdBomVersion.Get(ProdBomVersion.RecordId());
    end;

    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure ApprovalEntryOnAfterInsert(var Rec: Record "Approval Entry")
    var
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        RecRef: RecordRef;
    begin
        if not RecRef.Get(Rec."Record ID to Approve") or (RecRef.Number <> Database::"Sales Header") then
            exit;
        RecRef.SetTable(SalesHeader);
        Rec."BA Customer Name" := SalesHeader."Bill-to Name";
        Rec."BA Customer No." := SalesHeader."Bill-to Customer No.";
        Rec."BA Payment Terms Code" := SalesHeader."Payment Terms Code";
        Rec."BA Salesperson Code" := SalesHeader."Salesperson Code";
        Customer.Get(Rec."BA Customer No.");
        if UseLCYCreditLimit(Customer) then
            Rec."BA Credit Limit" := Customer."Credit Limit (LCY)"
        else
            Rec."BA Credit Limit" := Customer."BA Credit Limit";
        Rec.CalcFields("BA Last Sales Activity");
        Rec.Modify(false);
    end;

    local procedure UseLCYCreditLimit(var Customer: Record Customer): Boolean
    var
        CustPostingGroup: Record "Customer Posting Group";
    begin
        exit((Customer."Customer Posting Group" = '') or
            (CustPostingGroup.Get(Customer."Customer Posting Group") and not CustPostingGroup."BA Show Non-Local Currency"));
    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure SalesPostOnAfterPostSalesDoc(var SalesHeader: Record "Sales Header")
    var
        Customer: Record Customer;
    begin
        if Customer.Get(SalesHeader."Bill-to Customer No.") then begin
            Customer."BA Last Sales Activity" := Today();
            Customer.Modify(false);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Service-Post", 'OnAfterPostServiceDoc', '', false, false)]
    local procedure ServicePostOnAfterPostServiceDoc(var ServiceHeader: Record "Service Header")
    var
        Customer: Record Customer;
    begin
        if Customer.Get(ServiceHeader."Bill-to Customer No.") then begin
            Customer."BA Last Sales Activity" := Today();
            Customer.Modify(false);
        end;
    end;


    var
        UpdateCreditLimitMsg: Label 'Do you want to update all USD customer''s credit limit?\This may take a while depending on the number of customers.';
        UpdateCreditLimitDialog: Label 'Updating Customer Credit Limits\#1###';
        ExtDocNoFormatError: Label '%1 field is improperly formatted for International Orders:\%2';
        InvalidPrefixError: Label 'Missing "SO" prefix.';
        MissingNumeralError: Label 'Missing numeral suffix.';
        NonNumeralError: Label 'Non-numeric character: %1.';
        TooLongSuffixError: Label 'Numeral suffix length is greater than 7.';
        TooShortSuffixError: Label 'Numeral suffix length is less than 7.';
        ExchageRateUpdateMsg: Label 'Updated exchange rate to %1.';
        MultiItemMsg: Label 'Item %1 occurs on multiple lines.';
        ImportWarningsMsg: Label 'Inventory calculation completed with warnings.\Please review warning messages per line, where applicable.';
        JnlLimitError: Label 'This journal adjustment is outside the limit, please request approval.';
        NoApprovalAdminError: Label 'An inventory approval admin must be set before approvals can be sent.';
        NoApprovalToCancelError: Label '%1 has not been submitted for approval.';
        AlreadyApprovedError: Label 'Cannot cancel approval request as it as been approved by one or more approvers.';
        AlreadySubmittedError: Label '%1 has already been submitted for approval.';
        CancelRequestMsg: Label 'Cancelled approval request.';
        NoAdjustReasonError: Label '%1 has not been specified for one or more lines.';
        NoApprovalNeededMsg: Label 'Inventory adjustment is within the limit, no approval needed.';
        AlreadyAwaitingApprovalError: Label '%1 is already awaiting approval.';
        RequestSentMsg: Label 'An approval request has been sent.';
        RejectedLineError: Label 'Line %1 has been rejected and must be re-submitted for approval.';
        PendingLineError: Label 'Line %1 is still awaiting approval.';
        CustGroupBlockedError: Label '%1 %2 is blocked';
        ExchangeRateText: Label '%1 - USD Exch. Rate %2 (%3)';
        WarehouseEmployeeSetupError: Label '%1 must be setup as an %2';
        InventoryAppDisabledError: Label 'Inventory Approval is not enabled.';
}