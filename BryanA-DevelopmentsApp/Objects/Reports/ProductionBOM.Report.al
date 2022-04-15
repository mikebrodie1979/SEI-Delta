report 50070 "BA Production BOM"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.\Objects\ReportLayouts\ProductionBOMReport.rdl';
    Caption = 'Production BOM';

    dataset
    {
        dataitem("Production BOM Header"; "Production BOM Header")
        {
            RequestFilterFields = "No.";

            column(No; "No.") { }
            column(TotalUnitCost; "ENC Total Unit Cost") { }
            column(ActiveVersionNo; "ENC Active Version No.") { }
            column(Description; Description) { }
            column(Description2; "Description 2") { }
            column(UoM; "Unit of Measure Code") { }
            column(LastDateModified; "Last Date Modified") { }
            column(DrawingNo; "ENC Drawing No.") { }
            column(DrawingRevNo; "ENC Drawing Rev. No.") { }
            column(GenProdPostingGroup; "ENC Gen. Prod. Posting Grp.") { }
            column(ManufacturingPolicy; "ENC Manufacturing Policy") { }
            column(ReplenishmentSystem; "ENC Replenishment System") { }
            column(Status; Status) { }


            dataitem("Production BOM Line"; "Production BOM Line")
            {
                DataItemLink = "Production BOM No." = field ("No."), "Version Code" = field ("ENC Active Version No.");

                column(Line_ProdBOMNo; "Production BOM No.") { }
                column(Line_LineNo; "Line No.") { }
                column(Type; Type) { }
                column(LineNo; "No.") { }
                column(Line_ReplenishmentSystem; "ENC Replenishment System") { }
                column(Line_ManufacturingPolicy; "ENC Manufacturing Policy") { }
                column(Association; "ENC Association") { }
                column(AuthorizeItem; "ENC Authorize Item") { }
                column(Line_Description; Description) { }
                column(Line_Desc2; "ENC Desc2") { }
                column(LineDescription2; "ENC Description 2") { }
                column(Quantity; Quantity) { }
                column(QuantityPer; "Quantity per") { }
                column(PartNo; "ENC Part") { }
                column(PartDescription; "ENC Part Description") { }
                column(PartQty; "ENC Part Qty.") { }
                column(UnitCost; "ENC Unit Cost") { }
                column(VendorItemNo; "ENC Vendor Item No.") { }
                column(VendorNo; "ENC Vendor No.") { }
                column(VariantCode; "Variant Code") { }
                column(Scrap; "Scrap %") { }
                column(RoutingLinkCode; "Routing Link Code") { }
                column(Line_UoM; "Unit of Measure Code") { }

                //Line
                trigger OnPreDataItem()
                begin
                end;

                trigger OnAfterGetRecord()
                begin

                end;
            }

            //Header
            trigger OnPreDataItem()
            begin
            end;

            trigger OnAfterGetRecord()
            begin
            end;
        }
    }


    requestpage
    {
        SaveValues = true;
    }
}