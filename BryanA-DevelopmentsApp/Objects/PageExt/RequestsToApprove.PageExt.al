pageextension 80155 "BA Requests to Approve" extends "Requests to Approve"
{
    layout
    {
        addlast(Control1)
        {
            field("BA Customer No."; Rec."BA Customer No.")
            {
                ApplicationArea = all;
            }
            field("BA Customer Name"; Rec."BA Customer Name")
            {
                ApplicationArea = all;
            }
            field("BA Last Sales Activity"; Rec."BA Last Sales Activity")
            {
                ApplicationArea = all;
            }
            field("BA Payment Terms Code"; Rec."BA Payment Terms Code")
            {
                ApplicationArea = all;
                Caption = 'Payment Terms Code';
            }
            field("BA Salesperson Code"; "BA Salesperson Code")
            {
                ApplicationArea = all;
            }
            field("BA Credit Limit"; Rec."BA Credit Limit")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter(Record)
        {
            action("BA Customer Entries")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = false;
                Image = CustomerLedger;
                Enabled = "BA Customer No." <> '';
                Caption = 'Customer Ledger Entries';

                trigger OnAction()
                var
                    Customer: Record Customer;
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    if not Customer.Get(Rec."BA Customer No.") then
                        exit;
                    CustLedgEntry.SetRange("Customer No.", Customer."No.");
                    CustLedgEntry.SetRange("Currency Code", Customer."Currency Code");
                    CustLedgEntry.SetRange("Global Dimension 1 Code", Customer."Global Dimension 1 Code");
                    CustLedgEntry.SetRange("Global Dimension 2 Code", Customer."Global Dimension 2 Code");
                    Page.Run(0, CustLedgEntry);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetFilter("Table ID", '<>%1', Database::"Item Journal Batch");
        Rec.FilterGroup(0);
    end;
}