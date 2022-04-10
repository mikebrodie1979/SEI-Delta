pageextension 80005 "BA Sales Quote" extends "Sales Quote"
{
    actions
    {
        addlast(Navigation)
        {
            action("BA Assemble-to-Order Lines")
            {
                Image = AssemblyBOM;
                Caption = 'Assemble-to-Order Lines';
                ApplicationArea = all;

                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";
                begin
                    CurrPage.SalesLines.Page.GetRecord(SalesLine);
                    SalesLine.ShowAsmToOrderLines();
                end;
            }
        }
    }

}