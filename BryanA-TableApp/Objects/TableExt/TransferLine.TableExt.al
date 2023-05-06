tableextension 80052 "BA Transfer Line" extends "Transfer Line"
{
    fields
    {
        field(80000; "BA Freight Charge Type"; Enum "BA Freight Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Freight Charge Type';
        }
        field(80001; "BA To Freight"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'To Freight';
        }
        field(80053; "BA Transfer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Transfer No.';
            Editable = false;
        }
    }
}