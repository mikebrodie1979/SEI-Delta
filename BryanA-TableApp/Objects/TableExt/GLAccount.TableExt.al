tableextension 80051 "BA G/L Account" extends "G/L Account"
{
    fields
    {
        field(80000; "BA Freight Charge"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Freight Charge';
        }
        field(80001; "BA Transfer Charge"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Transfer Charge';
        }
        field(80005; "BA Require Description Change"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Require Description Change';
        }
    }
}