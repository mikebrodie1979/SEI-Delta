pageextension 80042 "BA Post. Purch. Shpt." extends "Posted Return Shipment"
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
    }
}