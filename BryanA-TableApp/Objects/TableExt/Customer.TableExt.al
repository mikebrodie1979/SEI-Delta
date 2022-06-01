tableextension 80030 "BA Customer" extends Customer
{
    fields
    {
        field(80000; "BA Int. Customer"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Sales International Customer';
        }
        field(80001; "BA Serv. Int. Customer"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Service International Customer';
        }
    }
}