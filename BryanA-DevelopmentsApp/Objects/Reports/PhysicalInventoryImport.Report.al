report 50080 "BA Physical Inventory Import"
{
    Caption = 'Physical Inventory Import';
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = Tasks;

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(DocNo; DocNo)
                    {
                        ApplicationArea = all;
                        Caption = 'Document No.';
                    }
                    field(CalculateMissingItems; CalculateMissingItems)
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies if a new journal line will be created and calculate for items that are not already present in the journal upon import.';
                        Caption = 'Create lines for missing items';
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        if TemplateName = '' then
            Error('Template Name must be specified.');
        if BatchName = '' then
            Error('Batch Name must be specified.');
        if DocNo = '' then
            Error('Document No. must be specified');
        ImportExcelToPhysicalItemJnl();
    end;

    local procedure ImportExcelToPhysicalItemJnl()
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        ItemJnlLine: Record "Item Journal Line";
        Window: Dialog;
        ItemNo: Code[20];
        QtyList: List of [Decimal];
        Qty: Decimal;
        LineNo: Integer;
        RecCount: Integer;
        i: Integer;
    begin
        if not ImportFile(ExcelBuffer, 'Physical Inventory Import') then
            exit;
        ExcelBuffer.SetFilter("Row No.", '>%1', 1);
        if not ExcelBuffer.FindSet() then
            exit;
        Window.Open('#1####/#2####');
        Window.Update(1, 'Reading Lines');
        ExcelBuffer.SetRange("Column No.", 2);
        RecCount := ExcelBuffer.Count();
        repeat
            i += 1;
            Window.Update(2, StrSubstNo('%1 of %2', i, RecCount));
            if not Evaluate(Qty, ExcelBuffer."Cell Value as Text") then
                Qty := -1;
            QtyList.Add(Qty);
        until ExcelBuffer.Next() = 0;
        ItemJnlLine.SetRange("Journal Template Name", TemplateName);
        ItemJnlLine.SetRange("Journal Batch Name", BatchName);
        if ItemJnlLine.FindLast() then
            LineNo := ItemJnlLine."Line No.";
        Window.Update(1, 'Importing Lines');
        Window.Update(2, '');
        ItemJnlLine.ModifyAll("BA Updated", false);
        ItemJnlLine.SetRange("BA Updated", false);
        ExcelBuffer.SetRange("Column No.", 1);
        ExcelBuffer.FindSet();
        i := 1;
        repeat
            i += 1;
            Window.Update(2, StrSubstNo('%1 of %2', i, RecCount));
            ItemNo := CopyStr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(ItemJnlLine."Item No."));
            ItemJnlLine.SetRange("Item No.", ItemNo);
            QtyList.Get(ExcelBuffer."Row No.", Qty);
            if Qty <> -1 then
                if ItemJnlLine.FindFirst() then
                    UpdateItemJnlLine(ItemJnlLine, Qty)
                else
                    if CalculateMissingItems then
                        CreateItemJnlLine(LineNo, ItemNo, Qty);
        until ExcelBuffer.Next() = 0;
        Window.Close();

        ItemJnlLine.SetRange("Item No.", '');
        ItemJnlLine.DeleteAll(true);
    end;




    local procedure CreateItemJnlLine(var LineNo: Integer; ItemNo: Code[20]; Qty: Decimal)
    var
        ItemJnlLine: Record "Item Journal Line";
    begin
        LineNo += 10000;
        ItemJnlLine.Init();
        ItemJnlLine.Validate("Journal Template Name", TemplateName);
        ItemJnlLine.Validate("Journal Batch Name", BatchName);
        ItemJnlLine.Validate("Line No.", LineNo);
        ItemJnlLine.Validate("Document No.", DocNo);
        ItemJnlLine.Validate("Posting Date", PostingDate);
        ItemJnlLine.Validate("Item No.", ItemNo);
        ItemJnlLine.Validate("Location Code", LocationCode);
        ItemJnlLine.Validate("Phys. Inventory", true);
        ItemJnlLine.Validate("Qty. (Calculated)", Qty);
        ItemJnlLine.Validate("Qty. (Phys. Inventory)", Qty);
        ItemJnlLine."BA Updated" := true;
        ItemJnlLine.Insert(true);
    end;



    local procedure UpdateItemJnlLine(var ItemJnlLine: Record "Item Journal Line"; Qty: Decimal)
    begin
        ItemJnlLine.Validate("Qty. (Phys. Inventory)", Qty);
        ItemJnlLine."BA Updated" := true;
        ItemJnlLine.Modify(true);
    end;

    procedure SetParameters(var ItemJnlLine: Record "Item Journal Line")
    begin
        TemplateName := ItemJnlLine."Journal Template Name";
        BatchName := ItemJnlLine."Journal Batch Name";
        DocNo := ItemJnlLine."Document No.";
        PostingDate := ItemJnlLine."Posting Date";
        LocationCode := ItemJnlLine."Location Code";
    end;

    local procedure ImportFile(var ExcelBuffer: Record "Excel Buffer"; WindowName: Text): Boolean
    var
        NameBuffer: Record "Name/Value Buffer" temporary;
        TempBlob: Record TempBlob;
        IStream: InStream;
        FileName: Text;
    begin
        if not ExcelBuffer.IsTemporary then
            Error(NotTempRecError);
        if FileMgt.BLOBImportWithFilter(TempBlob, WindowName, '', 'Excel|*.xlsx', 'Excel|*.xlsx') = '' then
            exit(false);
        TempBlob.Blob.CreateInStream(IStream);
        if not ExcelBuffer.GetSheetsNameListFromStream(IStream, NameBuffer) then
            Error(NoSheetsError);
        NameBuffer.FindFirst();
        ExcelBuffer.OpenBookStream(IStream, NameBuffer.Value);
        ExcelBuffer.ReadSheet();
        exit(true);
    end;


    var
        FileMgt: Codeunit "File Management";
        CalculateMissingItems: Boolean;
        BatchName: Code[20];
        TemplateName: Code[20];
        DocNo: Code[20];
        LocationCode: Code[10];
        PostingDate: Date;

        NotTempRecError: Label 'Must use a temporary record to import excel data.';
        NoSheetsError: Label 'No sheets found.';
        MissingSheetError: Label 'No sheet found with name %1.', Comment = '%1 = Sheetname';



}