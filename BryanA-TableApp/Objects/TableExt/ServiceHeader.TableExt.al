tableextension 80026 "BA Service Header" extends "Service Header"
{
    fields
    {
        modify("Location Filter")
        {
            TableRelation = Location.Code where ("BA Inactive" = const (false));
        }
        modify(County)
        {
            TableRelation = "BA Province/State".Symbol where ("Country/Region Code" = field ("Country/Region Code"));
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
        field(80030; "BA Amount"; Decimal)
        {
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum ("Service Line".Amount where ("Document Type" = field ("Document Type"), "Document No." = field ("No.")));
        }
        field(80031; "BA Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum ("Service Line"."Amount Including VAT" where ("Document Type" = field ("Document Type"), "Document No." = field ("No.")));
        }
    }
}