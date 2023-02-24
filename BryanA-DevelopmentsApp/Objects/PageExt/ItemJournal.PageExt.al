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
            field("BA Adjust. Reason Code"; Rec."BA Adjust. Reason Code")
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
                Caption = 'Cancel Approval Request';

                trigger OnAction()
                begin
                    Subscribers.SendItemJnlApproval(Rec, true);
                end;
            }
            action("BA ReOpen Approval Request")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = ReOpen;
                Caption = 'Reopen Approval Request';

                trigger OnAction()
                var
                    ItemJnlLine: Record "Item Journal Line";
                begin

                    Subscribers.ReopenApprovalRequest(Rec);
                    ItemJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    ItemJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    ItemJnlLine.SetFilter("BA Status", '%1|%2', Rec."BA Status"::Released, Rec."BA Status"::Rejected);
                    if ItemJnlLine.IsEmpty() then
                        Error('Approval request is already open.');
                    ItemJnlLine.SetRange("BA Status");
                    if ItemJnlLine.FindSet() then
                        repeat
                            ItemJnlLine."BA Status" := Rec."BA Status"::" ";
                            ItemJnlLine."BA Locked For Approval" := false;
                            ItemJnlLine."BA Approved By" := '';
                            ItemJnlLine.Modify(true);
                        until ItemJnlLine.Next() = 0;
                    CurrPage.Update(false);
                    Message('Reopened approval request.');
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
            Error(NewLineError1);
        ItemJnlLine.SetRange("BA Locked For Approval");
        ItemJnlLine.SetRange("BA Status", Rec."BA Status"::Released);
        if not ItemJnlLine.IsEmpty() then
            Error(NewLineError2);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec."BA Locked For Approval" then
            Error(ModifiedLineError1, Rec."Line No.");
        if Rec."BA Status" = Rec."BA Status"::Released then
            Error(ModifiedLineError2, Rec."Line No.");
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec."BA Locked For Approval" then
            Error(DeletedLineError1, Rec."Line No.");
        if Rec."BA Status" = Rec."BA Status"::Released then
            Error(DeletedLineError2, Rec."Line No.");
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

        NewLineError1: Label 'Cannot add new lines after submitting journal for approval.';
        NewLineError2: Label 'Cannot add new lines after journal has been approved.';
        ModifiedLineError1: Label 'Line %1 cannot be modified after being sent for approval.';
        ModifiedLineError2: Label 'Line %1 cannot be modified after being approved.';
        DeletedLineError1: Label 'Line %1 cannot be deleted after being sent for approval.';
        DeletedLineError2: Label 'Line %1 cannot be deleted after being approved.';
}