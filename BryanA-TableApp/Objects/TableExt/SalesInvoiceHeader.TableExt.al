tableextension 80061 "BA Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        field(80011; "BA Sell-to County Fullname"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Province/State Fullname';
            Editable = false;
        }
        field(80012; "BA Bill-to County Fullname"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Province/State Fullname';
            Editable = false;
        }
        field(80013; "BA Ship-to County Fullname"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Province/State Fullname';
            Editable = false;
        }
    }
}