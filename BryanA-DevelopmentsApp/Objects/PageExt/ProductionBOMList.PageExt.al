pageextension 80007 "BA Production BOM List" extends "Production BOM List"
{
    actions
    {
        addfirst(Reporting)
        {
            action("BA Print")
            {
                ApplicationArea = all;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
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