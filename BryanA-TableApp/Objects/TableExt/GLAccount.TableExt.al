tableextension 80051 "BA G/L Account" extends "G/L Account"
{
    fields
    {
        field(80005; "BA Require Description Change"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Transfer Charge';
        }
    }
}