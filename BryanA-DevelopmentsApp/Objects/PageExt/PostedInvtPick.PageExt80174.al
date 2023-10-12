pageextension 80174 "BA Posted Invt. Pick" extends "Posted Invt. Pick"
{
    layout
    {
        addlast(General)
        {
            field("BA Sales Order No."; "BA Sales Order No.")
            {
                ApplicationArea = all;
            }
        }
    }
}