pageextension 80001 "BA Purch. Inv. Subpage" extends "Purch. Invoice Subform"
{
    layout
    {
        addafter(ShortcutDimCode4)
        {
            // field("Sales Person Code"; SalesPersonCode)
            // {
            //     ApplicationArea = all;

            //     trigger OnLookup(var Text: Text): Boolean
            //     var
            //         SEIFunctions: Codeunit "ENC SEI Functions";
            //         NewCode: Code[20];
            //     begin
            //         if not SEIFunctions.SalespersonDimCodeLookup(NewCode) then
            //             exit;
            //         SalesPersonCode := NewCode;
            //         ValidateShortcutDimCode(5, SalesPersonCode);
            //     end;
            // }

        }


    }

    trigger OnAfterGetRecord()
    var
        TempDimSet: Record "Dimension Set Entry" temporary;
    begin
        SalesPersonCode := '';
        DimMgt.GetDimensionSet(TempDimSet, Rec."Dimension Set ID");
        TempDimSet.SetRange("Dimension Code", GLSetup."ENC Salesperson Dim. Code");
        if TempDimSet.FindFirst then
            SalesPersonCode := TempDimSet."Dimension Value Code";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SalesPersonCode := '';
    end;

    trigger OnOpenPage()
    begin
        GLSetup.Get;
        GLSetup.TestField("ENC Salesperson Dim. Code");
    end;

    var
        GLSetup: Record "General Ledger Setup";
        DimMgt: Codeunit DimensionManagement;
        SalesPersonCode: Code[20];
}