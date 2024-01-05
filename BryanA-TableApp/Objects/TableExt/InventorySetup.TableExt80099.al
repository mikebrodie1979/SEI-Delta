tableextension 80099 "BA Inventory Setup" extends "Inventory Setup"
{
    fields
    {
        field(80000; "BA Default Location Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Default Location Code';
            TableRelation = Location.Code;
        }
    }
}