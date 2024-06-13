table 75016 "BA Segment"
{
    DataClassification = CustomerContent;
    Caption = 'Segment';

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