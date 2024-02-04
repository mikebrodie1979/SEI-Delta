tableextension 80102 "BA Tax Group" extends "Tax Group"
{
    fields
    {
        field(80000; "BA Non-Taxable"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
}