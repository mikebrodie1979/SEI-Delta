pageextension 80052 "BA Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        modify("Sell-to Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
        }
        addfirst("Sell-to")
        {
            field("BA Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
                Editable = false;
            }
        }
        modify("Bill-to Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
        }
        addbefore("Bill-to Name")
        {
            field("BA Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
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
            field("BA Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
                Editable = false;
            }
        }
        addafter("Sell-to County")
        {
            field("BA Sell-to County Fullname"; "BA Sell-to County Fullname")
            {
                ApplicationArea = all;
            }
        }
        addafter("Ship-to County")
        {
            field("BA Ship-to County Fullname"; Rec."BA Ship-to County Fullname")
            {
                ApplicationArea = all;
            }
        }
        addafter("Bill-to County")
        {
            field("BA Bill-to County Fullname"; Rec."BA Bill-to County Fullname")
            {
                ApplicationArea = all;
            }
        }
        addafter("Order No.")
        {
            field("BA Sales Source"; SalesSource)
            {
                ApplicationArea = all;
                Caption = 'Source';
                Editable = Editable;
                TableRelation = "BA Sales Source".Name;

                trigger OnValidate()
                begin
                    Rec."BA Sales Source" := SalesSource;
                end;
            }
            field("BA Web Lead Date"; WebLeadDate)
            {
                ApplicationArea = all;
                Caption = 'Web Lead Date';
                Editable = Editable;

                trigger OnValidate()
                begin
                    Rec."BA Web Lead Date" := WebLeadDate;
                end;
            }
        }
        addafter("External Document No.")
        {
            field("ENC Assigned User ID"; Rec."ENC Assigned User ID")
            {
                ApplicationArea = all;
                Caption = 'Assigned User ID';
            }
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Posting Date")
        {
            field("BA Actual Posting DateTime"; Rec."BA Actual Posting DateTime")
            {
                ApplicationArea = all;
            }
        }
        addbefore("Work Description")
        {
            field("BA SEI Int'l Ref. No."; Rec."BA SEI Int'l Ref. No.")
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
            field("Order Date"; Rec."Order Date")
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
        SalesSource := Rec."BA Sales Source";
        WebLeadDate := Rec."BA Web Lead Date";
        Editable := CurrPage.Editable();
    end;

    var
        SalesSource: Text[30];
        WebLeadDate: Date;
        [InDataSet]
        Editable: Boolean;
}