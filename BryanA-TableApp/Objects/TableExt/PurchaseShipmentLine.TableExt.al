tableextension 80016 "BA Return Shpt. Line" extends "Return Shipment Line"
{
    fields
    {
        field(80001; "BA Requisition Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Requisition Order';
            Editable = false;
            Description = 'System field to specify Requisition Orders';
        }
        // field(80005; "BA Direct Unit Cost"; Decimal)
        // {
        //     DataClassification = CustomerContent;
        //     Caption = 'Direct Unit Cost';
        //     // CaptionClass = GetCaptionClass(FieldNo("BA Direct Unit Cost"));
        //     // AutoFormatExpression = GetCurrencyCode;
        //     Editable = false;
        // }
        field(80006; "BA Line Discount Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Line Discount Amount';
            // AutoFormatExpression = GetCurrencyCode;
            Editable = false;
        }
    }


    LOCAL procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        Field: Record Field;
    begin
        Field.GET(DATABASE::"Purch. Rcpt. Line", FieldNumber);
        EXIT(Field."Field Caption");
    end;

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    begin
        case FieldNumber of
            FIELDNO("No."):
                EXIT(STRSUBSTNO('3,%1', GetFieldCaption(FieldNumber)));
        end;
    end;

    local procedure GetCurrencyCode(): Code[10]
    var
        ReturnShptHdr: Record "Return Shipment Header";
    begin
        if ReturnShptHdr.Get(Rec."Document No.") then
            exit(ReturnShptHdr."Currency Code");
        exit('');
    end;
}