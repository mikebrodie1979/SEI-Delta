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
            field("BA Qty. on Closed Sales Quote"; Rec."BA Qty. on Closed Sales Quote")
            {
                ApplicationArea = all;
            }
        }
        addafter("Last Direct Cost")
        {
            field("BA Last USD Purch. Cost"; Rec."BA Last USD Purch. Cost")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the most recent USD purchase unit cost for the item.';
            }
        }
        addafter("Base Unit of Measure")
        {
            field("ENC Is Fabric"; Rec."ENC Is Fabric")
            {
                ApplicationArea = all;
            }
            field("BA ETL Approved Fabric"; Rec."BA ETL Approved Fabric")
            {
                ApplicationArea = all;
            }
            field("ENC Fabric Brand Name"; Rec."ENC Fabric Brand Name")
            {
                ApplicationArea = all;
            }
        }
        addlast(Item)
        {
            group("Dimensions")
            {
                Caption = 'Dimensions';
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field("ENC Shortcut Dimension 3 Code"; Rec."ENC Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("ENC Shortcut Dimension 4 Code"; Rec."ENC Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("ENC Shortcut Dimension 5 Code"; Rec."ENC Shortcut Dimension 5 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("ENC Shortcut Dimension 6 Code"; Rec."ENC Shortcut Dimension 6 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("ENC Shortcut Dimension 7 Code"; Rec."ENC Shortcut Dimension 7 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("ENC Shortcut Dimension 8 Code"; Rec."ENC Shortcut Dimension 8 Code")
                {
                    ApplicationArea = all;
                }
                field("ENC Product ID Code"; Rec."ENC Product ID Code")
                {
                    ApplicationArea = all;
                }
            }
            field("BA Product Profile Code"; Rec."BA Product Profile Code")
            {
                ApplicationArea = all;

                trigger OnValidate()
                var
                    ProductProfile: Record "BA Product Profile";
                    RecRef: RecordRef;
                begin
                    if (Rec."BA Product Profile Code" = xRec."BA Product Profile Code") or (Rec."BA Product Profile Code" = '') then
                        exit;
                    ProductProfile.Get(Rec."BA Product Profile Code");
                    RecRef.GetTable(Rec);
                    SetValueFromProductProfile(RecRef, Rec.FieldNo("Gen. Prod. Posting Group"), ProductProfile."Gen. Prod. Posting Group");
                    SetValueFromProductProfile(RecRef, Rec.FieldNo("ENC Manufacturing Dept."), ProductProfile."Manufacturing Dept.");
                    SetValueFromProductProfile(RecRef, Rec.FieldNo("Item Tracking Code"), ProductProfile."Item Tracking Code");
                    SetValueFromProductProfile(RecRef, Rec.FieldNo("Item Category Code"), ProductProfile."Item Category Code");
                    SetValueFromProductProfile(RecRef, Rec.FieldNo("ENC Core Product Code"), ProductProfile."Core Product Code");
                    SetValueFromProductProfile(RecRef, Rec.FieldNo("ENC Core Prod. Sub. Cat. Code"), ProductProfile."Core Prod. Sub. Cat. Code");
                    RecRef.SetTable(Rec);
                    CurrPage.Update(true);
                    Rec.Get(Rec.RecordId());
                    RecRef.GetTable(Rec);
                    SetValueFromProductProfile(RecRef, Rec.FieldNo("Global Dimension 1 Code"), ProductProfile."Shortcut Dimension 1 Code");
                    SetValueFromProductProfile(RecRef, Rec.FieldNo("Global Dimension 2 Code"), ProductProfile."Shortcut Dimension 2 Code");
                    SetValueFromProductProfile(RecRef, Rec.FieldNo("ENC Shortcut Dimension 3 Code"), ProductProfile."Shortcut Dimension 3 Code");
                    SetValueFromProductProfile(RecRef, Rec.FieldNo("ENC Shortcut Dimension 4 Code"), ProductProfile."Shortcut Dimension 4 Code");
                    SetValueFromProductProfile(RecRef, Rec.FieldNo("ENC Shortcut Dimension 5 Code"), ProductProfile."Shortcut Dimension 5 Code");
                    SetValueFromProductProfile(RecRef, Rec.FieldNo("ENC Shortcut Dimension 6 Code"), ProductProfile."Shortcut Dimension 6 Code");
                    SetValueFromProductProfile(RecRef, Rec.FieldNo("ENC Shortcut Dimension 7 Code"), ProductProfile."Shortcut Dimension 7 Code");
                    SetValueFromProductProfile(RecRef, Rec.FieldNo("ENC Shortcut Dimension 8 Code"), ProductProfile."Shortcut Dimension 8 Code");
                    SetValueFromProductProfile(RecRef, Rec.FieldNo("ENC Product ID Code"), ProductProfile."Product ID Code");
                    RecRef.SetTable(Rec);
                    Rec.Modify(true);
                    CurrPage.Update(false);
                    Rec.Get(Rec.RecordId());
                end;
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
            field("BA Default Cross-Ref. No."; Rec."BA Default Cross-Ref. No.")
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
            field("BA Default Vendor No."; Rec."BA Default Vendor No.")
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

    local procedure SetValueFromProductProfile(var RecRef: RecordRef; FldNo: Integer; FldValue: Variant)
    begin
        if Format(FldValue) <> '' then
            RecRef.Field(FldNo).Validate(FldValue);
    end;
}