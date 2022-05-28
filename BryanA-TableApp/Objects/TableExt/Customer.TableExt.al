tableextension 80030 "BA Customer" extends Customer
{
    fields
    {
        field(80000; "BA Int. Customer"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'International Customer';
        }
    }
}