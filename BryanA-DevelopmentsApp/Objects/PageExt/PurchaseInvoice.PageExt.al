pageextension 80058 "BA Purchase Invoice" extends "Purchase Invoice"
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
        modify("Buy-from Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
        }
        addfirst("Buy-from")
        {
            field("BA Buy-from Country/Region Code"; "Buy-from Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
            }
        }
        modify("Pay-to Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
        }
        addfirst(Control88)
        {
            field("BA Pay-to Country/Region Code"; "Pay-to Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
            }
        }
        modify("Ship-to Country/Region Code")
        {
            ApplicationArea = all;
            Visible = false;
            Enabled = false;
        }
        addfirst(Control79)
        {
            field("BA Ship-to Country/Region Code"; "Ship-to Country/Region Code")
            {
                ApplicationArea = all;
                Caption = 'Country';
            }
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

    local procedure GetDimensionCodes()
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        DimMgt.GetDimensionSet(TempDimSetEntry, Rec."Dimension Set ID");
        Rec."BA Product ID Code" := GetDimensionCode(TempDimSetEntry, 'PRODUCT ID');
        Rec."BA Project Code" := GetDimensionCode(TempDimSetEntry, 'PROJECT');
        Rec.Modify(true);
    end;


    local procedure GetDimensionCode(var TempDimSetEntry: Record "Dimension Set Entry"; DimCode: Code[20]): Code[20]
    begin
        TempDimSetEntry.SetRange("Dimension Code", DimCode);
        if TempDimSetEntry.FindFirst() then
            exit(TempDimSetEntry."Dimension Value Code");
        exit('');
    end;

    var
        DimMgt: Codeunit DimensionManagement;
}