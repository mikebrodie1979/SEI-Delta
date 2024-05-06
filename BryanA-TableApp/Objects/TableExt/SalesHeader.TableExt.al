tableextension 80001 "BA Sales Header" extends "Sales Header"
{
    fields
    {
        modify("Location Filter")
        {
            TableRelation = Location.Code where ("BA Inactive" = const (false));
        }
        field(80000; "BA Copied Doc."; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'System field use to specify if a document was created via CopyDoc codeunit';
            Caption = 'Copied Document';
            Editable = false;
        }
        field(80011; "BA Sell-to County Fullname"; Text[50])
        {
            Caption = 'Province/State Fullname';
            FieldClass = FlowField;
            CalcFormula = lookup ("BA Province/State".Name where ("Print Full Name" = const (true), "Country/Region Code" = field ("Sell-to Country/Region Code"), Symbol = field ("Sell-to County")));
            Editable = false;
        }
        field(80012; "BA Bill-to County Fullname"; Text[50])
        {
            Caption = 'Province/State Fullname';
            FieldClass = FlowField;
            CalcFormula = lookup ("BA Province/State".Name where ("Print Full Name" = const (true), "Country/Region Code" = field ("Bill-to Country/Region Code"), Symbol = field ("Bill-to County")));
            Editable = false;
        }
        field(80013; "BA Ship-to County Fullname"; Text[50])
        {
            Caption = 'Province/State Fullname';
            FieldClass = FlowField;
            CalcFormula = lookup ("BA Province/State".Name where ("Print Full Name" = const (true), "Country/Region Code" = field ("Ship-to Country/Region Code"), Symbol = field ("Ship-to County")));
            Editable = false;
        }
        modify("Sell-to County")
        {
            TableRelation = "BA Province/State".Symbol where ("Country/Region Code" = field ("Sell-to Country/Region Code"));
        }
        modify("Bill-to County")
        {
            TableRelation = "BA Province/State".Symbol where ("Country/Region Code" = field ("Bill-to Country/Region Code"));
        }
        modify("Ship-to County")
        {
            TableRelation = "BA Province/State".Symbol where ("Country/Region Code" = field ("Ship-to Country/Region Code"));
        }
        field(80020; "BA Quote Exch. Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Exchange Rate';
            Editable = false;
        }
        field(80025; "BA Sales Source"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Source';
            TableRelation = "BA Sales Source".Name;
        }
        field(80026; "BA Web Lead Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Web Lead Date';
        }
        field(80060; "BA SEI Int'l Ref. No."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'SEI Int''l Ref. No.';
        }
        field(80040; "BA Modified Posting Date"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Modified Posting Date';
            Editable = false;
        }
        field(80041; "BA Skip Sales Line Recreate"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Skip Sales Line Recreate';
            Editable = false;
            Description = 'System field. Used for the OnBeforeRecreateSalesLinesHandler subscriber.';
        }
    }
}