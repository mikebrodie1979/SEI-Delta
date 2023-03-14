pageextension 80158 "BA Dimension Value List" extends "Dimension Value List"
{
    layout
    {
        addlast(Control1)
        {
            field("BA Date Created"; Rec."BA Date Created")
            {
                ApplicationArea = all;
            }
            field("BA Division"; Rec."BA Division")
            {
                ApplicationArea = all;
                Editable = IsNotDivDim;
                Enabled = IsNotDivDim;
                Visible = IsNotDivDim;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IsNotDivDim := Rec."Global Dimension No." <> 1;
    end;

    var
        [InDataSet]
        IsNotDivDim: Boolean;
}