pageextension 80160 "BA Requests To Approve" extends "Requests to Approve"
{
    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetFilter("Table ID", '<>%1', Database::"Item Journal Batch");
        Rec.FilterGroup(0);
    end;
}