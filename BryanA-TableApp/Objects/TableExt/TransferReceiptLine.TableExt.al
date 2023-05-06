tableextension 80053 "BA Transfer Receipt Line" extends "Transfer Receipt Line"
{
    fields
    {
        field(80000; "BA Freight Charge Type"; Enum "BA Freight Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Freight Charge Type';
            Editable = false;
        }
        field(80001; "BA To Freight"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'To Freight';
            Editable = false;
        }
    }
}