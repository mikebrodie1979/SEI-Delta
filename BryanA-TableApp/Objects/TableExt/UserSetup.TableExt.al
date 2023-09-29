tableextension 80024 "BA User Setup" extends "User Setup"
{
    fields
    {
        field(80000; "BA Job Title"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Job Title';
        }
        field(80001; "BA Allow Changing Counties"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Changing Provinces/States';
        }
        field(80002; "BA Allow Changing Regions"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Changing Regions';
        }
        field(80003; "BA Allow Changing Countries"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Changing Countries';
        }
        field(80004; "BA Receive Job Queue Notes."; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Receive Job Queue Notifications';
        }
        field(80005; "BA Can Edit Dimensions"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Can Edit Dimensions on SQ/SO';
        }
    }
}