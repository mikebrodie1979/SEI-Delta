tableextension 80030 "BA Customer" extends Customer
{
    fields
    {
        field(80000; "BA Int. Customer"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Sales BBD Fields Mandatory';
        }
        field(80001; "BA Serv. Int. Customer"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Service BBD Fields Mandatory';
        }
        field(80010; "BA Region"; Text[30])
        {
            Caption = 'Region';
            FieldClass = FlowField;
            CalcFormula = lookup ("Country/Region"."BA Region" where (Code = field ("Country/Region Code")));
            Editable = false;
        }
        field(80011; "BA County Fullname"; Text[30])
        {
            Caption = 'Province/State Fullname';
            FieldClass = FlowField;
            CalcFormula = lookup ("BA Province/State".Name where ("Print Full Name" = const (true), "Country/Region Code" = field ("Country/Region Code"), Symbol = field (County)));
            Editable = false;
        }
        modify(County)
        {
            TableRelation = "BA Province/State".Symbol where ("Country/Region Code" = field ("Country/Region Code"));
        }
        modify("Country/Region Code")
        {
            trigger OnAfterValidate()
            begin
                if "Country/Region Code" = '' then
                    "BA Region" := ''
                else
                    Rec.CalcFields("BA Region");
            end;
        }
    }
}