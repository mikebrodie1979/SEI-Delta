pageextension 80178 "BA Service Quote Subpage" extends "Service Quote Subform"
{
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec."Response Date" = 0D then
            Rec.Validate("Response Date", WorkDate());
    end;
}