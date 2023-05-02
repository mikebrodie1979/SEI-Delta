tableextension 80054 "BA Transfer Shpt. Line" extends "Transfer Shipment Line"
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