pageextension 80009 "BA Item Card" extends "Item Card"
{
    layout
    {
        addafter("Qty. on Sales Order")
        {
            field("BA Qty. on Sales Quote"; Rec."BA Qty. on Sales Quote")
            {
                ApplicationArea = all;
            }
            field("BA Qty. on Closed Sales Quote"; "BA Qty. on Closed Sales Quote")
            {
                ApplicationArea = all;
            }
        }
        addafter("Last Direct Cost")
        {
            field("BA Last USD Purch. Cost"; "BA Last USD Purch. Cost")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the most recent USD purchase unit cost for the item.';
            }
        }
        addlast(Item)
        {
            group("Dimensions")
            {
                Caption = 'Dimensions';
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field("ENC Shortcut Dimension 3 Code"; "ENC Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("ENC Shortcut Dimension 4 Code"; "ENC Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("ENC Shortcut Dimension 5 Code"; "ENC Shortcut Dimension 5 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("ENC Shortcut Dimension 6 Code"; "ENC Shortcut Dimension 6 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("ENC Shortcut Dimension 7 Code"; "ENC Shortcut Dimension 7 Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("ENC Shortcut Dimension 8 Code"; "ENC Shortcut Dimension 8 Code")
                {
                    ApplicationArea = all;
                }
                field("ENC Product ID Code"; "ENC Product ID Code")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        GLSetup: Record "General Ledger Setup";
        DefaultDim: Record "Default Dimension";
    begin
        if Rec."No." = '' then
            exit;

        GLSetup.Get();
        if GLSetup."Shortcut Dimension 3 Code" <> '' then
            if DefaultDim.Get(Database::Item, Rec."No.", GLSetup."Shortcut Dimension 3 Code") then
                Rec."ENC Shortcut Dimension 3 Code" := DefaultDim."Dimension Value Code"
            else
                Rec."ENC Shortcut Dimension 3 Code" := '';

        if GLSetup."Shortcut Dimension 4 Code" <> '' then
            if DefaultDim.Get(Database::Item, Rec."No.", GLSetup."Shortcut Dimension 4 Code") then
                Rec."ENC Shortcut Dimension 4 Code" := DefaultDim."Dimension Value Code"
            else
                Rec."ENC Shortcut Dimension 4 Code" := '';

        if GLSetup."Shortcut Dimension 5 Code" <> '' then
            if DefaultDim.Get(Database::Item, Rec."No.", GLSetup."Shortcut Dimension 5 Code") then
                Rec."ENC Shortcut Dimension 5 Code" := DefaultDim."Dimension Value Code"
            else
                Rec."ENC Shortcut Dimension 5 Code" := '';

        if GLSetup."Shortcut Dimension 6 Code" <> '' then
            if DefaultDim.Get(Database::Item, Rec."No.", GLSetup."Shortcut Dimension 6 Code") then
                Rec."ENC Shortcut Dimension 6 Code" := DefaultDim."Dimension Value Code"
            else
                Rec."ENC Shortcut Dimension 6 Code" := '';

        if GLSetup."Shortcut Dimension 7 Code" <> '' then
            if DefaultDim.Get(Database::Item, Rec."No.", GLSetup."Shortcut Dimension 7 Code") then
                Rec."ENC Shortcut Dimension 7 Code" := DefaultDim."Dimension Value Code"
            else
                Rec."ENC Shortcut Dimension 7 Code" := '';

        if GLSetup."Shortcut Dimension 8 Code" <> '' then
            if DefaultDim.Get(Database::Item, Rec."No.", GLSetup."Shortcut Dimension 8 Code") then
                Rec."ENC Shortcut Dimension 8 Code" := DefaultDim."Dimension Value Code"
            else
                Rec."ENC Shortcut Dimension 8 Code" := '';

        if GLSetup."ENC Product ID Dim. Code" <> '' then
            if DefaultDim.Get(Database::Item, Rec."No.", GLSetup."ENC Product ID Dim. Code") then
                Rec."ENC Product ID Code" := DefaultDim."Dimension Value Code"
            else
                Rec."ENC Product ID Code" := '';
    end;
}