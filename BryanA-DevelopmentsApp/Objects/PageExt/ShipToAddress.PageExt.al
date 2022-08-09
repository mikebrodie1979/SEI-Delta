pageextension 80049 "BA Ship-to Address" extends "Ship-to Address"
{
    layout
    {
        modify(GLN)
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("Fax No.")
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("Home Page")
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("Service Zone Code")
        {
            ApplicationArea = all;
            Visible = false;
        }
        modify("Country/Region Code")
        {
            ApplicationArea = all;
            Caption = 'Country';
        }
        modify("Shipping Agent Service Code")
        {
            ApplicationArea = all;
            Visible = false;
            Editable = false;
            Enabled = false;
        }
        addafter("Shipping Agent Service Code")
        {
            field("BA Freight Term"; ServiceCode)
            {
                ApplicationArea = all;
                Caption = 'Freight Term';
                TableRelation = "ENC Freight Term".Code;

                trigger OnValidate()
                begin
                    Rec."Shipping Agent Service Code" := ServiceCode;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ServiceCode := Rec."Shipping Agent Service Code";
    end;

    var
        ServiceCode: Code[10];
}