pageextension 80001 "BA Purch. Inv. Subpage" extends "Purch. Invoice Subform"
{
    layout
    {
        addafter("Qty. Assigned")
        {
            field("BA SEI Order Type."; Rec."BA SEI Order Type")
            {
                ApplicationArea = all;

                trigger OnValidate()
                begin
                    IsFreightInvoice := Rec."BA SEI Order Type" <> Rec."BA SEI Order Type"::" ";
                end;


            }
            field("BA SEI Order No."; Rec."BA SEI Order No.")
            {
                ApplicationArea = all;
                ShowMandatory = IsFreightInvoice;
                Editable = IsFreightInvoice;
                Enabled = IsFreightInvoice;

                trigger OnLookup(var Text: Text): Boolean
                var
                    SalesLookup: Page "BA Sales Freight Lookup";
                    ServiceLookup: Page "BA Service Freight Lookup";
                begin
                    if not IsFreightInvoice then
                        exit;
                    case Rec."BA SEI Order Type" of
                        Rec."BA SEI Order Type"::"Delta SO", Rec."BA SEI Order Type"::"Int. SO":
                            begin
                                SalesLookup.LookupMode(true);
                                if SalesLookup.RunModal() = Action::LookupOK then
                                    SalesLookup.GetRecord(Rec."BA SEI Order No.", Rec."BA SEI Invoice No.");
                            end;
                        Rec."BA SEI Order Type"::"Delta SVO", Rec."BA SEI Order Type"::"Int. SVO":
                            begin
                                ServiceLookup.LookupMode(true);
                                if ServiceLookup.RunModal() = Action::LookupOK then
                                    ServiceLookup.GetRecord(Rec."BA SEI Order No.", Rec."BA SEI Invoice No.");
                            end;
                    end;

                end;
            }
            field("BA SEI Invoice No."; Rec."BA SEI Invoice No.")
            {
                ApplicationArea = all;
            }
            field("BA Freight Charge Type"; Rec."BA Freight Charge Type")
            {
                ApplicationArea = all;
                ShowMandatory = IsFreightInvoice;
                Editable = IsFreightInvoice;
                Enabled = IsFreightInvoice;
            }
        }
        addafter(ShortcutDimCode4)
        {
            field("BA Sales Person Code"; SalesPersonCode)
            {
                ApplicationArea = all;
                TableRelation = "Dimension Value".Code where ("Dimension Code" = field ("BA Salesperson Filter Code"), "ENC Inactive" = const (false));
                Caption = 'Sales Person Code';

                trigger OnValidate()
                begin
                    ValidateShortcutDimCode(5, SalesPersonCode);
                end;
            }
            field("BA Product ID Code"; Rec."BA Product ID Code")
            {
                ApplicationArea = all;
                Editable = "No." <> '';
            }
            field("BA Project Code"; Rec."BA Project Code")
            {
                ApplicationArea = all;
                Editable = "No." <> '';
            }
        }
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
    }

    actions
    {
        modify(Dimensions)
        {
            trigger OnAfterAction()
            begin
                GetDimensionCodes();
            end;
        }
    }


    trigger OnAfterGetRecord()
    begin
        GetDimensionCodes();
        IsFreightInvoice := Rec."BA SEI Order Type" <> Rec."BA SEI Order Type"::" ";
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SalesPersonCode := '';
        Rec."BA Product ID Code" := '';
        Rec."BA Project Code" := '';
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."BA Salesperson Filter Code" := GLSetup."ENC Salesperson Dim. Code";
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec."BA Salesperson Filter Code" := GLSetup."ENC Salesperson Dim. Code";
    end;

    trigger OnOpenPage()
    begin
        GLSetup.Get;
        GLSetup.TestField("ENC Salesperson Dim. Code");
    end;


    local procedure GetDimensionCodes()
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        DimMgt.GetDimensionSet(TempDimSetEntry, Rec."Dimension Set ID");
        Rec."BA Product ID Code" := GetDimensionCode(TempDimSetEntry, 'PRODUCT ID');
        Rec."BA Project Code" := GetDimensionCode(TempDimSetEntry, 'PROJECT');
        Rec."BA Salesperson Filter Code" := GLSetup."ENC Salesperson Dim. Code";
        SalesPersonCode := GetDimensionCode(TempDimSetEntry, GLSetup."ENC Salesperson Dim. Code");
    end;

    local procedure GetDimensionCode(var TempDimSetEntry: Record "Dimension Set Entry"; DimCode: Code[20]): Code[20]
    begin
        TempDimSetEntry.SetRange("Dimension Code", DimCode);
        if TempDimSetEntry.FindFirst() then
            exit(TempDimSetEntry."Dimension Value Code");
        exit('');
    end;


    var
        GLSetup: Record "General Ledger Setup";
        DimMgt: Codeunit DimensionManagement;
        SalesPersonCode: Code[20];
        [InDataSet]
        IsFreightInvoice: Boolean;
}