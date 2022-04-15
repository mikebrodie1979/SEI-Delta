tableextension 80004 "BA Item" extends Item
{
    Fields
    {
        Field(80000; "BA Qty. on Sales Quote"; Decimal)
        {
            Caption = 'Qty. on Sales Quote';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum ("Sales Line"."Outstanding Qty. (Base)"
            where ("Document Type" = Const (Quote), Type = Const (Item), "No." = Field ("No."),
                "Shortcut Dimension 1 Code" = Field ("Global Dimension 1 Filter"), "Shortcut Dimension 2 Code" = Field ("Global Dimension 2 Filter"),
                "Location Code" = Field ("Location Filter"), "Drop Shipment" = Field ("Drop Shipment Filter"), "Variant Code" = Field ("Variant Filter"),
                "Shipment Date" = Field ("Date Filter")));
            AccessByPermission = TableData "Sales Shipment Header" = R;
            DecimalPlaces = 0 : 5;
        }
    }
}