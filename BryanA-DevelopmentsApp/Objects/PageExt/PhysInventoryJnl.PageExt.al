pageextension 80090 "BA Phys. Inventory Jnl." extends "Phys. Inventory Journal"
{
    layout
    {
        addfirst(Control1)
        {
            field("BA Created At"; "BA Created At")
            {
                ApplicationArea = all;
            }
        }
        addafter(Description)
        {
            field("BA Updated"; "BA Updated")
            {
                ApplicationArea = all;
                Caption = 'Year-End Inventory Adjustment';
                Editable = true;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action("BA Import Item Inventory")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = PhysicalInventory;
                Caption = 'Import Item Inventory';

                trigger OnAction()
                var
                    ImportInventory: Report "BA Physical Inventory Import";
                begin
                    ImportInventory.SetParameters(Rec);
                    ImportInventory.RunModal();
                end;
            }
            action("BA View Import Errors")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = PhysicalInventoryLedger;
                Caption = 'View Inventory Import Errors';
                RunObject = page "BA Phys. Invt. Import Errors";
            }
        }
    }
}