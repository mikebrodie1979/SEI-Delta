tableextension 80001 "BA Sales Header" extends "Sales Header"
{
    fields
    {
        field(80000; "BA Copied Doc."; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'System field use to specify if a document was created via CopyDoc codeunit';
            Caption = 'Copied Document';
            Editable = false;
        }
    }
}