tableextension 80012 "BA Item" extends Item
{
    fields
    {
        field(80000; "BA Last USD Purch. Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Last USD Purchase Cost';
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