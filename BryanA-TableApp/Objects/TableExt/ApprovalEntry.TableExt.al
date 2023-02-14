tableextension 80101 "BA Approval Entry" extends "Approval Entry"
{
    fields
    {
        field(80000; "BA Journal Batch Name"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Journal Batch Name';
            TableRelation = "Item Journal Batch".Name where ("Journal Template Name" = const ('ITEM'));
        }
    }
}