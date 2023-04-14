tableextension 80095 "BA Company Info" extends "Company Information"
{
    fields
    {
        field(80000; "BA Populated Dimensions"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Populated Dimensions';
            Description = 'Used by install codeunit to prevent AddNewDimValues() function from running mulitple times.';
            Editable = false;
        }
    }
}