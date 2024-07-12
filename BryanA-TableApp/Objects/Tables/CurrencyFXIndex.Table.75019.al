table 75019 "BA Currency FX Index"
{
    DataClassification = CustomerContent;
    Caption = 'Currency FX Index';

    fields
    {
        field(1; "Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Currency Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Currency.Code;
            NotBlank = true;
        }
        field(3; "Exchange Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            MinValue = 0;
        }
    }

    keys
    {
        key(k1; Date, "Currency Code")
        {
            Clustered = true;
        }
    }
}