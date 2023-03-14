tableextension 80076 "BA Dimension Value" extends "Dimension Value"
{
    fields
    {
        field(80000; "BA Date Created"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Created';
            Editable = false;
        }
        field(80001; "BA Division"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where (Blocked = const (false), "Global Dimension No." = const (1), "ENC Inactive" = const (false));

            trigger OnValidate()
            begin
                if (Rec."BA Division" <> '') and (xRec."BA Division" = '') then
                    if Rec."Global Dimension No." = 1 then
                        FieldError("BA Division");
            end;
        }
    }

    trigger OnAfterInsert()
    begin
        "BA Date Created" := Today();
    end;
}