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
        field(80020; "BA Default Vendor No."; Code[30])
        {
            Caption = 'Default Vendor No.';
            FieldClass = FlowField;
            CalcFormula = lookup ("Item Cross Reference"."Cross-Reference Type No." where ("Item No." = field ("No."), "Cross-Reference Type" = const (Vendor), "Cross-Reference No." = field ("BA Default Cross-Ref. No.")));
        }
        field(80021; "BA Default Cross-Ref. No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Default Cross-Ref. No.';
            TableRelation = "Item Cross Reference"."Cross-Reference No." where ("Item No." = field ("No."), "Cross-Reference Type" = const (Vendor));
            trigger OnValidate()
            var
                ItemCrossRef: Record "Item Cross Reference";
            begin
                CalcFields("BA Default Vendor No.");
                ItemCrossRef.SetRange("Item No.", Rec."No.");
                ItemCrossRef.ModifyAll("BA Default Cross Refernce No.", false, false);
                if Rec."BA Default Cross-Ref. No." = '' then
                    exit;
                ItemCrossRef.SetRange("Cross-Reference No.", Rec."BA Default Cross-Ref. No.");
                ItemCrossRef.SetRange("Cross-Reference Type", ItemCrossRef."Cross-Reference Type"::Vendor);
                ItemCrossRef.SetRange("Cross-Reference Type No.", Rec."BA Default Vendor No.");
                ItemCrossRef.FindFirst();
                ItemCrossRef."BA Default Cross Refernce No." := true;
                ItemCrossRef.Modify(true);
            end;
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