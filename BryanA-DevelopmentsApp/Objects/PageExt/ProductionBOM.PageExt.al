pageextension 80006 "BA Production BOM" extends "Production BOM"
{
    layout
    {
        modify(ActiveVersionCode)
        {
            ApplicationArea = all;
            Visible = false;
        }
        addafter(ActiveVersionCode)
        {
            field("BA Active Version"; Rec."BA Active Version")
            {
                ApplicationArea = all;

                trigger OnLookup(var Text: Text): Boolean
                var
                    ProdBOMVersion: Record "Production BOM Version";
                begin
                    Rec.CalcFields("BA Active Version");
                    ProdBOMVersion.SetRange("Production BOM No.", Rec."No.");
                    ProdBOMVersion.SetRange("Version Code", Rec."BA Active Version");
                    Page.RunModal(Page::"Production BOM Version", ProdBOMVersion);
                    CalcFields("BA Active Version");
                end;
            }
        }
        addafter("Last Date Modified")
        {
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = all;
            }
            field("BA Created By"; Rec."BA Created By")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addfirst("&Prod. BOM")
        {
            action("BA Print")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                Caption = 'Print';

                trigger OnAction()
                var
                    ProdBOM: Record "Production BOM Header";
                    ProdBOMReport: Report "BA Production BOM";
                begin
                    ProdBOM.SetRange("No.", Rec."No.");
                    ProdBOMReport.SetTableView(ProdBOM);
                    ProdBOMReport.Run();
                end;
            }
        }
    }
}