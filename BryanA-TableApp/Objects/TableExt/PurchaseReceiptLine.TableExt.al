tableextension 80010 "BA Purch. Rcpt. Line" extends "Purch. Rcpt. Line"
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

    local procedure GetCurrencyCode(): Code[10]
    var
        PurchRcptHdr: Record "Purch. Rcpt. Header";
    begin
        if PurchRcptHdr.Get(Rec."Document No.") then
            exit(PurchRcptHdr."Currency Code");
        exit('');
    end;
}