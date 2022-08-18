tableextension 80012 "BA Item" extends Item
{
    fields
    {
        Field(80000; "BA Qty. on Sales Quote"; Decimal)
        {
            Caption = 'Qty. on Open Sales Quote';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum ("Sales Line"."Outstanding Qty. (Base)"
            where ("Document Type" = Const (Quote), Type = Const (Item), "No." = Field ("No."),
                "Shortcut Dimension 1 Code" = Field ("Global Dimension 1 Filter"), "Shortcut Dimension 2 Code" = Field ("Global Dimension 2 Filter"),
                "Location Code" = Field ("Location Filter"), "Drop Shipment" = Field ("Drop Shipment Filter"), "Variant Code" = Field ("Variant Filter"),
                "Shipment Date" = Field ("Date Filter"), "BA Stage" = const (Open)));
            AccessByPermission = TableData "Sales Shipment Header" = R;
            DecimalPlaces = 0 : 5;
        }
        field(80001; "BA Last USD Purch. Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Last USD Purchase Cost';
        }
        field(80002; "BA Qty. on Closed Sales Quote"; Decimal)
        {
            Caption = 'Qty. on Archived Sales Quote';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum ("Sales Line"."Outstanding Qty. (Base)"
            where ("Document Type" = Const (Quote), Type = Const (Item), "No." = Field ("No."),
                "Shortcut Dimension 1 Code" = Field ("Global Dimension 1 Filter"), "Shortcut Dimension 2 Code" = Field ("Global Dimension 2 Filter"),
                "Location Code" = Field ("Location Filter"), "Drop Shipment" = Field ("Drop Shipment Filter"), "Variant Code" = Field ("Variant Filter"),
                "Shipment Date" = Field ("Date Filter"), "BA Stage" = Filter (Archive | "Closed/Lost" | "Closed/Other")));
            AccessByPermission = TableData "Sales Shipment Header" = R;
            DecimalPlaces = 0 : 5;
        }
        field(80010; "BA ETL Approved Fabric"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'ETL Approved Fabric';
        }
    }

    procedure SetLastCurrencyPurchCost(CurrCode: Code[10]; LastPurchCost: Decimal)
    begin
        case CurrCode of
            'USD':
                Rec.Validate("BA Last USD Purch. Cost", LastPurchCost);
            else
                Error('Invalid purchase currency: %1', CurrCode);
        end;
    end;

    procedure GetLastCurrencyPurchCost(CurrCode: Code[10]): Decimal
    begin
        case CurrCode of
            'USD':
                exit(Rec."BA Last USD Purch. Cost");
            else
                Error('Invalid purchase currency: %1', CurrCode);
        end;
    end;
}