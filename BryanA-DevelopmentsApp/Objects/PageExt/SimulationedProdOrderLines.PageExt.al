pageextension 80115 "BA Simulated Prod. Order Lines" extends "Simulated Prod. Order Lines"
{
    layout
    {
        modify("Location Code")
        {
            trigger OnLookup(var Text: Text): Boolean
            var
                Subscribers: Codeunit "BA SEI Subscibers";
            begin
                Text := Subscribers.LocationListLookup();
                exit(Text <> '');
            end;
        }
        modify("Item No.")
        {
            ApplicationArea = all;
            trigger OnAfterValidate()
            begin
                CalcFields("BA Default Cross-Ref. No.", "BA Default Vendor No.");
            end;
        }
        addafter("Item No.")
        {
            field("BA Default Vendor No."; "BA Default Vendor No.")
            {
                ApplicationArea = all;
            }
            field("BA Default Cross-Ref. No."; "BA Default Cross-Ref. No.")
            {
                ApplicationArea = all;
            }
            field("BA NC Work Completed"; "BA NC Work Completed")
            {
                ApplicationArea = all;
            }
        }
    }
}