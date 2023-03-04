tableextension 80018 "BA Production Order" extends "Production Order"
{
    fields
    {
        field(80000; "BA NC Work Completed"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'NC Work Completed';
        }
        field(80010; "BA All Quantities Completed"; Boolean)
        {
            Caption = 'All Quantites Completed';
            FieldClass = FlowField;
            CalcFormula = - exist ("Prod. Order Line" where ("Prod. Order No." = field ("No."), Status = field (Status), "Remaining Quantity" = filter ('<>0')));
            Editable = false;
        }
        field(80015; "BA Source Version"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Source Version';
            Editable = false;
            TableRelation = "Production BOM Header"."ENC Active Version No." where ("No." = field ("Source No."));
        }
        field(80020; "BA Created By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Created By';
            Editable = false;
            TableRelation = "User Setup"."User ID";
            ValidateTableRelation = false;
        }
        field(80021; "BA Creation Date"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Creation Date';
            Editable = false;
        }
    }

    trigger OnBeforeInsert()
    begin
        Rec."BA Creation Date" := CurrentDateTime();
        Rec."BA Created By" := UserId();
    end;
}