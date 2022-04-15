tableextension 80006 "BA Purch. & Payables Setup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(80000; "BA Requisition Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Requisition Nos.';
            TableRelation = "No. Series".Code;
        }
    }
}