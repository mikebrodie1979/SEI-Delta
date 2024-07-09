pageextension 80177 "BA Service Order Subpage" extends "Service Order Subform"
{
    layout
    {
        modify("Response Time (Hours)")
        {
            trigger OnAfterValidate()
            begin
                Rec.Validate("Response Date", WorkDate());
            end;
        }
    }
}