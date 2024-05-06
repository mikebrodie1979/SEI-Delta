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
            field("BA Sell-to Country/Region Code"; "Sell-to Country/Region Code")
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
            field("BA Bill-to Country/Region Code"; "Bill-to Country/Region Code")
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
        addafter("Sell-to County")
        {
            field("BA Sell-to County Fullname"; "BA Sell-to County Fullname")
            {
                ApplicationArea = all;
            }
        }
        addafter("Ship-to County")
        {
            field("BA Ship-to County Fullname"; "BA Ship-to County Fullname")
            {
                ApplicationArea = all;
            }
        }
        addafter("Bill-to County")
        {
            field("BA Bill-to County Fullname"; "BA Bill-to County Fullname")
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
            field("ENC Assigned User ID"; "ENC Assigned User ID")
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
            field("BA Actual Posting DateTime"; "BA Actual Posting DateTime")
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