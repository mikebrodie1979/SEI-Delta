pageextension 80183 "BA Cust. Template Card" extends "Cust. Template Card"
{
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        CustomerCard: Page "Customer Card";
        RecVar: Variant;
        FieldsToCheck: List of [Integer];
    begin
        if Rec."Code" = '' then
            exit;
        FieldsToCheck.Add(Rec.FieldNo(Rec."ENC Shortcut Dimension 1 Code"));
        FieldsToCheck.Add(Rec.FieldNo(Rec."ENC Shortcut Dimension 2 Code"));
        RecVar := Rec;
        CustomerCard.CheckMandatoryFields(RecVar, FieldsToCheck);
    end;
}