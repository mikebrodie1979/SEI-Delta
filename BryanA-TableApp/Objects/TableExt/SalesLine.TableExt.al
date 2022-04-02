tableextension 80002 "BA Sales Line" extends "Sales Line"
{
    fields
    {
        field(80000; "BA Org. Qty. To Ship"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Original Qty. to Ship';
            Editable = false;
        }
        field(80001; "BA Org. Qty. To Invoice"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Original Qty. to Invoice';
            Editable = false;
        }
    }
}