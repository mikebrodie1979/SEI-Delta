table 75017 "BA Sub-Segment"
{
    DataClassification = CustomerContent;
    Caption = 'Sub-Segment';

    fields
    {
        field(1; Code; Code[20])
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
        key(K1; Code)
        {
            Clustered = true;
        }
    }
}