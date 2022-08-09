pageextension 80009 "BA Item Card" extends "Item Card"
{
    layout
    {
        addafter("Qty. on Sales Order")
        {
            field("BA Qty. on Sales Quote"; Rec."BA Qty. on Sales Quote")
            {
                ApplicationArea = all;
            }
            field("BA Qty. on Closed Sales Quote"; "BA Qty. on Closed Sales Quote")
            {
                ApplicationArea = all;
            }
        }
        addafter("Last Direct Cost")
        {
            field("BA Last USD Purch. Cost"; "BA Last USD Purch. Cost")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the most recent USD purchase unit cost for the item.';
            }
        }
        addlast(Item)
        {
            group("Dimensions")
            {
                Caption = 'Dimensions';
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field("ENC Shortcut Dimension 3 Code"; "ENC Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("ENC Shortcut Dimension 4 Code"; "ENC Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("ENC Shortcut Dimension 5 Code"; "ENC Shortcut Dimension 5 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("ENC Shortcut Dimension 6 Code"; "ENC Shortcut Dimension 6 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("ENC Shortcut Dimension 7 Code"; "ENC Shortcut Dimension 7 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("ENC Shortcut Dimension 8 Code"; "ENC Shortcut Dimension 8 Code")
                {
                    ApplicationArea = all;
                }
                field("ENC Product ID Code"; "ENC Product ID Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        GLSetup: Record "General Ledger Setup";
        DefaultDim: Record "Default Dimension";
        RecRef: RecordRef;
        RecRef2: RecordRef;
        UpdateRec: Boolean;
    begin
        if Rec."No." = '' then
            exit;
        RecRef.GetTable(Rec);
        GLSetup.Get();
        RecRef2.GetTable(GLSetup);

        if UpdateDimValue(RecRef, RecRef2, GLSetup.FieldNo("Shortcut Dimension 3 Code"), Rec.FieldNo("ENC Shortcut Dimension 3 Code")) then
            UpdateRec := true;
        if UpdateDimValue(RecRef, RecRef2, GLSetup.FieldNo("Shortcut Dimension 4 Code"), Rec.FieldNo("ENC Shortcut Dimension 4 Code")) then
            UpdateRec := true;
        if UpdateDimValue(RecRef, RecRef2, GLSetup.FieldNo("Shortcut Dimension 5 Code"), Rec.FieldNo("ENC Shortcut Dimension 5 Code")) then
            UpdateRec := true;
        if UpdateDimValue(RecRef, RecRef2, GLSetup.FieldNo("Shortcut Dimension 6 Code"), Rec.FieldNo("ENC Shortcut Dimension 6 Code")) then
            UpdateRec := true;
        if UpdateDimValue(RecRef, RecRef2, GLSetup.FieldNo("Shortcut Dimension 7 Code"), Rec.FieldNo("ENC Shortcut Dimension 7 Code")) then
            UpdateRec := true;
        if UpdateDimValue(RecRef, RecRef2, GLSetup.FieldNo("Shortcut Dimension 8 Code"), Rec.FieldNo("ENC Shortcut Dimension 8 Code")) then
            UpdateRec := true;
        if UpdateDimValue(RecRef, RecRef2, GLSetup.FieldNo("ENC Product ID Dim. Code"), Rec.FieldNo("ENC Product ID Code")) then
            UpdateRec := true;

        if UpdateRec then begin
            RecRef.SetTable(Rec);
            CurrPage.Update(true);
        end;
    end;

    local procedure UpdateDimValue(var RecRef: RecordRef; var GLRecRef: RecordRef; GLFldNo: Integer; DimFldNo: Integer): Boolean
    var
        GLSetup: Record "General Ledger Setup";
        DefaultDim: Record "Default Dimension";
        FldRef: FieldRef;
        FldRef2: FieldRef;
        FldRef3: FieldRef;
    begin
        FldRef := GLRecRef.Field(GLFldNo);
        if Format(FldRef.Value) = '' then
            exit(false);
        FldRef2 := RecRef.Field(Rec.FieldNo("No."));
        FldRef3 := RecRef.Field(DimFldNo);
        if DefaultDim.Get(Database::Item, FldRef2.Value, FldRef.Value) then begin
            if Format(FldRef3.Value) <> DefaultDim."Dimension Value Code" then begin
                FldRef3.Validate(DefaultDim."Dimension Value Code");
                exit(true);
            end;
        end else
            if Format(FldRef3.Value) <> '' then begin
                FldRef3.Validate('');
                exit(true);
            end;
        exit(false);
    end;
}