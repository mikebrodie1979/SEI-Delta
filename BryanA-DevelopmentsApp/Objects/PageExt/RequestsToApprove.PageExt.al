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
                begin
                    if Customer.Get(Rec."BA Customer No.") then
                        Customer.OpenCustomerLedgerEntries(false);
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