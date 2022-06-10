table 50009 "BA Province/State"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Country/Region Code"; Code[10])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = "Country/Region".Code;
        }
        field(2; "Symbol"; Code[2])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(3; "Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Country/Region Name"; Text[50])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup ("Country/Region".Name where (Code = field ("Country/Region Code")));
        }
    }

    keys
    {
        key(K1; "Country/Region Code", Symbol)
        {
            Clustered = true;
        }
    }
}