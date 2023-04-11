tableextension 80007 "BA Purchase Header" extends "Purchase Header"
{
    fields
    {
        modify("Location Filter")
        {
            TableRelation = Location.Code where ("BA Inactive" = const (false));
        }
        field(80000; "BA Requisition Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Requisition Order';
            Editable = false;
            Description = 'System field to specify Requisition Orders';
        }
        field(80001; "BA Fully Rec'd. Req. Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Fully Received Requisition Order';
            Editable = false;
            Description = 'System field to specify when a Requisition Order is to be considered fully recieved/posted';
        }
        field(80005; "BA Omit Orders"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Omit from Outstanding Orders';
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

        modify("Buy-from County")
        {
            TableRelation = "BA Province/State".Symbol where ("Country/Region Code" = field ("Buy-from Country/Region Code"));
        }
        modify("Pay-to County")
        {
            TableRelation = "BA Province/State".Symbol where ("Country/Region Code" = field ("Pay-to Country/Region Code"));
        }
        modify("Ship-to County")
        {
            TableRelation = "BA Province/State".Symbol where ("Country/Region Code" = field ("Ship-to Country/Region Code"));
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