tableextension 80105 "BA Work Center" extends "Work Center"
{
    fields
    {
        field(80000; "BA Description"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(80001; "BA Bambi Only Center"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Bambi Only Center';
        }
        field(80002; "BA Hourly Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Hourly Rate';
            Editable = false;
        }
        modify("Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                if (Rec."Unit Cost Calculation" <> Rec."Unit Cost Calculation"::Time) or (Rec."Unit of Measure Code" <> 'MINUTES') then
                    exit;
                Rec.Validate("BA Hourly Rate", Rec."Unit Cost" * 60);
                Rec.Modify(true);
            end;
        }
    }
}