pageextension 80050 "BA Service Order" extends "Service Order"
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
            }
        }
        addlast(General)
        {
            field("BA Quote Exch. Rate"; "BA Quote Exch. Rate")
            {
                ApplicationArea = all;
            }
        }
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
        modify("Posting Date")
        {
            trigger OnAfterValidate()
            begin
                Rec."BA Modified Posting Date" := true;
                Rec.Modify(true);
            end;
        }
    }



    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        ExchangeRate: Record "Currency Exchange Rate";
        ServiceMgtSetup: Record "Service Mgt. Setup";
        Subscribers: Codeunit "BA SEI Subscibers";
    begin
        ServiceMgtSetup.Get();
        if not ServiceMgtSetup."BA Use Single Currency Pricing" then
            exit;
        ServiceMgtSetup.TestField("BA Single Price Currency");
        if Subscribers.GetExchangeRate(ExchangeRate, ServiceMgtSetup."BA Single Price Currency") then
            Rec."BA Quote Exch. Rate" := ExchangeRate."Relational Exch. Rate Amount";
    end;

    trigger OnAfterGetRecord()
    var
        ResetStatus: Boolean;
        SalesLine: Record "Sales Line";
    begin
        if Rec."BA Modified Posting Date" or (Rec."Posting Date" = WorkDate()) or not CurrPage.Editable() or (Rec.Status <> Rec.Status::"In Process") then
            exit;
        Rec.SetHideValidationDialog(true);
        Rec."BA Skip Sales Line Recreate" := true;
        Rec.Validate("Posting Date", WorkDate());
        Rec.SetHideValidationDialog(false);
        Rec."BA Skip Sales Line Recreate" := false;
        Rec.Modify(true);
    end;
}