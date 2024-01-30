table 75015 "BA Warehouse Department"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; code[20])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}