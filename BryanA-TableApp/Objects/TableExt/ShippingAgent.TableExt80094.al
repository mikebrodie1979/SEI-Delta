tableextension 80094 "BA Shipping Agent" extends "Shipping Agent"
{
    fields
    {
        field(80000; "BA Block Tracking No."; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Block Tracking No.';
        }
    }
}