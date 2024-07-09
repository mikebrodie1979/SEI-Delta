table 75018 "BA Block Reason"
{
    DataClassification = CustomerContent;
    Caption = 'Block Reason';

    fields
    {
        field(1; "Code"; Code[20])
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