report 50086 "BA Populate DrillDown"
{
    Caption = 'Populate DrillDown';
    Permissions = tabledata customer = m,
    tabledata "Sales Header" = d;

    ApplicationArea = all;
    UsageCategory = Tasks;
    ProcessingOnly = true;
    UseRequestPage = false;

    // trigger OnPreReport()
    // var
    //     SalesHeader: Record "Sales Header";
    // begin
    //     if not Confirm('Delete SR001358?') then
    //         exit;

    // end;
    trigger OnPostReport()
    var
        Install: Codeunit "BA Install Codeunit";
    begin
        Install.PopulateDropDownFields();
    end;
}