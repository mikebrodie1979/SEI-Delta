tableextension 80049 "BA Item Jnl. Line" extends "Item Journal Line"
{
    fields
    {
        field(80000; "BA Updated"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Updated';
            Editable = false;
            Description = 'System field used for Physical Inventory import';
        }
        field(80001; "BA Created At"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Created At';
            Editable = false;
        }
        field(80002; "BA Warning Message"; Text[256])
        {
            DataClassification = CustomerContent;
            Caption = 'Warning Message';
            Editable = false;
        }

        field(80011; "BA Adjust. Reason"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Adjustment Reason';
        }
        field(80012; "BA Approved By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Approved By';
            TableRelation = "User Setup"."User ID";
            Editable = false;
        }
        field(80013; "BA Status"; Enum "BA Approval Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
            Editable = false;
        }
        field(80014; "BA Locked For Approval"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Locked For Approval';
            Editable = false;
        }
        field(80015; "BA Approval GUID"; Guid)
        {
            DataClassification = CustomerContent;
            Caption = 'Approval GUID';
            Editable = false;
        }
    }
}