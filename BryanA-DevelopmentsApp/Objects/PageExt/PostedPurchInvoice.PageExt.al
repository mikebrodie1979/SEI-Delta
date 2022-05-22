pageextension 80040 "BA Post. Purch. Inv." extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Document Date")
        {
            field("Expected Receipt Date2"; Rec."Expected Receipt Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        modify("Expected Receipt Date")
        {
            ApplicationArea = all;
            Visible = false;
        }
    }
}