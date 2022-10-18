tableextension 80070 "BA Prod. BOM Line" extends "Production BOM Line"
{
    fields
    {
        field(80000; "BA Default Vendor No."; Code[30])
        {
            Caption = 'Default Vendor No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup ("Item Cross Reference"."Cross-Reference Type No." where ("Item No." = field ("No."),
                "Cross-Reference Type" = const (Vendor), "Cross-Reference No." = field ("BA Default Cross-Ref. No.")));
        }
        field(80001; "BA Default Cross-Ref. No."; Code[20])
        {
            Caption = 'Default Cross-Ref. No.';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup ("Item Cross Reference"."Cross-Reference No." where ("Item No." = field ("No."),
                "Cross-Reference Type" = const (Vendor), "BA Default Cross Refernce No." = const (true)));
        }
        field(80005; "BA Balloon Position"; BigInteger)
        {
            DataClassification = CustomerContent;
            Caption = 'Balloon Position';
        }



        // field(75010; "ENC Vendor No."; Code[20])
        // {
        //     Caption = 'Vendor No.';
        //     Editable = false;
        //     FieldClass = FlowField;
        //     CalcFormula = lookup (Item."Vendor No." where ("No." = field ("No."), Type = field ("ENC Filter Type")));

        //     trigger OnLookup()
        //     var
        //         Vendor: Record Vendor;
        //     begin
        //         if "ENC Vendor No." = '' then
        //             exit;
        //         if Vendor.Get("ENC Vendor No.") then
        //             Page.Run(Page::"Vendor Card", Vendor);
        //     end;
        // }
        // field(75011; "ENC Vendor Item No."; Code[20])
        // {
        //     Caption = 'Vendor Item No.';
        //     Editable = false;
        //     FieldClass = FlowField;
        //     CalcFormula = lookup (Item."Vendor Item No." where ("No." = field ("No."), Type = field ("ENC Filter Type")));
        // }
        // field(75012; "ENC Filter Type"; Option)
        // {
        //     Caption = 'Filter Type';
        //     Editable = false;
        //     OptionMembers = " ",Item,"Production BOM";
        //     FieldClass = FlowFilter;
        // }
    }
}