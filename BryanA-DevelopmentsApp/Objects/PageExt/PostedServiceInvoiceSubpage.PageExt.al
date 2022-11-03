pageextension 80147 "BA Posted Service Inv. Subpage" extends "Posted Service Invoice Subform"
{
    layout
    {
        addfirst(Control1)
        {
            field("BA Omit from Reports"; Rec."BA Omit from Reports")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addfirst(Processing)
        {
            action("Omit Selected Lines")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = MakeOrder;

                trigger OnAction()
                var
                    ServiceInvLine: Record "Service Invoice Line";
                    UpdatedPostedLines: Report "BA Updated Posted Lines";
                begin
                    CurrPage.SetSelectionFilter(ServiceInvLine);
                    UpdatedPostedLines.ServiceInvoiceLines(ServiceInvLine);
                end;
            }
        }
    }
}