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
    }
}