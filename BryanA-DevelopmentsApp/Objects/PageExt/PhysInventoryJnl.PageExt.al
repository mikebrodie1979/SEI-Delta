pageextension 80087 "BA Phys. Inventory Jnl." extends "Phys. Inventory Journal"
{
    layout
    {
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
        }
    }
}