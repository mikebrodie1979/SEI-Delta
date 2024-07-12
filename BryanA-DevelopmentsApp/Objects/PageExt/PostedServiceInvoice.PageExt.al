pageextension 80055 "BA Posted Service Invoice" extends "Posted Service Invoice"
{
    layout
    {
        modify("Bill-to Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
        }
        addbefore("Bill-to Name")
        {
            field("BA Bill-to Country/Region Code"; "Bill-to Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
                Editable = false;
            }
        }
        modify("Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
        }
        addfirst("Sell-to")
        {
            field("BA Country/Region Code"; "Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
                Editable = false;
            }
        }
        modify("Ship-to Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
        }
        addbefore("Ship-to Name")
        {
            field("BA Ship-to Country/Region Code"; "Ship-to Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
                Editable = false;
            }
        }
        addlast(General)
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addBefore(ServInvLines)
        {
            part(ServLines; "BA Service Item Lines")
            {
                ApplicationArea = all;
                Caption = 'Service Item Lines';
                SubPageLink = "No." = field ("BA Shipment No.");
            }
        }
        addbefore("Order No.")
        {
            field("ENC S. Quote No."; Rec."ENC S. Quote No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Posting Date")
        {
            field("BA Actual Posting DateTime"; "BA Actual Posting DateTime")
            {
                ApplicationArea = all;
            }
        }
        addafter("Document Date")
        {
            field("BA Quote Date"; Rec."BA Quote Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("BA Order Date"; Rec."Order Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Tax Area Code")
        {
            field("BA Tax Registration No."; Rec."ENC Tax Registration No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("BA FID No."; Rec."ENC FID No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("BA EORI No."; Rec."BA EORI No.")
            {
                ApplicationArea = all;
            }
        }
        addlast("Ship-to")
        {
            field("BA Ship-To Tax Reg. No."; Rec."ENC Ship-To Tax Reg. No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("BA Ship-To FID No."; Rec."ENC Ship-To FID No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("BA Ship-to EORI No."; Rec."BA Ship-to EORI No.")
            {
                ApplicationArea = all;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CalcFields("BA Shipment No.");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        SalesRecSetup: Record "Sales & Receivables Setup";
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId()) or not UserSetup."BA Force Reason Code Entry" then
            exit;
        if Rec."ENC Physical Ship Date" <= Rec."BA Promised Delivery Date" then
            exit(true);
        SalesRecSetup.Get();
        if SalesRecSetup."BA Default Reason Code" = '' then
            exit(true);
        if Rec."Reason Code" in ['', SalesRecSetup."BA Default Reason Code"] then
            Error(ReasonCodeErr, Rec.FieldCaption("Reason Code"));
    end;


    var
        ReasonCodeErr: Label '%1 must be a different value.';
}