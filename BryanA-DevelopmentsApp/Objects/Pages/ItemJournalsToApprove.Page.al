page 50070 "BA Item Jnls. to Approval"
{
    Caption = 'Item Journals to Approval';
    SourceTable = "Approval Entry";
    ApplicationArea = all;
    UsageCategory = Lists;
    PageType = List;

    layout
    {
        area(Content)
        {
            repeater(Line)
            {
                field("Table ID"; "Table ID")
                {
                    ApplicationArea = all;
                }
                field("BA Journal Batch Name"; "BA Journal Batch Name")
                {
                    ApplicationArea = all;
                }
                field("Date-Time Sent for Approval"; "Date-Time Sent for Approval")
                {
                    ApplicationArea = all;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = all;
                }
                field("Approver ID"; "Approver ID")
                {
                    ApplicationArea = all;
                }
                field("Approval Code"; "Approval Code")
                {
                    ApplicationArea = all;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Approve)
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Approve;

                trigger OnAction()
                begin
                    Message('approve');
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Reject;

                trigger OnAction()
                begin
                    Message('reject');
                end;
            }
        }
    }
}