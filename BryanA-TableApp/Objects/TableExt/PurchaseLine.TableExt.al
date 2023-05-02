tableextension 80000 "BA Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(80000; "BA Salesperson Filter Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Salesperson Filter Code';
            Editable = false;
        }
        field(80001; "BA Requisition Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Requisition Order';
            Editable = false;
            Description = 'System field to specify Requisition Orders';
        }
        field(80050; "BA SEI Order Type."; Enum "BA SEI Order Type")
        {
            DataClassification = CustomerContent;
            Caption = 'SEI Order Type';
        }
        field(80051; "BA SEI Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'SEI Order No.';
        }
        field(80052; "BA Freight Charge Type"; Enum "BA Freight Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Freight Charge Type';
        }
        field(80100; "BA Product ID Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Product ID Code';
            TableRelation = "Dimension Value".Code where ("Dimension Code" = const ('PRODUCT ID'), Blocked = const (false), "ENC Inactive" = const (false));

            trigger OnValidate()
            begin
                SetNewDimValue('PRODUCT ID', "BA Product ID Code");
            end;
        }
        field(80101; "BA Project Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Project Code';
            TableRelation = "Dimension Value".Code where ("Dimension Code" = const ('PROJECT'), Blocked = const (false), "ENC Inactive" = const (false));

            trigger OnValidate()
            begin
                SetNewDimValue('PROJECT', "BA Project Code");
            end;
        }
    }

    local procedure SetNewDimValue(DimCode: Code[20]; DimValue: Code[20])
    var
        DimValueRec: Record "Dimension Value";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        DimMgt.GetDimensionSet(TempDimSetEntry, Rec."Dimension Set ID");
        TempDimSetEntry.SetRange("Dimension Code", DimCode);
        if DimValue = '' then begin
            if TempDimSetEntry.FindFirst() then
                TempDimSetEntry.Delete(false);
        end else begin
            DimValueRec.Get(DimCode, DimValue);
            if TempDimSetEntry.FindFirst() then begin
                TempDimSetEntry."Dimension Value Code" := DimValue;
                TempDimSetEntry."Dimension Value ID" := DimValueRec."Dimension Value ID";
                TempDimSetEntry.Modify(false);
            end else begin
                TempDimSetEntry.Init();
                TempDimSetEntry."Dimension Code" := DimCode;
                TempDimSetEntry."Dimension Value Code" := DimValue;
                TempDimSetEntry."Dimension Value ID" := DimValueRec."Dimension Value ID";
                TempDimSetEntry.Insert(false);
            end;
        end;
        Rec."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
    end;

    var
        DimMgt: Codeunit DimensionManagement;
}