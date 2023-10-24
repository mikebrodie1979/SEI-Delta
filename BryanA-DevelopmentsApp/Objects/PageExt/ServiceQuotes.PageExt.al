pageextension 80093 "BA Serv ice Quotes" extends "Service Quotes"
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
        addlast(Control1)
        {
            field("BA Amount"; "BA Amount")
            {
                ApplicationArea = all;
            }
            field("BA Amount Including VAT"; "BA Amount Including Tax")
            {
                ApplicationArea = all;
            }
            field("BA Amount Including Tax (LCY)"; "BA Amount Including Tax (LCY)")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("BA Amount", "BA Amount Including Tax", "BA Amount Including Tax (LCY)");
    end;
}