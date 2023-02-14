pageextension 80151 "BA Item Journal" extends "Item Journal"
{
    layout
    {
        modify("Location Code")
        {
            trigger OnLookup(var Text: Text): Boolean
            var
                Subscribers: Codeunit "BA SEI Subscibers";
            begin
                Text := Subscribers.LocationListLookup();
                exit(Text <> '');
            end;
        }
        addfirst(Control1)
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = all;
            }
        }
        addafter(Amount)
        {
            field("BA Status"; Rec."BA Status")
            {
                ApplicationArea = all;
            }
            field("BA Adjust. Reason"; Rec."BA Adjust. Reason")
            {
                ApplicationArea = all;
                ShowMandatory = true;
            }
            field("BA Approved By"; Rec."BA Approved By")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action("BA Request Approval")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = SendApprovalRequest;
                Enabled = Approve;
                Caption = 'Request Approval';

                trigger OnAction()
                begin
                    Subscribers.SendItemJnlApproval(Rec, false);
                end;
            }
            action("BA Cancel Approval Request")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = SendApprovalRequest;
                Enabled = Cancel;
                Caption = 'Cancel Approval Request';

                trigger OnAction()
                begin
                    Subscribers.SendItemJnlApproval(Rec, true);
                end;
            }
            action("BA Clear Entries")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = ClearLog;
                Caption = 'Clear Entries';
                Visible = IsDebugUser;
                Enabled = IsDebugUser;

                trigger OnAction()
                var
                    TempGUID: Guid;
                begin
                    Subscribers.ClearApprovalEntries();
                    Rec.Reset();
                    Rec.SetRange("Journal Template Name", Rec."Journal Template Name");
                    Rec.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    if not Rec.FindSet() then
                        exit;
                    repeat
                        Rec."BA Locked For Approval" := false;
                        Rec."BA Status" := Rec."BA Status"::" ";
                        Rec."BA Approval GUID" := TempGUID;
                        Rec.Modify(false);
                    until Rec.Next() = 0;
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        ItemJnlLine: Record "Item Journal Line";
    begin
        ItemJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        ItemJnlLine.SetRange("BA Locked For Approval", true);
        if not ItemJnlLine.IsEmpty() then
            Error('Cannot add new lines after submitting journal for approval.');
        ItemJnlLine.SetRange("BA Locked For Approval");
        ItemJnlLine.SetRange("BA Status", Rec."BA Status"::Released);
        if not ItemJnlLine.IsEmpty() then
            Error('Cannot add new lines after journal has been approved.');
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec."BA Locked For Approval" then
            Error('Line %1 cannot be modified after being sent for approval.', Rec."Line No.");
        if Rec."BA Status" = Rec."BA Status"::Released then
            Error('Line %1 cannot be modified after being approved.', Rec."Line No.");
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec."BA Locked For Approval" then
            Error('Line %1 cannot be deleted after being sent for approval.', Rec."Line No.");
        if Rec."BA Status" = Rec."BA Status"::Released then
            Error('Line %1 cannot be deleted after being approved.', Rec."Line No.");
    end;

    local procedure CheckForApprovalEntries(Cancel: Boolean): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        if not ItemJnlBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name") then
            exit(false);
        ApprovalEntry.SetCurrentKey("Table ID", "Record ID to Approve", "Status", "Workflow Step Instance ID", "Sequence No.");
        ApprovalEntry.SetRange("Table ID", Database::"Item Journal Batch");
        ApprovalEntry.SetRange("Record ID to Approve", ItemJnlBatch.RecordId());
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SetRange("Workflow Step Instance ID", Rec."BA Approval GUID");
        if Cancel then
            ApprovalEntry.SetRange("Sender ID", UserId());
        exit(ApprovalEntry.IsEmpty());
    end;




    trigger OnAfterGetCurrRecord()
    begin
        Cancel := not CheckForApprovalEntries(true) and (Rec."BA Status" <> Rec."BA Status"::Rejected);
        Approve := CheckForApprovalEntries(false) and (Rec."BA Status" <> Rec."BA Status"::Released) and (Rec."Item No." <> '');
    end;

    trigger OnOpenPage()
    begin
        IsDebugUser := UserId = 'ENCORE';
    end;

    var
        Subscribers: Codeunit "BA SEI Subscibers";
        [InDataSet]
        Cancel: Boolean;
        [InDataSet]
        Approve: Boolean;
        [InDataSet]
        IsDebugUser: Boolean;
}