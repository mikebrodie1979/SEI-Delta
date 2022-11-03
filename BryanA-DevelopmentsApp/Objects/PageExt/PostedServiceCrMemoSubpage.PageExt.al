pageextension 80148 "BA P. Service Cr.Memo Subpage" extends "Posted Serv. Cr. Memo Subform"
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
                    ServiceCrMemoLine: Record "Service Cr.Memo Line";
                    UpdatedPostedLines: Report "BA Updated Posted Lines";
                begin
                    CurrPage.SetSelectionFilter(ServiceCrMemoLine);
                    UpdatedPostedLines.ServiceCrMemoLines(ServiceCrMemoLine);
                end;
            }
        }
    }
}