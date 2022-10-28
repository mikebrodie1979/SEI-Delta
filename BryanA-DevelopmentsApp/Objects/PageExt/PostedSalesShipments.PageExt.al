pageextension 80130 "BA Posted Sales Shipments" extends "Posted Sales Shipments"
{
    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("BA Has Non-G/L Lines", true);
        Rec.FilterGroup(0);
    end;
}