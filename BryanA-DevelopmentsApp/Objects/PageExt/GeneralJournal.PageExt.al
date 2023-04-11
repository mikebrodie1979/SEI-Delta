pageextension 80150 "BA General Journal" extends "General Journal"
{
    layout
    {
        addlast(Control1)
        {
            field("Product ID Code"; DimValues[1])
            {
                ApplicationArea = all;
                TableRelation = "Dimension Value".Code where ("Dimension Code" = const ('PRODUCT ID'), Blocked = const (false));

                trigger OnValidate()
                begin
                    SetNewDimValue('PRODUCT ID', DimValues[1]);
                end;
            }
            field("Project Code"; DimValues[2])
            {
                ApplicationArea = all;
                TableRelation = "Dimension Value".Code where ("Dimension Code" = const ('PROJECT'), Blocked = const (false));

                trigger OnValidate()
                begin
                    SetNewDimValue('PROJECT', DimValues[2]);
                end;
            }
        }
    }

    // trigger OnAfterGetRecord()
    // var
    //     TempDimSetEntry: Record "Dimension Set Entry" temporary;
    // begin
    //     DimMgt.GetDimensionSet(TempDimSetEntry, Rec."Dimension Set ID");
    //     DimValues[1] := GetDimensionCode(TempDimSetEntry, 'PRODUCT ID');
    //     DimValues[2] := GetDimensionCode(TempDimSetEntry, 'PROJECT');
    // end;

    // trigger OnNewRecord(BelowxRec: Boolean)
    // begin
    //     Clear(DimValues);
    // end;

    // local procedure GetDimensionCode(var TempDimSetEntry: Record "Dimension Set Entry"; DimCode: Code[20]): Code[20]
    // begin
    //     TempDimSetEntry.SetRange("Dimension Code", DimCode);
    //     if TempDimSetEntry.FindFirst() then
    //         exit(TempDimSetEntry."Dimension Value Code");
    //     exit('');
    // end;

    local procedure SetNewDimValue(DimCode: Code[20]; DimValue: Code[20])
    var
        DimValueRec: Record "Dimension Value";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        DimMgt.GetDimensionSet(TempDimSetEntry, Rec."Dimension Set ID");
        DimValueRec.Get(DimCode, DimValue);
        TempDimSetEntry.SetRange("Dimension Code", DimCode);
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
        Rec."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
        if not Rec.Insert(true) then
            Rec.Modify(true);
    end;


    var
        DimMgt: Codeunit DimensionManagement;
        DimValues: array[2] of Code[20];
}