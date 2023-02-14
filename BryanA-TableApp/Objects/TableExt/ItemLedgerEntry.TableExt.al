tableextension 80069 "BA Item Ledger Entry" extends "Item Ledger Entry"
{
    fields
    {
        field(80000; "BA Year-end Adjst."; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Year-end Inventory Adjustment';
            Editable = false;
        }
        field(80011; "BA Adjust. Reason"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Adjustment Reason';
            Editable = false;
        }
        field(80012; "BA Approved By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Approved By';
            TableRelation = "User Setup"."User ID";
            Editable = false;
        }
    }
}