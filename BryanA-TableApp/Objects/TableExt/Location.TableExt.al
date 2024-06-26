tableextension 80020 "BA Location" extends Location
{
    fields
    {
        field(80000; "BA FID No."; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'FID No.';
        }
        field(80001; "BA Inactive"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Inactive';
        }
        modify(County)
        {
            TableRelation = "BA Province/State".Symbol where ("Country/Region Code" = field ("Country/Region Code"));
        }
    }
}