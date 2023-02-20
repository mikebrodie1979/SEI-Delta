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
        addafter("Base Unit of Measure")
        {
            field("ENC Is Fabric"; "ENC Is Fabric")
            {
                ApplicationArea = all;
            }
            field("BA ETL Approved Fabric"; "BA ETL Approved Fabric")
            {
                ApplicationArea = all;
            }
            field("ENC Fabric Brand Name"; "ENC Fabric Brand Name")
            {
                ApplicationArea = all;
            }
        }
        addlast(Item)
        {
            group("BA Dimensions")
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
                field("ENC Shortcut Dimension 3 Code"; DimValue[3])
                {
                    ApplicationArea = all;
                    Visible = false;
                    TableRelation = "Dimension Value".Code where ("Global Dimension No." = const (3), Blocked = const (false));
                    CaptionClass = '1,2,3';

                    trigger OnValidate()
                    begin
                        Rec.Validate("ENC Shortcut Dimension 3 Code", DimValue[3]);
                        Rec."ENC Shortcut Dimension 3 Code" := DimValue[3];
                    end;
                }
                field("ENC Shortcut Dimension 4 Code"; DimValue[4])
                {
                    ApplicationArea = all;
                    Visible = false;
                    TableRelation = "Dimension Value".Code where ("Global Dimension No." = const (4), Blocked = const (false));
                    CaptionClass = '1,2,4';

                    trigger OnValidate()
                    begin
                        Rec.Validate("ENC Shortcut Dimension 4 Code", DimValue[4]);
                        Rec."ENC Shortcut Dimension 4 Code" := DimValue[4];
                    end;
                }
                field("ENC Shortcut Dimension 5 Code"; DimValue[5])
                {
                    ApplicationArea = all;
                    Visible = false;
                    TableRelation = "Dimension Value".Code where ("Global Dimension No." = const (5), Blocked = const (false));
                    CaptionClass = '1,2,5';

                    trigger OnValidate()
                    begin
                        Rec.Validate("ENC Shortcut Dimension 5 Code", DimValue[5]);
                        Rec."ENC Shortcut Dimension 5 Code" := DimValue[5];
                    end;
                }
                field("ENC Shortcut Dimension 6 Code"; DimValue[6])
                {
                    ApplicationArea = all;
                    Visible = false;
                    TableRelation = "Dimension Value".Code where ("Global Dimension No." = const (6), Blocked = const (false));
                    CaptionClass = '1,2,6';

                    trigger OnValidate()
                    begin
                        Rec.Validate("ENC Shortcut Dimension 6 Code", DimValue[6]);
                        Rec."ENC Shortcut Dimension 6 Code" := DimValue[6];
                    end;
                }
                field("ENC Shortcut Dimension 7 Code"; DimValue[7])
                {
                    ApplicationArea = all;
                    Visible = false;
                    TableRelation = "Dimension Value".Code where ("Global Dimension No." = const (7), Blocked = const (false));
                    CaptionClass = '1,2,7';

                    trigger OnValidate()
                    begin
                        Rec.Validate("ENC Shortcut Dimension 7 Code", DimValue[7]);
                        Rec."ENC Shortcut Dimension 7 Code" := DimValue[7];
                    end;
                }
                field("ENC Shortcut Dimension 8 Code"; DimValue[8])
                {
                    ApplicationArea = all;
                    TableRelation = "Dimension Value".Code where ("Global Dimension No." = const (8), Blocked = const (false));
                    CaptionClass = '1,2,8';

                    trigger OnValidate()
                    begin
                        Rec.Validate("ENC Shortcut Dimension 8 Code", DimValue[8]);
                        Rec."ENC Shortcut Dimension 8 Code" := DimValue[8];
                    end;
                }
                field("ENC Product ID Code"; "ENC Product ID Code")
                {
                    ApplicationArea = all;
                }
            }
        }
        modify("Vendor Item No.")
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("Vendor No.")
        {
            ApplicationArea = all;
            Visible = false;
        }
        addafter("Vendor Item No.")
        {
            field("BA Default Cross-Ref. No."; "BA Default Cross-Ref. No.")
            {
                ApplicationArea = all;
                Editable = false;

                trigger OnDrillDown()
                var
                    ItemCrossRef: Record "Item Cross Reference";
                    ItemCrossRefEntries: Page "Item Cross Reference Entries";
                begin
                    ItemCrossRef.FilterGroup(2);
                    ItemCrossRef.SetRange("Item No.", Rec."No.");
                    ItemCrossRefEntries.SetTableView(ItemCrossRef);
                    ItemCrossRefEntries.RunModal();
                    ItemCrossRef.FilterGroup(0);
                    Rec.CalcFields("BA Default Cross-Ref. No.", "BA Default Vendor No.");
                end;
            }
            field("BA Default Vendor No."; "BA Default Vendor No.")
            {
                ApplicationArea = all;
                Editable = false;

                trigger OnDrillDown()
                var
                    Vendor: Record Vendor;
                begin
                    if Rec."BA Default Vendor No." = '' then
                        exit;
                    Vendor.SetRange("No.", Rec."BA Default Vendor No.");
                    Page.RunModal(Page::"Vendor Card", Vendor);
                end;
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        CheckToUpdateDimValues(Rec);
    end;



    procedure CheckToUpdateDimValues(var Item: Record Item): Boolean
    begin
        exit(CheckToUpdateDimValues(Item, ''));
    end;

    procedure CheckToUpdateDimValues(var Item: Record Item; NewDimValue: Code[20]): Boolean
    var
        DefaultDim: Record "Default Dimension";
        RecRef: RecordRef;
        RecRef2: RecordRef;
        DimOffset: Integer;
        i: Integer;
        UpdateRec: Boolean;
    begin
        if Item."No." = '' then
            exit(false);

        RecRef.GetTable(Item);
        for i := 3 to 8 do
            DimValue[i] := RecRef.Field(Rec.FieldNo("ENC Shortcut Dimension 3 Code") + i - 3).Value();
        GLSetup.Get();
        RecRef2.GetTable(GLSetup);

        DimOffset := GLSetup.FieldNo("Shortcut Dimension 3 Code") - 3;
        if UpdateDimValue(RecRef, RecRef2, GLSetup.FieldNo("Shortcut Dimension 3 Code"), Item.FieldNo("ENC Shortcut Dimension 3 Code"), NewDimValue, DimOffset) then
            UpdateRec := true;
        if UpdateDimValue(RecRef, RecRef2, GLSetup.FieldNo("Shortcut Dimension 4 Code"), Item.FieldNo("ENC Shortcut Dimension 4 Code"), NewDimValue, DimOffset) then
            UpdateRec := true;
        if UpdateDimValue(RecRef, RecRef2, GLSetup.FieldNo("Shortcut Dimension 5 Code"), Item.FieldNo("ENC Shortcut Dimension 5 Code"), NewDimValue, DimOffset) then
            UpdateRec := true;
        if UpdateDimValue(RecRef, RecRef2, GLSetup.FieldNo("Shortcut Dimension 6 Code"), Item.FieldNo("ENC Shortcut Dimension 6 Code"), NewDimValue, DimOffset) then
            UpdateRec := true;
        if UpdateDimValue(RecRef, RecRef2, GLSetup.FieldNo("Shortcut Dimension 7 Code"), Item.FieldNo("ENC Shortcut Dimension 7 Code"), NewDimValue, DimOffset) then
            UpdateRec := true;
        if UpdateDimValue(RecRef, RecRef2, GLSetup.FieldNo("Shortcut Dimension 8 Code"), Item.FieldNo("ENC Shortcut Dimension 8 Code"), NewDimValue, DimOffset) then
            UpdateRec := true;
        if UpdateDimValue(RecRef, RecRef2, GLSetup.FieldNo("ENC Product ID Dim. Code"), Item.FieldNo("ENC Product ID Code"), '', DimOffset) then
            UpdateRec := true;


        if UpdateRec then begin
            for i := 3 to 8 do
                DimValue[i] := RecRef.Field(Rec.FieldNo("ENC Shortcut Dimension 3 Code") + i - 3).Value();
            RecRef.SetTable(Item);
            CurrPage.Update(true);
            Rec.Get(Item."No.");
        end;
        exit(UpdateRec);
    end;

    local procedure UpdateDimValue(var RecRef: RecordRef; var GLRecRef: RecordRef; GLFldNo: Integer; DimFldNo: Integer; NewDimValue: Code[20]; DimOffset: Integer): Boolean
    var
        GLSetup: Record "General Ledger Setup";
        DefaultDim: Record "Default Dimension";
        DimValue: Record "Dimension Value";
        FldRef: FieldRef;
        FldRef2: FieldRef;
        FldRef3: FieldRef;
        FldRef4: FieldRef;
        DimMgt: Codeunit DimensionManagement;
        Result: Boolean;
    begin
        FldRef := GLRecRef.Field(GLFldNo);
        if Format(FldRef.Value()) = '' then
            exit(false);
        FldRef2 := RecRef.Field(Rec.FieldNo("No."));
        FldRef3 := RecRef.Field(DimFldNo);
        if NewDimValue <> '' then
            FldRef4 := RecRef.Field(Rec.FieldNo("ENC Skip Dimension Validation"));

        if DefaultDim.Get(Database::Item, FldRef2.Value(), FldRef.Value()) then begin
            if NewDimValue <> '' then begin
                if DimValue.Get(DefaultDim."Dimension Code", NewDimValue) then begin
                    if Format(FldRef3.Value) <> NewDimValue then begin
                        FldRef4.Value(true);
                        FldRef3.Validate(NewDimValue);
                        FldRef4.Value(false);
                        DimMgt.SaveDefaultDim(Database::Item, FldRef2.Value(), GLFldNo - DimOffset, NewDimValue);
                        Result := true;
                    end;
                end;
            end else
                if DimValue.Get(DefaultDim."Dimension Code", DefaultDim."Dimension Value Code") then
                    if Format(FldRef3.Value) <> DefaultDim."Dimension Value Code" then begin
                        FldRef3.Validate(DefaultDim."Dimension Value Code");
                        Result := true;
                    end;
        end else
            if Format(FldRef3.Value()) <> '' then begin
                FldRef3.Validate('');
                Result := true;
            end;
        exit(Result);
    end;


    var
        GLSetup: Record "General Ledger Setup";
        DimValue: array[8] of Code[20];
}