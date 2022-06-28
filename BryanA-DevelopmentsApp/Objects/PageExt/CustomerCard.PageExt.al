pageextension 80045 "BA Customer Card" extends "Customer Card"
{
    layout
    {
        addlast(Content)
        {
            group("Account & System Control")
            {
                field(Blocked2; Blocked)
                {
                    ApplicationArea = all;
                }
                field("Privacy Blocked2"; "Privacy Blocked")
                {
                    ApplicationArea = all;
                }
                field("ENC Country/Region Mandatory"; "ENC Country/Region Mandatory")
                {
                    ApplicationArea = all;
                }
                field("ENC Salesperson Code Mandatory"; "ENC Salesperson Code Mandatory")
                {
                    ApplicationArea = all;
                }
                field("BA Int. Customer"; Rec."BA Int. Customer")
                {
                    ApplicationArea = all;
                }
                field("BA Serv. Int. Customer"; "BA Serv. Int. Customer")
                {
                    ApplicationArea = all;
                }
                field("IC Partner Code2"; "IC Partner Code")
                {
                    ApplicationArea = all;
                }
                field("Service Zone Code2"; "Service Zone Code")
                {
                    ApplicationArea = all;
                }
                field("ENC CRM GUID"; "ENC CRM GUID")
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
    }
}