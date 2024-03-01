pageextension 80175 "BA Department Codes Lookup" extends "ENC Department Codes Lookup"
{
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if (Rec.GetFilter(Type) = Format(Rec.Type::Manufacturing)) and (Rec.GetFilter("Purchasing Lookup") = 'Yes') then
            Rec."Purchasing Only" := true;
    end;
}