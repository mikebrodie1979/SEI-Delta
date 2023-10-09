pageextension 80130 "BA Posted Invt. Pick List" extends "Posted Invt. Pick List"
{
    layout
    {
        addlast(Control1)
        {
            field("Destination No."; "Destination No.")
            {
                ApplicationArea = all;
                CaptionClass = Format(WMSMgt.GetCaption("Destination Type", "Source Document", 0));
            }
            field("Destination Type"; WMSMgt.GetDestinationName("Destination Type", "Destination No."))
            {
                ApplicationArea = all;
                CaptionClass = Format(WMSMgt.GetCaption("Destination Type", "Source Document", 1));
            }
            field("BA Sales Order No."; "BA Sales Order No.")
            {
                ApplicationArea = all;
            }
        }
    }

    var
        WMSMgt: Codeunit "WMS Management";
}