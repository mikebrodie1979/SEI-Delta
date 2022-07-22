table 50000 "BA Region"
{
    fields
    {
        field(1; Name; Text[30])
        {
            NotBlank = true;
        }
    }

    keys
    {
        key(K1; Name)
        {
            Clustered = true;
        }
    }
}