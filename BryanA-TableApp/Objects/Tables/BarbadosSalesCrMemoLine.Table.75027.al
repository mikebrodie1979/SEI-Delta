table 75027 "BA Bar. Sales Cr.Memo Line"
{
    DataClassification = CustomerContent;
    Caption = 'BardadosSales Cr.Memo Line';

    fields
    {
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(11; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(12; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(13; "Unit of Measure"; Text[10])
        {
            Caption = 'Unit of Measure';
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(22; "Unit Price"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Unit Price"));
            Caption = 'Unit Price';
        }
        field(27; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(28; "Line Discount Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
        }
        field(29; Amount; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(68; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            Editable = false;
        }
        field(75; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        field(85; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
        }
        field(86; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(103; "Line Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Line Amount"));
            Caption = 'Line Amount';
        }
        field(131; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(5415; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(80000; "Company Data Source"; Text[30])
        {
        }
        field(80001; "Unit Price After Discount"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(80002; "FX Rate"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(80003; "Unit Price Charged CAD"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(80004; "Line Amount Charged CAD"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
        }
        key(Key3; "Sell-to Customer No.") { }
        key(Key6; "Bill-to Customer No.") { }
        key(Key7; "Posting Date") { }
    }

    local procedure GetCurrencyCode(): Code[10]
    var
        BarbadosSalesCrMemoHeader: Record "BA Bar. Sales Cr.Memo Header";
    begin
        BarbadosSalesCrMemoHeader.Get(Rec."Document No.");
        exit(BarbadosSalesCrMemoHeader."Currency Code");
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        FieldRec: Record Field;
    begin
        FieldRec.Get(Database::"Sales Cr.Memo Line", FieldNumber);
        exit(FieldRec."Field Caption");
    end;

    procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    begin
        if FieldNumber = FIELDNO("No.") then
            exit(StrSubstNo('3,%1', GetFieldCaption(FieldNumber)));
        exit('2,0,' + GetFieldCaption(FieldNumber));
    end;
}

