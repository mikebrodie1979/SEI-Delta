pageextension 80083 "BA Customer List" extends "Customer List"
{
    layout
    {
        addafter("Credit Limit (LCY)")
        {
            field("BA Credit Limit"; Rec."BA Credit Limit")
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field("BA Last Sales Activity"; Rec."BA Last Sales Activity")
            {
                ApplicationArea = all;
            }
            field("BA SEI Service Center"; Rec."BA SEI Service Center")
            {
                ApplicationArea = all;
            }
            field("BA SEI Int'l Cust. No."; Rec."BA SEI Int'l Cust. No.")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {

        addlast(Processing)
        {
            action("BA Import Customers")
            {
                ApplicationArea = all;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Caption = 'Import Customers';

                trigger OnAction()
                var
                    Subsribers: Codeunit "BA SEI Subscibers";
                begin
                    Subsribers.ImportCustomerList();
                end;
            }
        }
    }
}