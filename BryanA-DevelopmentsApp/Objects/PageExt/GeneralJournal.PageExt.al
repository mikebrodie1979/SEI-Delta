pageextension 80150 "BA General Journal" extends "General Journal"
{
    layout
    {
        addlast(Control1)
        {
            field("BA Product ID Code"; Rec."BA Product ID Code")
            {
                ApplicationArea = all;
            }
            field("BA Project Code"; Rec."BA Project Code")
            {
                ApplicationArea = all;
            }
        }
        modify("Account No.")
        {
            trigger OnAfterValidate()
            begin
                if Rec."Account No." = '' then begin
                    Rec."BA Product ID Code" := '';
                    Rec."BA Project Code" := '';
                end;
            end;
        }
    }

    actions
    {
        modify(Dimensions)
        {
            trigger OnAfterAction()
            begin
                GetDimensionCodes();
                EditableDims := Rec."Account No." <> '';
            end;
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetDimensionCodes();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."BA Product ID Code" := '';
        Rec."BA Project Code" := '';
    end;

    local procedure GetDimensionCodes()
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        if Rec."Account No." = '' then begin
            Rec."BA Product ID Code" := '';
            Rec."BA Project Code" := '';
            exit;
        end;
        DimMgt.GetDimensionSet(TempDimSetEntry, Rec."Dimension Set ID");
        Rec."BA Product ID Code" := GetDimensionCode(TempDimSetEntry, 'PRODUCT ID');
        Rec."BA Project Code" := GetDimensionCode(TempDimSetEntry, 'PROJECT');
    end;


    local procedure GetDimensionCode(var TempDimSetEntry: Record "Dimension Set Entry"; DimCode: Code[20]): Code[20]
    begin
        TempDimSetEntry.SetRange("Dimension Code", DimCode);
        if TempDimSetEntry.FindFirst() then
            exit(TempDimSetEntry."Dimension Value Code");
        exit('');
    end;

    var
        DimMgt: Codeunit DimensionManagement;

        [InDataSet]
        EditableDims: Boolean;
}