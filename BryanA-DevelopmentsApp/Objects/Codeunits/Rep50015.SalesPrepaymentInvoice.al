report 50015 "ENC Sales Prepayment Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.\Objects\ReportLayouts\Rep50015.SalesPrepaymentInvoice.rdl';
    Caption = 'Sales - Prepayment Invoice';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING ("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Ship-to Code", "No. Printed";
            RequestFilterHeading = 'Sales Invoice';
            column(No_SalesInvHeader; "No.")
            {
            }
            column(CurrencyCode; CurrencyCode)
            {
            }
            column(TaxRegistrationNo; '')
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD ("No.");
                DataItemTableView = SORTING ("Document No.", "Line No.");

                trigger OnAfterGetRecord()
                begin
                    if CompressedPrepayments then
                        exit;
                    TempSalesInvoiceLine := "Sales Invoice Line";
                    TempSalesInvoiceLine.INSERT;
                    TempSalesInvoiceLineAsm := "Sales Invoice Line";
                    TempSalesInvoiceLineAsm.INSERT;

                    HighestLineNo := "Line No.";
                end;
            }

            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING (Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING (Number)
                                        WHERE (Number = CONST (1));
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInformationPicture; CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyAddress1; CompanyAddress[1])
                    {
                    }
                    column(CompanyAddress2; CompanyAddress[2])
                    {
                    }
                    column(CompanyAddress3; CompanyAddress[3])
                    {
                    }
                    column(CompanyAddress4; CompanyAddress[4])
                    {
                    }
                    column(CompanyAddress5; CompanyAddress[5])
                    {
                    }
                    column(CompanyAddress6; CompanyAddress[6])
                    {
                    }
                    column(CopyTxt; CopyTxt)
                    {
                    }
                    column(BillToAddress1; BillToAddress[1])
                    {
                    }
                    column(BillToAddress2; BillToAddress[2])
                    {
                    }
                    column(BillToAddress3; BillToAddress[3])
                    {
                    }
                    column(BillToAddress4; BillToAddress[4])
                    {
                    }
                    column(BillToAddress5; BillToAddress[5])
                    {
                    }
                    column(BillToAddress6; BillToAddress[6])
                    {
                    }
                    column(BillToAddress7; BillToAddress[7])
                    {
                    }
                    column(BillToAddress9; BillToAddress[9])
                    {
                    }
                    column(BillToAddress10; BillToAddress[10])
                    {
                    }
                    column(BillToAddress11; BillToAddress[11])
                    {
                    }
                    column(ShipmentMethodDescription; ShipmentMethod.Description)
                    {
                    }
                    column(ShptDate_SalesInvHeader; "Sales Invoice Header"."Shipment Date")
                    {
                    }
                    column(DueDate_SalesInvHeader; "Sales Invoice Header"."Due Date")
                    {
                    }
                    column(PaymentTermsDescription; PaymentTerms.Description)
                    {
                    }
                    column(ShipToAddress1; ShipToAddress[1])
                    {
                    }
                    column(ShipToAddress2; ShipToAddress[2])
                    {
                    }
                    column(ShipToAddress3; ShipToAddress[3])
                    {
                    }
                    column(ShipToAddress4; ShipToAddress[4])
                    {
                    }
                    column(ShipToAddress5; ShipToAddress[5])
                    {
                    }
                    column(ShipToAddress6; ShipToAddress[6])
                    {
                    }
                    column(ShipToAddress7; ShipToAddress[7])
                    {
                    }
                    column(ShipToAddress9; ShipToAddress[9])
                    {
                    }
                    column(ShipToAddress10; ShipToAddress[10])
                    {
                    }
                    column(ShipToAddress11; ShipToAddress[11])
                    {
                    }
                    column(BilltoCustNo_SalesInvHeader; "Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(YourRef_SalesInvHeader; "Sales Invoice Header"."External Document No.")
                    {
                    }
                    column(OrderDate_SalesInvHeader; "Sales Invoice Header"."Order Date")
                    {
                    }
                    column(OrderNo_SalesInvHeader; "Sales Invoice Header"."Prepayment Order No.")
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(DocumentDate_SalesInvHeader; FORMAT("Sales Invoice Header"."Document Date", 0, '<Month Text,3>/<Day,2>/<Year4>'))
                    {
                    }
                    column(CompanyAddress7; CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress8; CompanyAddress[8])
                    {
                    }
                    column(BillToAddress8; BillToAddress[8])
                    {
                    }
                    column(ShipToAddress8; ShipToAddress[8])
                    {
                    }
                    column(TaxRegNo; TaxRegNo)
                    {
                    }
                    column(TaxRegLabel; TaxRegLabel)
                    {
                    }
                    column(DocumentText; DocumentText)
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }
                    column(CustTaxIdentificationType; FORMAT(Cust."Tax Identification Type"))
                    {
                    }
                    column(BillCaption; BillCaptionLbl)
                    {
                    }
                    column(ToCaption; ToCaptionLbl)
                    {
                    }
                    column(ShipViaCaption; ShipViaCaptionLbl)
                    {
                    }
                    column(ShipDateCaption; ShipDateCaptionLbl)
                    {
                    }
                    column(DueDateCaption; DueDateCaptionLbl)
                    {
                    }
                    column(TermsCaption; TermsCaptionLbl)
                    {
                    }
                    column(CustomerIDCaption; CustomerIDCaptionLbl)
                    {
                    }
                    column(PONumberCaption; PONumberCaptionLbl)
                    {
                    }
                    column(PODateCaption; PODateCaptionLbl)
                    {
                    }
                    column(OurOrderNoCaption; OurOrderNoCaptionLbl)
                    {
                    }
                    column(SalesPersonCaption; SalesPersonCaptionLbl)
                    {
                    }
                    column(ShipCaption; ShipCaptionLbl)
                    {
                    }
                    column(InvoiceNumberCaption; InvoiceNumberCaptionLbl)
                    {
                    }
                    column(InvoiceDateCaption; InvoiceDateCaptionLbl)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption; TaxIdentTypeCaptionLbl)
                    {
                    }
                    column(PaymentMethods1Lbl; PaymentMethods1Lbl)
                    {
                    }
                    column(PaymentMethods2Lbl; PaymentMethods2Lbl)
                    {
                    }
                    dataitem(SalesInvLine; Integer)
                    {
                        DataItemTableView = SORTING (Number);
                        column(TempSalesInvoiceLineLineDiscountPct; TempSalesInvoiceLine."Line Discount %")
                        {
                        }
                        column(BackOrderQty; BackOrderQty)
                        {
                        }
                        column(SerialText; SerialText)
                        {
                        }
                        column(PrintFooter; PrintFooter)
                        {
                        }
                        column(AmountExclInvDisc; AmountExclInvDisc)
                        {
                        }
                        column(TempSalesInvoiceLineNo; NoToPrint)
                        {
                        }
                        column(TempSalesInvoiceLineUOM; TempSalesInvoiceLine."Unit of Measure")
                        {
                        }
                        column(OrderedQuantity; OrderedQuantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(TempSalesInvoiceLineQty; InvoiceQuantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(UnitPriceToPrint; UnitPriceToPrint)
                        {
                            DecimalPlaces = 2 : 5;
                        }
                        column(LowDescriptionToPrint; DescriptionToPrint)
                        {
                        }
                        column(HighDescriptionToPrint; DescriptionToPrint)
                        {
                        }
                        column(TempSalesInvoiceLineDocNo; TempSalesInvoiceLine."Document No.")
                        {
                        }
                        column(TempSalesInvoiceLineLineNo; TempSalesInvoiceLine."Line No.")
                        {
                        }
                        column(TaxLiable; TaxLiable)
                        {
                        }
                        column(TempSalesInvoiceLineAmtTaxLiable; TempSalesInvoiceLine.Amount - TaxLiable)
                        {
                        }
                        column(TempSalesInvoiceLineAmtAmtExclInvDisc; TempSalesInvoiceLine.Amount - AmountExclInvDisc)
                        {
                        }
                        column(TempSalesInvoiceLineAmtInclVATAmount; TempSalesInvoiceLine."Amount Including VAT" - TempSalesInvoiceLine.Amount)
                        {
                        }
                        column(TempSalesInvoiceLineAmtInclVAT; TempSalesInvoiceLine."Amount Including VAT")
                        {
                        }
                        column(TotalTaxLabel; TotalTaxLabel)
                        {
                        }
                        column(BreakdownTitle; BreakdownTitle)
                        {
                        }
                        column(BreakdownLabel1; BreakdownLabel[1])
                        {
                        }
                        column(BreakdownAmt1; BreakdownAmt[1])
                        {
                        }
                        column(BreakdownAmt2; BreakdownAmt[2])
                        {
                        }
                        column(BreakdownLabel2; BreakdownLabel[2])
                        {
                        }
                        column(BreakdownAmt3; BreakdownAmt[3])
                        {
                        }
                        column(BreakdownLabel3; BreakdownLabel[3])
                        {
                        }
                        column(BreakdownAmt4; BreakdownAmt[4])
                        {
                        }
                        column(BreakdownLabel4; BreakdownLabel[4])
                        {
                        }
                        column(ItemDescriptionCaption; ItemDescriptionCaptionLbl)
                        {
                        }
                        column(UnitCaption; UnitCaptionLbl)
                        {
                        }
                        column(OrderQtyCaption; OrderQtyCaptionLbl)
                        {
                        }
                        column(QuantityCaption; QuantityCaptionLbl)
                        {
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(TotalPriceCaption; TotalPriceCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(InvoiceDiscountCaption; InvoiceDiscountCaptionLbl)
                        {
                        }
                        column(TotalCaption; CurrencyCode + ' ' + TotalCaptionLbl)
                        {
                        }
                        column(AmountSubjecttoSalesTaxCaption; AmountSubjecttoSalesTaxCaptionLbl)
                        {
                        }
                        column(AmountExemptfromSalesTaxCaption; AmountExemptfromSalesTaxCaptionLbl)
                        {
                        }
                        column(DisplayDiscount; DisplayDiscount)
                        {
                        }
                        column(TermsBlurb; TermsBlurb)
                        {
                        }

                        column(PrepmtPercent; PrepmtPercent) { }
                        column(PrepmtAmt; PrepmtAmt) { }
                        column(DiscountAmount; TempSalesInvoiceLine."Line Discount %") { }
                        column(PrepmtAmtTotal; PrepmtAmtTotal) { }



                        dataitem(AsmLoop; Integer)
                        {
                            DataItemTableView = SORTING (Number);
                            column(TempPostedAsmLineUOMCode; GetUOMText(TempPostedAsmLine."Unit of Measure Code"))
                            {
                                //DecimalPlaces = 0 : 5;
                            }
                            column(TempPostedAsmLineQuantity; TempPostedAsmLine.Quantity)
                            {
                                //DecimalPlaces = 0 : 5;
                            }
                            column(TempPostedAsmLineDesc; BlanksForIndent + TempPostedAsmLine.Description)
                            {
                            }
                            column(TempPostedAsmLineNo; BlanksForIndent + TempPostedAsmLine."No.")
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN
                                    TempPostedAsmLine.FINDSET
                                ELSE BEGIN
                                    TempPostedAsmLine.NEXT;
                                    TaxLiable := 0;
                                    AmountExclInvDisc := 0;
                                    TempSalesInvoiceLine.Amount := 0;
                                    TempSalesInvoiceLine."Amount Including VAT" := 0;
                                END;
                            end;

                            trigger OnPreDataItem()
                            begin
                                CLEAR(TempPostedAsmLine);
                                SETRANGE(Number, 1, TempPostedAsmLine.COUNT);
                            end;
                        }

                        //TempSalesInvoiceLine
                        trigger OnPreDataItem()
                        begin
                            TempSalesInvoiceLine.RESET;
                            NumberOfLines := TempSalesInvoiceLine.COUNT;
                            SETRANGE(Number, 1, NumberOfLines);
                            OnLineNumber := 0;
                            PrintFooter := FALSE;
                            TempSalesLine2.Reset;
                            TempSalesLine2.DeleteAll
                        end;

                        //TempSalesInvoiceLine
                        trigger OnAfterGetRecord()
                        var
                            Salesline: Record "Sales Line";
                        begin
                            OnLineNumber := OnLineNumber + 1;

                            WITH TempSalesInvoiceLine DO BEGIN
                                IF OnLineNumber = 1 THEN
                                    FindSet
                                ELSE
                                    NEXT;

                                if not CompressedPrepayments then begin
                                    TempSalesLine.Reset;
                                    TempSalesLine.SetRange(Description, Description);
                                    TempSalesLine.FindFirst;
                                    if TempSalesLine.Count > 1 then begin
                                        while TempSalesLine2.Get(TempSalesLine.RecordId) do
                                            TempSalesLine.Next;
                                        TempSalesLine2 := TempSalesLine;
                                        TempSalesLine2.Insert;
                                    end;
                                    Salesline := TempSalesLine;

                                    "No." := Salesline."No.";
                                    "No. 2" := Salesline."No. 2";
                                    Quantity := Salesline.Quantity;
                                    "Unit Price" := Salesline."Unit Price";
                                    "Unit of Measure" := Salesline."Unit of Measure";
                                    Amount := Salesline."Prepayment Amount";

                                    OrderedQuantity := Salesline.Quantity;
                                    InvoiceQuantity := Salesline."Qty. to Invoice";
                                    DescriptionToPrint := Salesline.Description + ' ' + Salesline."Description 2";
                                    AmountExclInvDisc := Salesline.Amount;
                                    PrepmtPercent := Salesline."Prepayment %";
                                    PrepmtAmt := Salesline."Prepayment Amount";

                                    IF Salesline."Prepayment Amount" <> Salesline."Prepmt. Amt. Incl. VAT" THEN BEGIN
                                        TaxFlag := TRUE;
                                        TaxLiable := Amount;
                                    END ELSE BEGIN
                                        TaxFlag := FALSE;
                                        TaxLiable := 0;
                                    END;
                                end else begin
                                    OrderedQuantity := Quantity;
                                    InvoiceQuantity := "Qty. per Unit of Measure";
                                    DescriptionToPrint := Description + ' ' + "Description 2";
                                    AmountExclInvDisc := Amount;
                                    PrepmtPercent := "Net Weight";
                                    PrepmtAmt := TempSalesInvoiceLine."Units per Parcel";

                                    IF "Amount" <> "Amount Including VAT" THEN BEGIN
                                        TaxFlag := TRUE;
                                        TaxLiable := Amount;
                                    END ELSE BEGIN
                                        TaxFlag := FALSE;
                                        TaxLiable := 0;
                                    END;
                                end;
                                IF "ENC No. 2" <> '' THEN
                                    NoToPrint := "No." + '/' + "ENC No. 2"
                                ELSE
                                    NoToPrint := "No.";

                                IF Quantity = 0 THEN
                                    UnitPriceToPrint := 0
                                ELSE
                                    UnitPriceToPrint := ROUND("Unit Price");
                            END;

                            IF OnLineNumber = NumberOfLines THEN
                                PrintFooter := TRUE;
                            CollectAsmInformation(TempSalesInvoiceLine);
                        end;
                    }
                }
                trigger OnPreDataItem()
                begin
                    IF NoLoops <= 0 THEN
                        NoLoops := 1;
                    CopyNo := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    IF CopyNo = NoLoops THEN BEGIN
                        IF NOT CurrReport.PREVIEW THEN
                            SalesInvPrinted.RUN("Sales Invoice Header");
                        CurrReport.BREAK;
                    END;
                    CopyNo := CopyNo + 1;
                    IF CopyNo = 1 THEN // Original
                        CLEAR(CopyTxt)
                    ELSE
                        CopyTxt := Text000;
                    CopyTxt := StrSubstNo('Original %1', CopyNo);
                end;
            }

            //header
            trigger OnAfterGetRecord()
            var
                Customer: Record "Customer";
                i: Integer;
                billIndex: Integer;
                shipIndex: Integer;
                assigned: Boolean;
                TaxRegNo: Text;
                PhoneNo: Text;
                ShipToPhoneNo: Text;
                ShipToTaxRegNo: Text;
                SalesHeader: Record "Sales Header";
                SalesHeaderArchive: Record "Sales Header Archive";
                SalesLine: Record "Sales Line";
                TempSalesLineArchive: Record "Sales Line" temporary;
                UseArchive: Boolean;
            begin
                TempSalesInvoiceLine.RESET;
                TempSalesInvoiceLine.DELETEALL;
                TempSalesInvoiceLineAsm.RESET;
                TempSalesInvoiceLineAsm.DELETEALL;

                if not SalesHeader.Get(SalesHeader."Document Type"::Order, "Sales Invoice Header"."Prepayment Order No.") then begin
                    SalesHeaderArchive.SetRange("Document Type", SalesHeaderArchive."Document Type"::Order);
                    SalesHeaderArchive.SetRange("No.", "Sales Invoice Header"."Prepayment Order No.");
                    if not SalesHeaderArchive.FindLast() then
                        Error('Unable to find original Sales Order.');
                    PopulateArchiveData(SalesHeader, SalesHeaderArchive, TempSalesLineArchive);
                    UseArchive := true;
                end;
                CompressedPrepayments := SalesHeader."Compress Prepayment";
                if UseArchive then begin
                    GetSalesLines(TempSalesLineArchive);
                    GetSourceTaxes(SalesHeader, SalesHeaderArchive, TempSalesLineArchive);
                end else begin
                    GetSalesLines(SalesLine);
                    GetSourceTaxes(SalesHeader, SalesHeaderArchive, SalesLine);
                end;


                IF PrintCompany THEN BEGIN
                    IF RespCenter.GET("Responsibility Center") THEN BEGIN
                        FormatAddress.RespCenter(CompanyAddress, RespCenter);
                        CompanyInformation."Phone No." := RespCenter."Phone No.";
                        CompanyInformation."Fax No." := RespCenter."Fax No.";
                    END;
                END;
                CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                IF "Sales Invoice Header"."Invoice Discount Amount" = 0 THEN
                    DisplayDiscount := FALSE
                ELSE
                    DisplayDiscount := TRUE;

                IF "Salesperson Code" = '' THEN
                    CLEAR(SalesPurchPerson)
                ELSE
                    SalesPurchPerson.GET("Salesperson Code");

                IF NOT Customer.GET("Bill-to Customer No.") THEN BEGIN
                    CLEAR(Customer);
                    "Bill-to Name" := Text009;
                    "Ship-to Name" := Text009;
                END;
                DocumentText := "No.";
                NoLoops := 1 + ABS(NoCopies) + Customer."Invoice Copies";

                FormatAddress.SalesInvBillTo(BillToAddress, "Sales Invoice Header");
                FormatAddress.SalesInvShipTo(ShipToAddress, ShipToAddress, "Sales Invoice Header");
                if not LoadedCompAddress then begin
                    LoadedCompAddress := true;
                    SEIFunctions.FormatCompanyAddress(CompanyAddress, CompanyInformation);
                    SEIFunctions.AddFooterToAddress(BillToAddress, "ENC Ship-to Phone No.", "ENC Tax Registration No.", "ENC FID No.");
                    SEIFunctions.AddFooterToAddress(ShipToAddress, "ENC Ship-to Phone No.", "ENC Ship-To Tax Reg. No.", "ENC Ship-To FID No.");
                end;


                IF "Currency Code" <> '' THEN BEGIN
                    CurrencyCode := "Currency Code";
                    TermsBlurb := IntTerms;
                END ELSE BEGIN
                    CurrencyCode := GLSetup."LCY Code";
                    TermsBlurb := CanTerms;
                END;


                IF "Payment Terms Code" = '' THEN
                    CLEAR(PaymentTerms)
                ELSE
                    PaymentTerms.GET("Payment Terms Code");

                IF "Shipment Method Code" = '' THEN
                    CLEAR(ShipmentMethod)
                ELSE
                    ShipmentMethod.GET("Shipment Method Code");


                IF LogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN BEGIN
                        IF "Bill-to Contact No." <> '' THEN
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, DATABASE::Contact, "Bill-to Contact No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '')
                        ELSE
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, DATABASE::Customer, "Bill-to Customer No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '');
                    END;
            end;

            trigger OnPreDataItem()
            begin
                GLSetup.GET;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoCopies; NoCopies)
                    {
                        Caption = 'Number of Copies';
                    }
                    field(PrintCompanyAddress; PrintCompany)
                    {
                        Caption = 'Print Company Address';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                    }
                    field(DisplayAsmInfo; DisplayAssemblyInformation)
                    {
                        Caption = 'Show Assembly Components';
                    }
                }
            }
        }

        trigger OnInit()
        begin
            LogInteractionEnable := TRUE;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
            PrintCompany := TRUE;
        end;
    }

    trigger OnPreReport()
    begin
        ShipmentLine.SETCURRENTKEY("Order No.", "Order Line No.");
        IF NOT CurrReport.USEREQUESTPAGE THEN
            InitLogInteraction;

        CompanyInformation.GET;
        SalesSetup.GET;

        CompanyInfo3.GET;
        CompanyInfo3.CALCFIELDS(Picture);

        CASE SalesSetup."Logo Position on Documents" OF
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                BEGIN
                    CompanyInfo3.GET;
                    CompanyInfo3.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Center:
                BEGIN
                    CompanyInfo1.GET;
                    CompanyInfo1.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Right:
                BEGIN
                    CompanyInfo2.GET;
                    CompanyInfo2.CALCFIELDS(Picture);
                END;
        END;

        PrintCompany := TRUE;
        FormatAddress.Company(CompanyAddress, CompanyInformation);
    end;

    var
        TaxLiable: Decimal;
        OrderedQuantity: Decimal;
        InvoiceQuantity: Decimal;
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record "Customer";
        OrderLine: Record "Sales Line";
        ShipmentLine: Record "Sales Shipment Line";
        TempSalesInvoiceLine: Record "Sales Invoice Line" temporary;
        TempSalesInvoiceLineAsm: Record "Sales Invoice Line" temporary;
        RespCenter: Record "Responsibility Center";
        Language: Record "Language";
        TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
        TaxArea: Record "Tax Area";
        Cust: Record "Customer";
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        CompanyAddress: array[8] of Text[80];
        BillToAddress: array[11] of Text[50];
        ShipToAddress: array[11] of Text[50];
        CopyTxt: Text[10];
        DescriptionToPrint: Text;
        PrintCompany: Boolean;
        PrintFooter: Boolean;
        TaxFlag: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        HighestLineNo: Integer;
        SpacePointer: Integer;
        SalesInvPrinted: Codeunit "Sales Inv.-Printed";
        FormatAddress: Codeunit "Format Address";
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        SegManagement: Codeunit "SegManagement";
        LogInteraction: Boolean;
        Text000: Label 'COPY';
        TaxRegNo: Text[30];
        TaxRegLabel: Text[30];
        TotalTaxLabel: Text[30];
        BreakdownTitle: Text[30];
        BreakdownLabel: array[4] of Text[30];
        BreakdownAmt: array[4] of Decimal;
        Text004: Label 'Other Taxes';
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        Text005: Label 'Total Sales Tax:';
        Text006: Label 'Tax Breakdown:';
        Text007: Label 'Total Tax:';
        Text008: Label 'Tax:';
        Text009: Label 'VOID INVOICE';
        DocumentText: Text;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        BillCaptionLbl: Label 'Bill';
        ToCaptionLbl: Label 'To:';
        ShipViaCaptionLbl: Label 'Ship Via';
        ShipDateCaptionLbl: Label 'Ship Date';
        DueDateCaptionLbl: Label 'Due Date';
        TermsCaptionLbl: Label 'Terms';
        CustomerIDCaptionLbl: Label 'Customer ID';
        PONumberCaptionLbl: Label 'P.O. Number';
        PODateCaptionLbl: Label 'P.O. Date';
        OurOrderNoCaptionLbl: Label 'Order No.';
        SalesPersonCaptionLbl: Label 'Sales ID';
        ShipCaptionLbl: Label 'Ship';
        InvoiceNumberCaptionLbl: Label 'Invoice Number:';
        InvoiceDateCaptionLbl: Label 'Invoice Date:';
        PageCaptionLbl: Label 'Page:';
        TaxIdentTypeCaptionLbl: Label 'Tax Ident. Type';
        ItemDescriptionCaptionLbl: Label 'Item/Description';
        UnitCaptionLbl: Label 'Unit';
        OrderQtyCaptionLbl: Label 'Qty Ordered';
        QuantityCaptionLbl: Label 'Qty Shipped';
        UnitPriceCaptionLbl: Label 'Unit Price';
        TotalPriceCaptionLbl: Label 'Total Price';
        SubtotalCaptionLbl: Label 'Subtotal:';
        InvoiceDiscountCaptionLbl: Label 'Invoice Discount:';
        TotalCaptionLbl: Label 'Total:';
        AmountSubjecttoSalesTaxCaptionLbl: Label 'Amount Subject to Sales Tax';
        AmountExemptfromSalesTaxCaptionLbl: Label 'Amount Exempt from Sales Tax';
        SerialText: Text[1024];
        SerialNoILE: Record "Item Ledger Entry" temporary;
        CurrencyCode: Code[20];
        GLSetup: Record "General Ledger Setup";
        BackOrderQty: Decimal;
        NoToPrint: Code[41];
        Text1000000006: Label 'Serial Nos.: ';
        DisplayDiscount: Boolean;
        CanTerms: Label 'See SEI General Terms & Conditions - Canada (S.04.005)';
        IntTerms: Label 'See SEI General Terms & Conditions - International (S.04.006)';
        PaymentMethods1Lbl: Label 'Accepted Payment Methods:';
        PaymentMethods2Lbl: Label 'Visa | Mastercard | Wire Transfer | ACH Credit | Fedwire';
        TermsBlurb: Text[70];
        TempSalesLine: Record "Sales Line" temporary;
        TempSalesLine2: Record "Sales Line" temporary;
        PrepmtPercent: Decimal;
        PrepmtAmt: Decimal;
        LoadedCompAddress: Boolean;
        SEIFunctions: Codeunit "ENC SEI Functions";
        PremPaymentInvcLbl: Label 'PREPAYMENT INVOICE';
        CompressedPrepayments: Boolean;
        PrepmtAmtTotal: Decimal;

    local procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    end;

    local procedure CollectAsmInformation(TempSalesInvoiceLine: Record "Sales Invoice Line" temporary)
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        TempPostedAsmLine.DELETEALL;
        IF NOT DisplayAssemblyInformation THEN
            EXIT;
        IF NOT TempSalesInvoiceLineAsm.GET(TempSalesInvoiceLine."Document No.", TempSalesInvoiceLine."Line No.") THEN
            EXIT;
        SalesInvoiceLine.GET(TempSalesInvoiceLineAsm."Document No.", TempSalesInvoiceLineAsm."Line No.");
        IF SalesInvoiceLine.Type <> SalesInvoiceLine.Type::Item THEN
            EXIT;
        WITH ValueEntry DO BEGIN
            SETCURRENTKEY("Document No.");
            SETRANGE("Document No.", SalesInvoiceLine."Document No.");
            SETRANGE("Document Type", "Document Type"::"Sales Invoice");
            SETRANGE("Document Line No.", SalesInvoiceLine."Line No.");
            IF NOT FINDSET THEN
                EXIT;
        END;
        REPEAT
            IF ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") THEN BEGIN
                IF ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment" THEN BEGIN
                    SalesShipmentLine.GET(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");
                    IF SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) THEN BEGIN
                        PostedAsmLine.SETRANGE("Document No.", PostedAsmHeader."No.");
                        IF PostedAsmLine.FINDSET THEN
                            REPEAT
                                TreatAsmLineBuffer(PostedAsmLine);
                            UNTIL PostedAsmLine.NEXT = 0;
                    END;
                END;
            END;
        UNTIL ValueEntry.NEXT = 0;
    end;

    local procedure TreatAsmLineBuffer(PostedAsmLine: Record "Posted Assembly Line")
    begin
        CLEAR(TempPostedAsmLine);
        TempPostedAsmLine.SETRANGE(Type, PostedAsmLine.Type);
        TempPostedAsmLine.SETRANGE("No.", PostedAsmLine."No.");
        TempPostedAsmLine.SETRANGE("Variant Code", PostedAsmLine."Variant Code");
        TempPostedAsmLine.SETRANGE(Description, PostedAsmLine.Description);
        TempPostedAsmLine.SETRANGE("Unit of Measure Code", PostedAsmLine."Unit of Measure Code");
        IF TempPostedAsmLine.FINDFIRST THEN BEGIN
            TempPostedAsmLine.Quantity += PostedAsmLine.Quantity;
            TempPostedAsmLine.MODIFY;
        END ELSE BEGIN
            CLEAR(TempPostedAsmLine);
            TempPostedAsmLine := PostedAsmLine;
            TempPostedAsmLine.INSERT;
        END;
    end;

    local procedure GetUOMText(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        IF NOT UnitOfMeasure.GET(UOMCode) THEN
            EXIT(UOMCode);
        EXIT(UnitOfMeasure.Description);
    end;

    local procedure BlanksForIndent(): Text[10]
    begin
        EXIT(PADSTR('', 2, ' '));
    end;

    local procedure PopulateArchiveData(var SalesHeader: Record "Sales Header"; var ArchiveSalesHeader: Record "Sales Header Archive"; var TempSalesLine: Record "Sales Line")
    var
        ArchiveSalesLine: Record "Sales Line Archive";
    begin
        SalesHeader.TransferFields(ArchiveSalesHeader);
        TempSalesLine.Reset();
        TempSalesLine.DeleteAll(false);

        ArchiveSalesLine.SetRange("Document Type", ArchiveSalesHeader."Document Type");
        ArchiveSalesLine.SetRange("Document No.", ArchiveSalesHeader."No.");
        ArchiveSalesLine.SetRange("Version No.", ArchiveSalesHeader."Version No.");
        ArchiveSalesLine.SetRange("Doc. No. Occurrence", ArchiveSalesHeader."Doc. No. Occurrence");
        if ArchiveSalesLine.FindSet() then
            repeat
                TempSalesLine.TransferFields(ArchiveSalesLine);
                TempSalesLine.Insert(false);
            until ArchiveSalesLine.Next() = 0;
    end;

    local procedure GetSalesLines(var SalesLine: Record "Sales Line")
    begin
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", "Sales Invoice Header"."Prepayment Order No.");
        SalesLine.SetFilter("Prepayment Amount", '<>%1', 0);

        if CompressedPrepayments then begin
            PrepmtAmt := 0;
            PrepmtAmtTotal := 0;
            if SalesLine.FindSet then
                repeat
                    TempSalesInvoiceLine.Init;
                    TempSalesInvoiceLine."Document No." := "Sales Invoice Header"."No.";
                    TempSalesInvoiceLine."Line No." := SalesLine."Line No.";
                    TempSalesInvoiceLine.Type := SalesLine.Type;
                    TempSalesInvoiceLine."No." := SalesLine."No.";
                    TempSalesInvoiceLine."No. 2" := SalesLine."ENC No. 2";
                    TempSalesInvoiceLine.Quantity := SalesLine.Quantity;
                    TempSalesInvoiceLine."Unit Price" := SalesLine."Unit Price";
                    TempSalesInvoiceLine."Unit of Measure" := SalesLine."Unit of Measure";
                    TempSalesInvoiceLine."Qty. per Unit of Measure" := SalesLine."Qty. to Invoice";
                    TempSalesInvoiceLine.Amount := SalesLine.Amount;
                    TempSalesInvoiceLine."Amount Including VAT" := SalesLine."Prepmt. Amt. Incl. VAT";
                    TempSalesInvoiceLine.Description := SalesLine.Description;
                    TempSalesInvoiceLine."Description 2" := SalesLine."Description 2";
                    TempSalesInvoiceLine."Net Weight" := SalesLine."Prepayment %";
                    TempSalesInvoiceLine."Units per Parcel" := SalesLine.Amount * SalesLine."Prepayment %" / 100;
                    TempSalesInvoiceLine.Insert;
                    PrepmtAmtTotal += TempSalesInvoiceLine."Units per Parcel";
                until SalesLine.Next = 0;
            HighestLineNo := SalesLine."Line No.";
        end else begin
            TempSalesLine.Reset;
            TempSalesLine.DeleteAll;
            if SalesLine.FindSet then
                repeat
                    TempSalesLine := Salesline;
                    TempSalesLine.Insert;
                until SalesLine.Next = 0;
        end;
    end;



    local procedure GetSourceTaxes(var SalesHeader: Record "Sales Header"; var ArchiveSalesHeader: Record "Sales Header Archive"; var TempSalesLineArchive: Record "Sales Line")
    var
        ArchiveSalesLine: Record "Sales Line Archive";
        TempSalesLine: Record "Sales Line" temporary;
        TotalSalesLine: array[3] of Record "Sales Line" temporary;
        TotalSalesLineLCY: array[3] of Record "Sales Line" temporary;
        TempVATAmountLine4: Record "VAT Amount Line" temporary;
        TempSalesTaxLine1: Record "Sales Tax Amount Line" temporary;
        TempSalesTaxLine2: Record "Sales Tax Amount Line" temporary;
        TempSalesTaxLine3: Record "Sales Tax Amount Line" temporary;
        SalesPost: Codeunit "Sales-Post";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        SalesPostPrepayments: Codeunit "Sales-Post Prepayments";
        i: Integer;


        VATAmountText: array[3] of Text;
        PrepmtVATAmountText: Text;
        ProfitLCY: array[3] of Decimal;
        ProfitPct: array[3] of Decimal;
        AdjProfitLCY: array[3] of Decimal;
        AdjProfitPct: array[3] of Decimal;
        VATAmount: array[3] of Decimal;
        TotalAdjCostLCY: array[3] of Decimal;
        TotalSalesLineLCY3: array[3] of Decimal;
        TotalAmount1: array[3] of Decimal;
        TotalAmount2: array[3] of Decimal;
        Amount: Decimal;

        PrepmtTotalAmount: Decimal;
        PrepmtVATAmount: Decimal;
        PrepmtInvPct: Decimal;
        PrepmtDeductedPct: Decimal;
        PrepmtTotalAmount2: Decimal;
        VATPct: Decimal;
    begin
        CLEAR(BreakdownTitle);
        CLEAR(BreakdownLabel);
        CLEAR(BreakdownAmt);
        TotalTaxLabel := Text008;
        TaxRegNo := '';
        TaxRegLabel := '';
        i := 1;

        TempSalesLine.DELETEALL;
        CLEAR(TempSalesLine);
        CLEAR(SalesPost);
        SalesPost.GetSalesLines(SalesHeader, TempSalesLine, i - 1);
        TempSalesLine.Reset();
        if TempSalesLine.IsEmpty() then begin
            TempSalesLineArchive.Reset();
            TempSalesLineArchive.FindSet();
            repeat
                TempSalesLine := TempSalesLineArchive;
                TempSalesLine.Insert(false);
            until TempSalesLineArchive.Next() = 0;
        end;
        CLEAR(SalesPost);
        SalesTaxCalculate.StartSalesTaxCalculation;
        TempSalesLine.SETFILTER(Type, '>0');
        TempSalesLine.SETFILTER(Quantity, '<>0');
        IF TempSalesLine.FIND('-') THEN
            REPEAT
                SalesTaxCalculate.AddSalesLine(TempSalesLine);
            UNTIL TempSalesLine.NEXT = 0;
        TempSalesLine.RESET;
        TempSalesTaxLine1.DELETEALL;
        SalesTaxCalculate.EndSalesTaxCalculation(SalesHeader."Posting Date");
        SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxLine1);

        IF SalesHeader.Status = SalesHeader.Status::Open THEN
            SalesTaxCalculate.DistTaxOverSalesLines(TempSalesLine);
        SalesPost.SumSalesLinesTemp(SalesHeader, TempSalesLine, i - 1, TotalSalesLine[i], TotalSalesLineLCY[i],
            VATAmount[i], VATAmountText[i], ProfitLCY[i], ProfitPct[i], TotalAdjCostLCY[i]);

        AdjProfitLCY[i] := TotalSalesLineLCY[i].Amount - TotalAdjCostLCY[i];
        IF TotalSalesLineLCY[i].Amount <> 0 THEN
            AdjProfitPct[i] := ROUND(AdjProfitLCY[i] / TotalSalesLineLCY[i].Amount * 100, 0.1);
        TotalAmount1[i] := TotalSalesLine[i].Amount;
        TotalAmount2[i] := TotalAmount1[i];
        VATAmount[i] := 0;

        SalesTaxCalculate.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
        BrkIdx := 0;
        PrevPrintOrder := 0;
        PrevTaxPercent := 0;

        WITH TempSalesTaxAmtLine DO BEGIN
            RESET;
            SETCURRENTKEY("Print Order", "Tax Area Code for Key", "Tax Jurisdiction Code");
            IF FindSet() THEN
                REPEAT
                    IF ("Print Order" = 0) OR
                       ("Print Order" <> PrevPrintOrder) OR
                       ("Tax %" <> PrevTaxPercent)
                    THEN BEGIN
                        BrkIdx := BrkIdx + 1;
                        IF BrkIdx > ARRAYLEN(BreakdownAmt) THEN BEGIN
                            BrkIdx := BrkIdx - 1;
                            BreakdownLabel[BrkIdx] := 'Other Taxes';
                        END ELSE
                            BreakdownLabel[BrkIdx] := STRSUBSTNO("Print Description", "Tax %");
                    END;
                    BreakdownAmt[BrkIdx] := BreakdownAmt[BrkIdx] + "Tax Amount";
                    VATAmount[i] := VATAmount[i] + "Tax Amount";
                UNTIL NEXT = 0;
            TotalAmount2[i] := TotalAmount2[i] + VATAmount[i];
        END;
        TempSalesLine.DELETEALL;
        CLEAR(TempSalesLine);

        SalesPostPrepayments.GetSalesLines(SalesHeader, 0, TempSalesLine);
        SalesPostPrepayments.SumPrepmt(SalesHeader, TempSalesLine, TempVATAmountLine4, PrepmtTotalAmount, PrepmtVATAmount, PrepmtVATAmountText);
        PrepmtInvPct := Pct(TotalSalesLine[1]."Prepmt. Amt. Inv.", PrepmtTotalAmount);
        PrepmtDeductedPct := Pct(TotalSalesLine[1]."Prepmt Amt Deducted", TotalSalesLine[1]."Prepmt. Amt. Inv.");
        IF SalesHeader."Prices Including VAT" THEN BEGIN
            PrepmtTotalAmount2 := PrepmtTotalAmount;
            PrepmtTotalAmount := PrepmtTotalAmount + PrepmtVATAmount;
        END ELSE
            PrepmtTotalAmount2 := PrepmtTotalAmount + PrepmtVATAmount;

        if VATAmount[1] <> 0 then
            VATPct := (100 + VATAmount[1]) / 100;
        if VATPct <> 0 then
            PrepmtTotalAmount := Round(PrepmtTotalAmount / VATPct, 0.01);

        Amount := TotalAmount2[1] - VATAmount[1];
        if Amount <> 0 then begin
            PrepmtInvPct := SalesHeader."Prepayment %";

            if PrepmtInvPct <> 0 then
                for i := 1 to 4 do
                    if BreakdownAmt[i] <> 0 then
                        BreakdownAmt[i] := Round(BreakdownAmt[i] * PrepmtInvPct / 100, 0.01);
        end else
            PrepmtInvPct := 0;
    end;

    local procedure Pct(Numerator: Decimal; Denominator: Decimal): Decimal
    begin
        IF Denominator = 0 THEN
            EXIT(0);
        EXIT(ROUND(Numerator / Denominator * 10000, 1));
    end;

}

