pageextension 80045 "BA Customer Card" extends "Customer Card"
{
    layout
    {
        addlast(Content)
        {
            group("Account & System Control")
            {
                field(Blocked2; Rec.Blocked)
                {
                    ApplicationArea = all;
                }
                field("Privacy Blocked2"; Rec."Privacy Blocked")
                {
                    ApplicationArea = all;
                }
                field("ENC Country/Region Mandatory"; Rec."ENC Country/Region Mandatory")
                {
                    ApplicationArea = all;
                }
                field("ENC Salesperson Code Mandatory"; Rec."ENC Salesperson Code Mandatory")
                {
                    ApplicationArea = all;
                }
                field("BA Int. Customer"; Rec."BA Int. Customer")
                {
                    ApplicationArea = all;
                }
                field("BA Serv. Int. Customer"; Rec."BA Serv. Int. Customer")
                {
                    ApplicationArea = all;
                }
                field("IC Partner Code2"; Rec."IC Partner Code")
                {
                    ApplicationArea = all;
                }
                field("Service Zone Code2"; Rec."Service Zone Code")
                {
                    ApplicationArea = all;
                }
                field("ENC CRM GUID"; Rec."ENC CRM GUID")
                {
                    ApplicationArea = all;
                }
            }

        }
        modify(Blocked)
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("Privacy Blocked")
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("IC Partner Code")
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("Service Zone Code")
        {
            ApplicationArea = all;
            Visible = false;
        }

        addafter("Post Code")
        {
            field("BA Region"; Rec."BA Region")
            {
                ApplicationArea = all;
            }
        }
        addfirst(AddressDetails)
        {
            field("BA Country/Region Code"; "Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
            }
        }
        addafter(County)
        {
            field("BA County Fullname"; "BA County Fullname")
            {
                ApplicationArea = all;
            }
        }
        modify("Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
            Editable = false;
        }
        modify(County)
        {
            trigger OnAfterValidate()
            begin
                Rec.CalcFields("BA County Fullname");
            end;
        }
        modify("Customer Posting Group")
        {
            trigger OnAfterValidate()
            begin
                UpdateBalanaceDisplay();
            end;
        }
        modify("Balance (LCY)")
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("Balance Due (LCY)")
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("Credit Limit (LCY)")
        {
            ApplicationArea = all;
            Visible = false;
        }
        addafter("Balance (LCY)")
        {
            field(ShowLCYBalances; ShowLCYBalances)
            {
                ApplicationArea = all;
            }
            group("BA Local Balances")
            {
                Visible = ShowLCYBalances;
                ShowCaption = false;
                field("Credit Limit (LCY)2"; "Credit Limit (LCY)")
                {
                    ApplicationArea = all;
                    StyleExpr = StyleTxt;
                }
                field("BA Balance (LCY)"; "Balance (LCY)")
                {
                    ApplicationArea = all;
                }
                field("BA Balance Due (LCY)"; "Balance Due (LCY)")
                {
                    ApplicationArea = all;
                }
            }
            group("BA Non-Local Balances")
            {
                Visible = not ShowLCYBalances;
                ShowCaption = false;
                field("BA Credit Limit"; "BA Credit Limit")
                {
                    ApplicationArea = all;
                    StyleExpr = StyleTxt;
                }
                field("BA Balance"; Balance)
                {
                    ApplicationArea = all;
                }
                field("BA Balance Due"; "Balance Due")
                {
                    ApplicationArea = all;
                }
            }
        }
        modify(CustomerStatisticsFactBox)
        {
            Visible = ShowLCYBalances;
        }
        addafter(CustomerStatisticsFactBox)
        {
            part("BA Non-LCY Customer Statistics Factbox"; "BA Non-LCY Cust. Stat. Factbox")
            {
                SubPageLink = "No." = field ("Bill-to Customer No.");
                Visible = not ShowLCYBalances;
                ApplicationArea = all;
            }
        }
    }

    var
        [InDataSet]
        ShowLCYBalances: Boolean;
        [InDataSet]
        StyleTxt: Text;

    trigger OnAfterGetRecord()
    var
        p1: Page "BA Non-LCY Cust. Stat. Factbox";
    begin
        UpdateBalanaceDisplay();
        StyleTxt := '';
        if ShowLCYBalances then
            StyleTxt := Rec.SetStyle()
        else
            if "BA Credit Limit" < p1.GetTotalAmount() then
                StyleTxt := 'Unfavorable';
    end;

    local procedure UpdateBalanaceDisplay()
    var
        CustPostingGroup: Record "Customer Posting Group";
    begin
        ShowLCYBalances := CustPostingGroup.Get(Rec."Customer Posting Group") and not CustPostingGroup."BA Show Non-Local Currency";
    end;
}