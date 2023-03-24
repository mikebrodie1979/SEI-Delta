tableextension 80089 "BA Approval Entry" extends "Approval Entry"
{
    fields
    {
        field(80000; "BA Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.';
            Editable = false;
            TableRelation = Customer."No.";
            ValidateTableRelation = false;
        }
        field(80001; "BA Customer Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Name';
            Editable = false;
        }
        field(80002; "BA Payment Terms Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Payment Terms Code';
            Editable = false;
        }
        field(80003; "BA Credit Limit"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Credit Limit';
            Editable = false;
        }
        field(80005; "BA Last Sales Activity"; Date)
        {
            Caption = 'Last Sales Activity';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (Customer."BA Last Sales Activity" where ("No." = Field ("BA Customer No.")));
        }
    }
}