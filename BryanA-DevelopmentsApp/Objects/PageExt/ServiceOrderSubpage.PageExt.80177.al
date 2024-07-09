pageextension 80177 "BA Service ORder Subpage" extends "Service Order Subform"
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