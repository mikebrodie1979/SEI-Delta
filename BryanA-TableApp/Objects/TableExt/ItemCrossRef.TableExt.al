tableextension 80060 "BA Item Cross Ref." extends "Item Cross Reference"
{
    fields
    {
        modify("Cross-Reference Type No.")
        {
            trigger OnAfterValidate()
            var
                Customer: Record Customer;
                Vendor: Record Vendor;
            begin
                if (Rec."Cross-Reference Type No." = '')
                        or not (Rec."Cross-Reference Type" in [Rec."Cross-Reference Type"::Customer, Rec."Cross-Reference Type"::Vendor]) then
                    "BA Cross Refernce Type Name" := ''
                else
                    if Rec."Cross-Reference Type" = Rec."Cross-Reference Type"::Customer then begin
                        Customer.Get(Rec."Cross-Reference Type No.");
                        Rec."BA Cross Refernce Type Name" := Customer.Name;
                    end else begin
                        Vendor.Get(Rec."Cross-Reference Type No.");
                        Rec."BA Cross Refernce Type Name" := Vendor.Name;
                    end;
            end;
        }
        field(80000; "BA Cross Refernce Type Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Cross Refernce Type Name';
            Editable = false;
        }
        field(80001; "BA Default Cross Refernce No."; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Default Cross Refernce No.';

            trigger OnValidate()
            var
                Item: Record Item;
                ItemCrossRef: Record "Item Cross Reference";
            begin
                Item.Get(Rec."Item No.");
                if not "BA Default Cross Refernce No." then begin
                    Item."BA Default Cross-Ref. No." := '';
                    Item.Modify(true);
                    exit;
                end;
                ItemCrossRef.SetRange("Item No.", Rec."Item No.");
                ItemCrossRef.SetFilter("Cross-Reference No.", '<>%1', Rec."Cross-Reference No.");
                ItemCrossRef.SetRange("BA Default Cross Refernce No.", true);
                if ItemCrossRef.FindFirst() then
                    Error(AlreadyDefaultErr, ItemCrossRef."Cross-Reference No.", ItemCrossRef.FieldCaption("Cross-Reference No."));
                Item."BA Default Cross-Ref. No." := Rec."Cross-Reference No.";
                Item.Modify(true);
            end;
        }
    }

    var
        AlreadyDefaultErr: Label '%1 has already been set as the default %2 value.', Comment = '%1 = Cross Reference No., %2 = Cross-Reference No. caption';
}