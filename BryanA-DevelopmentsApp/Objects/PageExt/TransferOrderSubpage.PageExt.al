pageextension 80092 "BA Transfer Order Subform" extends "Transfer Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("BA Freight Charge Type"; Rec."BA Freight Charge Type")
            {
                ApplicationArea = all;
            }
            field("BA To Freight"; Rec."BA To Freight")
            {
                ApplicationArea = all;
                ShowMandatory = IsFreightOrder;
                Editable = IsFreightOrder;
                Enabled = IsFreightOrder;

                trigger OnLookup(var Text: Text): Boolean
                var
                    TransferLookup: Page "BA Transfer Freight Lookup";
                begin
                    if not IsFreightOrder then
                        exit;
                    TransferLookup.LookupMode(true);
                    if TransferLookup.RunModal() = Action::LookupOK then
                        TransferLookup.GetRecord(Rec."BA To Freight", Rec."BA Transfer No.");
                end;
            }
            field("BA Transfer No."; Rec."BA Transfer No.")
            {
                ApplicationArea = all;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IsFreightOrder := Rec."BA Freight Charge Type" <> Rec."BA Freight Charge Type"::" ";
    end;

    var
        [InDataSet]
        IsFreightOrder: Boolean;
}